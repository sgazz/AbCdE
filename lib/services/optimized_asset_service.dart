import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/optimized_memory_manager.dart';
import 'performance_service.dart';

class OptimizedAssetService {
  static final OptimizedAssetService _instance = OptimizedAssetService._internal();
  factory OptimizedAssetService() => _instance;
  OptimizedAssetService._internal();

  final OptimizedMemoryManager _memoryManager = OptimizedMemoryManager();
  final PerformanceService _performanceService = PerformanceService();
  
  // Asset cache
  final Map<String, Uint8List> _assetCache = {};
  final Map<String, DateTime> _assetTimestamps = {};
  final Map<String, int> _assetSizes = {};
  
  // Loading queues
  final Map<String, Completer<Uint8List>> _loadingAssets = {};
  final Queue<String> _loadQueue = Queue<String>();
  
  // Configuration
  static const int _maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const Duration _assetExpiration = Duration(hours: 2);
  static const int _maxConcurrentLoads = 3;
  
  // Statistics
  int _totalAssetsLoaded = 0;
  int _totalBytesLoaded = 0;
  int _cacheHits = 0;
  int _cacheMisses = 0;

  // Initialize the service
  void initialize() {
    _memoryManager.createPool<Uint8List>('asset_pool', 50);
    _performanceService.trackEvent('asset_service_initialized');
  }

  // Load asset with caching
  Future<Uint8List> loadAsset(String assetPath) async {
    // Check cache first
    final cachedAsset = _assetCache[assetPath];
    if (cachedAsset != null) {
      _cacheHits++;
      _assetTimestamps[assetPath] = DateTime.now();
      _performanceService.trackEvent('asset_cache_hit', parameters: {
        'asset': assetPath,
      });
      return cachedAsset;
    }

    _cacheMisses++;
    
    // Check if already loading
    if (_loadingAssets.containsKey(assetPath)) {
      return _loadingAssets[assetPath]!.future;
    }

    // Create new loading task
    final completer = Completer<Uint8List>();
    _loadingAssets[assetPath] = completer;
    _loadQueue.add(assetPath);

    // Process queue
    _processLoadQueue();

    return completer.future;
  }

  // Process the loading queue
  void _processLoadQueue() {
    if (_loadingAssets.length >= _maxConcurrentLoads) {
      return;
    }

    while (_loadQueue.isNotEmpty && _loadingAssets.length < _maxConcurrentLoads) {
      final assetPath = _loadQueue.removeFirst();
      _loadAssetFromBundle(assetPath);
    }
  }

  // Load asset from bundle
  Future<void> _loadAssetFromBundle(String assetPath) async {
    final startTime = DateTime.now();
    
    try {
      final assetData = await rootBundle.load(assetPath);
      final bytes = assetData.buffer.asUint8List();
      
      // Cache the asset
      _cacheAsset(assetPath, bytes);
      
      // Complete the loading
      final completer = _loadingAssets[assetPath];
      if (completer != null) {
        completer.complete(bytes);
        _loadingAssets.remove(assetPath);
      }
      
      // Update statistics
      _totalAssetsLoaded++;
      _totalBytesLoaded += bytes.length;
      
      // Track performance
      final loadTime = DateTime.now().difference(startTime);
      _performanceService.trackAnimationPerformance('AssetLoad_$assetPath', loadTime);
      
      // Process next item in queue
      _processLoadQueue();
      
    } catch (e, stackTrace) {
      // Handle error
      final completer = _loadingAssets[assetPath];
      if (completer != null) {
        completer.completeError(e, stackTrace);
        _loadingAssets.remove(assetPath);
      }
      
      _performanceService.trackError('Asset load failed: $assetPath', stackTrace);
    }
  }

  // Cache asset with size management
  void _cacheAsset(String assetPath, Uint8List assetData) {
    final assetSize = assetData.length;
    
    // Check if adding this asset would exceed cache limit
    if (_getTotalCacheSize() + assetSize > _maxCacheSize) {
      _evictOldestAssets(assetSize);
    }
    
    _assetCache[assetPath] = assetData;
    _assetTimestamps[assetPath] = DateTime.now();
    _assetSizes[assetPath] = assetSize;
    
    _memoryManager.setCache('asset_$assetPath', assetData, size: assetSize);
  }

