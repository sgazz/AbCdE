import 'dart:async';
import 'dart:collection';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/performance_service.dart';

class OptimizedMemoryManager {
  static final OptimizedMemoryManager _instance = OptimizedMemoryManager._internal();
  factory OptimizedMemoryManager() => _instance;
  OptimizedMemoryManager._internal();

  final PerformanceService _performanceService = PerformanceService();
  
  // Memory pools for different types of objects
  final Map<String, Queue<dynamic>> _objectPools = {};
  final Map<String, int> _poolSizes = {};
  final Map<String, int> _allocationCounts = {};
  final Map<String, int> _deallocationCounts = {};
  
  // Cache management
  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final Map<String, int> _cacheSizes = {};
  
  // Memory limits
  static const int _maxCacheSize = 50 * 1024 * 1024; // 50MB
  static const int _maxPoolSize = 100;
  static const Duration _cacheExpiration = Duration(minutes: 30);
  
  // Memory monitoring
  Timer? _cleanupTimer;
  bool _isMonitoring = false;

  void startMonitoring() {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    _cleanupTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _cleanupExpiredCache();
      _logMemoryStats();
    });
    
    developer.log('Memory monitoring started', name: 'OptimizedMemoryManager');
  }

  void stopMonitoring() {
    _isMonitoring = false;
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
    developer.log('Memory monitoring stopped', name: 'OptimizedMemoryManager');
  }

  // Object pool management
  void createPool<T>(String poolName, int maxSize) {
    _objectPools[poolName] = Queue<T>();
    _poolSizes[poolName] = maxSize;
    _allocationCounts[poolName] = 0;
    _deallocationCounts[poolName] = 0;
  }

  T? getFromPool<T>(String poolName) {
    final pool = _objectPools[poolName] as Queue<T>?;
    if (pool != null && pool.isNotEmpty) {
      final obj = pool.removeFirst();
      _deallocationCounts[poolName] = (_deallocationCounts[poolName] ?? 0) + 1;
      _performanceService.trackMemoryDeallocation('Pool_$poolName');
      return obj;
    }
    return null;
  }

  void returnToPool<T>(String poolName, T object) {
    final pool = _objectPools[poolName] as Queue<T>?;
    final maxSize = _poolSizes[poolName] ?? _maxPoolSize;
    
    if (pool != null && pool.length < maxSize) {
      pool.add(object);
      _allocationCounts[poolName] = (_allocationCounts[poolName] ?? 0) + 1;
      _performanceService.trackMemoryAllocation('Pool_$poolName', 1);
    }
  }

  // Cache management
  void setCache<T>(String key, T value, {int? size}) {
    final estimatedSize = size ?? _estimateObjectSize(value);
    
    // Check if adding this item would exceed cache limit
    if (_getTotalCacheSize() + estimatedSize > _maxCacheSize) {
      _evictOldestCacheItems(estimatedSize);
    }
    
    _cache[key] = value;
    _cacheTimestamps[key] = DateTime.now();
    _cacheSizes[key] = estimatedSize;
    
    _performanceService.trackMemoryAllocation('Cache_$key', estimatedSize);
  }

  T? getCache<T>(String key) {
    final value = _cache[key] as T?;
    if (value != null) {
      // Update timestamp to mark as recently used
      _cacheTimestamps[key] = DateTime.now();
    }
    return value;
  }

  void removeCache(String key) {
    final size = _cacheSizes[key] ?? 0;
    _cache.remove(key);
    _cacheTimestamps.remove(key);
    _cacheSizes.remove(key);
    
    _performanceService.trackEvent('memory_deallocation', parameters: {
      'type': 'Cache_$key',
    });
  }

  void clearCache() {
    final totalSize = _getTotalCacheSize();
    _cache.clear();
    _cacheTimestamps.clear();
    _cacheSizes.clear();
    
    _performanceService.trackEvent('memory_deallocation', parameters: {
      'type': 'Cache_clear',
      'size': totalSize,
    });
  }

  // Memory cleanup
  void _cleanupExpiredCache() {
    final now = DateTime.now();
    final expiredKeys = <String>[];
    
    for (final entry in _cacheTimestamps.entries) {
      if (now.difference(entry.value) > _cacheExpiration) {
        expiredKeys.add(entry.key);
      }
    }
    
    for (final key in expiredKeys) {
      removeCache(key);
    }
    
    if (expiredKeys.isNotEmpty) {
      developer.log('Cleaned up ${expiredKeys.length} expired cache items', 
                   name: 'OptimizedMemoryManager');
    }
  }

  void _evictOldestCacheItems(int requiredSpace) {
    final sortedEntries = _cacheTimestamps.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    
    int freedSpace = 0;
    final keysToRemove = <String>[];
    
    for (final entry in sortedEntries) {
      final key = entry.key;
      final size = _cacheSizes[key] ?? 0;
      
      keysToRemove.add(key);
      freedSpace += size;
      
      if (freedSpace >= requiredSpace) {
        break;
      }
    }
    
    for (final key in keysToRemove) {
      removeCache(key);
    }
  }

  // Memory statistics
  int _getTotalCacheSize() {
    return _cacheSizes.values.fold(0, (sum, size) => sum + size);
  }

  int _estimateObjectSize(dynamic obj) {
    if (obj == null) return 0;
    
    if (obj is String) {
      return obj.length * 2; // UTF-16 characters
    } else if (obj is List) {
      return obj.length * 8; // Rough estimate
    } else if (obj is Map) {
      return obj.length * 16; // Rough estimate
    } else if (obj is num) {
      return 8; // 64-bit number
    } else if (obj is bool) {
      return 1;
    }
    
    return 64; // Default size for objects
  }

  void _logMemoryStats() {
    final totalCacheSize = _getTotalCacheSize();
    final cacheItemCount = _cache.length;
    final poolStats = _objectPools.entries.map((entry) {
      return '${entry.key}: ${entry.value.length}/${_poolSizes[entry.key]}';
    }).join(', ');
    
    developer.log('Memory stats - Cache: ${totalCacheSize}KB, Items: $cacheItemCount, Pools: $poolStats',
                 name: 'OptimizedMemoryManager');
  }

  // Memory pressure handling
  void handleMemoryPressure() {
    developer.log('Handling memory pressure', name: 'OptimizedMemoryManager');
    
    // Clear half of the cache
    final cacheKeys = _cache.keys.toList();
    final keysToRemove = cacheKeys.take(cacheKeys.length ~/ 2);
    
    for (final key in keysToRemove) {
      removeCache(key);
    }
    
    // Clear object pools
    for (final pool in _objectPools.values) {
      pool.clear();
    }
    
    _performanceService.trackEvent('memory_pressure_handled');
  }

  // Memory usage report
  Map<String, dynamic> getMemoryReport() {
    return {
      'cacheSize': _getTotalCacheSize(),
      'cacheItems': _cache.length,
      'poolStats': _objectPools.entries.map((entry) {
        return {
          'name': entry.key,
          'currentSize': entry.value.length,
          'maxSize': _poolSizes[entry.key],
          'allocations': _allocationCounts[entry.key] ?? 0,
          'deallocations': _deallocationCounts[entry.key] ?? 0,
        };
      }).toList(),
      'totalAllocations': _allocationCounts.values.fold(0, (sum, count) => sum + count),
      'totalDeallocations': _deallocationCounts.values.fold(0, (sum, count) => sum + count),
    };
  }

  // Dispose
  void dispose() {
    stopMonitoring();
    clearCache();
    _objectPools.clear();
    _poolSizes.clear();
    _allocationCounts.clear();
    _deallocationCounts.clear();
    _cacheTimestamps.clear();
    _cacheSizes.clear();
  }
}

