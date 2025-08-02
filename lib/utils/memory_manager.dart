import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer' as developer;

class MemoryManager {
  static final Map<String, dynamic> _cache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static final List<ChangeNotifier> _controllers = [];
  static final List<Timer> _timers = [];
  static final List<StreamSubscription> _subscriptions = [];
  
  static const Duration _defaultCacheDuration = Duration(minutes: 10);
  static const int _maxCacheSize = 100;
  
  // Cache management
  static void cache<T>(String key, T value, {Duration? duration}) {
    final cacheDuration = duration ?? _defaultCacheDuration;
    
    // Clean old entries if cache is full
    if (_cache.length >= _maxCacheSize) {
      _cleanOldCache();
    }
    
    _cache[key] = value;
    _cacheTimestamps[key] = DateTime.now().add(cacheDuration);
    
    developer.log('Cached: $key', name: 'MemoryManager');
  }
  
  static T? getCached<T>(String key) {
    final timestamp = _cacheTimestamps[key];
    if (timestamp != null && DateTime.now().isBefore(timestamp)) {
      final value = _cache[key];
      if (value is T) {
        developer.log('Cache hit: $key', name: 'MemoryManager');
        return value;
      }
    } else {
      // Remove expired cache
      _cache.remove(key);
      _cacheTimestamps.remove(key);
    }
    return null;
  }
  
  static void removeFromCache(String key) {
    _cache.remove(key);
    _cacheTimestamps.remove(key);
    developer.log('Removed from cache: $key', name: 'MemoryManager');
  }
  
  static void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
    developer.log('Cache cleared', name: 'MemoryManager');
  }
  
  static void _cleanOldCache() {
    final now = DateTime.now();
    final expiredKeys = <String>[];
    
    for (final entry in _cacheTimestamps.entries) {
      if (now.isAfter(entry.value)) {
        expiredKeys.add(entry.key);
      }
    }
    
    for (final key in expiredKeys) {
      _cache.remove(key);
      _cacheTimestamps.remove(key);
    }
    
    developer.log('Cleaned ${expiredKeys.length} expired cache entries', name: 'MemoryManager');
  }
  
  // Controller management
  static void registerController(ChangeNotifier controller) {
    _controllers.add(controller);
    developer.log('Registered controller: ${controller.runtimeType}', name: 'MemoryManager');
  }
  
  static void unregisterController(ChangeNotifier controller) {
    _controllers.remove(controller);
    controller.dispose();
    developer.log('Unregistered controller: ${controller.runtimeType}', name: 'MemoryManager');
  }
  
  static void disposeAllControllers() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
    developer.log('Disposed all controllers', name: 'MemoryManager');
  }
  
  // Timer management
  static void registerTimer(Timer timer) {
    _timers.add(timer);
    developer.log('Registered timer', name: 'MemoryManager');
  }
  
  static void unregisterTimer(Timer timer) {
    _timers.remove(timer);
    timer.cancel();
    developer.log('Unregistered timer', name: 'MemoryManager');
  }
  
  static void cancelAllTimers() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
    developer.log('Cancelled all timers', name: 'MemoryManager');
  }
  
  // Stream subscription management
  static void registerSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
    developer.log('Registered subscription', name: 'MemoryManager');
  }
  
  static void unregisterSubscription(StreamSubscription subscription) {
    _subscriptions.remove(subscription);
    subscription.cancel();
    developer.log('Unregistered subscription', name: 'MemoryManager');
  }
  
  static void cancelAllSubscriptions() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    developer.log('Cancelled all subscriptions', name: 'MemoryManager');
  }
  
  // Memory cleanup
  static void cleanup() {
    _cleanOldCache();
    disposeAllControllers();
    cancelAllTimers();
    cancelAllSubscriptions();
    developer.log('Memory cleanup completed', name: 'MemoryManager');
  }
  
  // Memory usage statistics
  static Map<String, dynamic> getMemoryStats() {
    return {
      'cacheSize': _cache.length,
      'controllersCount': _controllers.length,
      'timersCount': _timers.length,
      'subscriptionsCount': _subscriptions.length,
      'maxCacheSize': _maxCacheSize,
    };
  }
}

// Memory efficient widget mixin
mixin MemoryEfficientMixin<T extends StatefulWidget> on State<T> {
  final List<ChangeNotifier> _localControllers = [];
  final List<Timer> _localTimers = [];
  final List<StreamSubscription> _localSubscriptions = [];
  
  void registerLocalController(ChangeNotifier controller) {
    _localControllers.add(controller);
    MemoryManager.registerController(controller);
  }
  
  void registerLocalTimer(Timer timer) {
    _localTimers.add(timer);
    MemoryManager.registerTimer(timer);
  }
  
  void registerLocalSubscription(StreamSubscription subscription) {
    _localSubscriptions.add(subscription);
    MemoryManager.registerSubscription(subscription);
  }
  
  @override
  void dispose() {
    // Dispose local controllers
    for (final controller in _localControllers) {
      controller.dispose();
    }
    _localControllers.clear();
    
    // Cancel local timers
    for (final timer in _localTimers) {
      timer.cancel();
    }
    _localTimers.clear();
    
    // Cancel local subscriptions
    for (final subscription in _localSubscriptions) {
      subscription.cancel();
    }
    _localSubscriptions.clear();
    
    super.dispose();
  }
}

// Memory efficient image widget
class MemoryEfficientImage extends StatefulWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const MemoryEfficientImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<MemoryEfficientImage> createState() => _MemoryEfficientImageState();
}

class _MemoryEfficientImageState extends State<MemoryEfficientImage> {
  Image? _cachedImage;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() {
    // Check cache first
    final cacheKey = 'image_${widget.imagePath}';
    final cached = MemoryManager.getCached<Image>(cacheKey);
    
    if (cached != null) {
      setState(() {
        _cachedImage = cached;
        _isLoading = false;
      });
      return;
    }

    // Load image
    try {
      final image = Image.asset(
        widget.imagePath,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        errorBuilder: (context, error, stackTrace) {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
          return widget.errorWidget ?? const Icon(Icons.error);
        },
      );

      // Cache the image
      MemoryManager.cache(cacheKey, image);

      setState(() {
        _cachedImage = image;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.placeholder ?? const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return widget.errorWidget ?? const Icon(Icons.error);
    }

    return _cachedImage ?? const SizedBox.shrink();
  }
}

// Memory efficient list widget
class MemoryEfficientList extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;

  const MemoryEfficientList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.physics,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          child: itemBuilder(context, index),
        );
      },
      padding: padding,
      physics: physics,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
    );
  }
}

// Memory monitoring widget
class MemoryMonitor extends StatefulWidget {
  final Widget child;
  final bool showStats;
  final Duration updateInterval;

  const MemoryMonitor({
    super.key,
    required this.child,
    this.showStats = false,
    this.updateInterval = const Duration(seconds: 5),
  });

  @override
  State<MemoryMonitor> createState() => _MemoryMonitorState();
}

class _MemoryMonitorState extends State<MemoryMonitor> {
  Timer? _timer;
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    if (widget.showStats) {
      _startMonitoring();
    }
  }

  void _startMonitoring() {
    _timer = Timer.periodic(widget.updateInterval, (timer) {
      if (mounted) {
        setState(() {
          _stats = MemoryManager.getMemoryStats();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showStats) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 50,
          right: 10,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cache: ${_stats['cacheSize'] ?? 0}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Controllers: ${_stats['controllersCount'] ?? 0}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Timers: ${_stats['timersCount'] ?? 0}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Subscriptions: ${_stats['subscriptionsCount'] ?? 0}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 