  // Evict oldest assets to make space
  void _evictOldestAssets(int requiredSpace) {
    final sortedEntries = _assetTimestamps.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    
    int freedSpace = 0;
    final keysToRemove = <String>[];
    
    for (final entry in sortedEntries) {
      final key = entry.key;
      final size = _assetSizes[key] ?? 0;
      
      keysToRemove.add(key);
      freedSpace += size;
      
      if (freedSpace >= requiredSpace) {
        break;
      }
    }
    
    for (final key in keysToRemove) {
      _removeAssetFromCache(key);
    }
  }

  // Remove asset from cache
  void _removeAssetFromCache(String assetPath) {
    final size = _assetSizes[assetPath] ?? 0;
    _assetCache.remove(assetPath);
    _assetTimestamps.remove(assetPath);
    _assetSizes.remove(assetPath);
    
    _performanceService.trackEvent('memory_deallocation', parameters: {
      'type': 'Asset_$assetPath',
    });
  }

  // Get total cache size
  int _getTotalCacheSize() {
    return _assetSizes.values.fold(0, (sum, size) => sum + size);
  }

  // Preload assets
  Future<void> preloadAssets(List<String> assetPaths) async {
    final futures = assetPaths.map((path) => loadAsset(path));
    await Future.wait(futures);
    
    _performanceService.trackEvent('assets_preloaded', parameters: {
      'count': assetPaths.length,
    });
  }

  // Clear expired assets
  void clearExpiredAssets() {
    final now = DateTime.now();
    final expiredKeys = <String>[];
    
    for (final entry in _assetTimestamps.entries) {
      if (now.difference(entry.value) > _assetExpiration) {
        expiredKeys.add(entry.key);
      }
    }
    
    for (final key in expiredKeys) {
      _removeAssetFromCache(key);
    }
    
    if (expiredKeys.isNotEmpty) {
      _performanceService.trackEvent('expired_assets_cleared', parameters: {
        'count': expiredKeys.length,
      });
    }
  }

  // Clear all assets
  void clearAllAssets() {
    final assetCount = _assetCache.length;
    _assetCache.clear();
    _assetTimestamps.clear();
    _assetSizes.clear();
    
    _performanceService.trackEvent('all_assets_cleared', parameters: {
      'count': assetCount,
    });
  }

  // Get asset statistics
  Map<String, dynamic> getAssetStats() {
    return {
      'totalAssetsLoaded': _totalAssetsLoaded,
      'totalBytesLoaded': _totalBytesLoaded,
      'cacheHits': _cacheHits,
      'cacheMisses': _cacheMisses,
      'cacheHitRate': _cacheHits / (_cacheHits + _cacheMisses),
      'cachedAssets': _assetCache.length,
      'cacheSize': _getTotalCacheSize(),
      'loadingAssets': _loadingAssets.length,
      'queueLength': _loadQueue.length,
    };
  }

  // Check if asset is cached
  bool isAssetCached(String assetPath) {
    return _assetCache.containsKey(assetPath);
  }

  // Get cached asset size
  int getCachedAssetSize(String assetPath) {
    return _assetSizes[assetPath] ?? 0;
  }

  // Dispose
  void dispose() {
    clearAllAssets();
    _loadingAssets.clear();
    _loadQueue.clear();
  }
}

// Optimized image loader widget
class OptimizedImageLoader extends StatefulWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const OptimizedImageLoader({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<OptimizedImageLoader> createState() => _OptimizedImageLoaderState();
}

class _OptimizedImageLoaderState extends State<OptimizedImageLoader>
    with MemoryAwareMixin {
  final OptimizedAssetService _assetService = OptimizedAssetService();
  Uint8List? _imageData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final imageData = await _assetService.loadAsset(widget.imagePath);
      
      if (mounted) {
        setState(() {
          _imageData = imageData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.placeholder ?? const CircularProgressIndicator();
    }

    if (_error != null) {
      return widget.errorWidget ?? 
             Icon(Icons.error, color: Colors.red, size: 50);
    }

    if (_imageData == null) {
      return widget.errorWidget ?? 
             Icon(Icons.image_not_supported, color: Colors.grey, size: 50);
    }

    return Image.memory(
      _imageData!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit ?? BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        return RepaintBoundary(child: child);
      },
    );
  }
} 