// Memory-aware widget mixin
mixin MemoryAwareMixin<T extends StatefulWidget> on State<T> {
  final OptimizedMemoryManager _memoryManager = OptimizedMemoryManager();
  final List<String> _allocatedResources = [];

  void allocateResource(String resourceName, dynamic resource) {
    _allocatedResources.add(resourceName);
    _memoryManager.setCache(resourceName, resource);
  }

  void deallocateResource(String resourceName) {
    _allocatedResources.remove(resourceName);
    _memoryManager.removeCache(resourceName);
  }

  @override
  void dispose() {
    // Clean up all allocated resources
    for (final resourceName in _allocatedResources) {
      _memoryManager.removeCache(resourceName);
    }
    _allocatedResources.clear();
    super.dispose();
  }
}

// Memory-efficient list widget
class MemoryEfficientListView extends StatefulWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final int? itemCount;
  final Widget? Function(BuildContext, int)? itemBuilder;

  const MemoryEfficientListView({
    super.key,
    this.children = const [],
    this.controller,
    this.padding,
    this.itemCount,
    this.itemBuilder,
  });

  @override
  State<MemoryEfficientListView> createState() => _MemoryEfficientListViewState();
}

class _MemoryEfficientListViewState extends State<MemoryEfficientListView>
    with MemoryAwareMixin {
  final OptimizedMemoryManager _memoryManager = OptimizedMemoryManager();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.controller,
      padding: widget.padding,
      itemCount: widget.itemCount ?? widget.children.length,
      itemBuilder: widget.itemBuilder ?? (context, index) {
        return RepaintBoundary(
          child: widget.children[index],
        );
      },
    );
  }
} 