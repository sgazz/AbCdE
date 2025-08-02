import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer' as developer;

class PerformanceUtils {
  static final Map<String, Stopwatch> _timers = {};
  static final Map<String, List<double>> _performanceMetrics = {};
  
  // Performance monitoring
  static void startTimer(String name) {
    _timers[name] = Stopwatch()..start();
  }
  
  static void endTimer(String name) {
    final timer = _timers[name];
    if (timer != null) {
      timer.stop();
      final duration = timer.elapsedMicroseconds / 1000.0; // Convert to milliseconds
      
      if (!_performanceMetrics.containsKey(name)) {
        _performanceMetrics[name] = [];
      }
      _performanceMetrics[name]!.add(duration);
      
      // Log performance data
      developer.log('Performance: $name took ${duration.toStringAsFixed(2)}ms', name: 'Performance');
      
      _timers.remove(name);
    }
  }
  
  // Get average performance for a metric
  static double getAveragePerformance(String name) {
    final metrics = _performanceMetrics[name];
    if (metrics == null || metrics.isEmpty) return 0.0;
    
    final sum = metrics.reduce((a, b) => a + b);
    return sum / metrics.length;
  }
  
  // Clear performance data
  static void clearPerformanceData() {
    _performanceMetrics.clear();
    _timers.clear();
  }
  
  // Memory optimization helpers
  static void disposeControllers(List<ChangeNotifier> controllers) {
    for (final controller in controllers) {
      controller.dispose();
    }
  }
  
  // Debounce function for expensive operations
  static Timer? _debounceTimer;
  static void debounce(VoidCallback callback, {Duration duration = const Duration(milliseconds: 300)}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, callback);
  }
  
  // Throttle function for frequent operations
  static DateTime? _lastThrottleTime;
  static bool throttle({Duration duration = const Duration(milliseconds: 100)}) {
    final now = DateTime.now();
    if (_lastThrottleTime == null || now.difference(_lastThrottleTime!) >= duration) {
      _lastThrottleTime = now;
      return true;
    }
    return false;
  }
}

// Optimized widget mixin
mixin OptimizedWidgetMixin<T extends StatefulWidget> on State<T> {
  bool _isDisposed = false;
  
  @override
  void dispose() {
    _isDisposed = false;
    super.dispose();
  }
  
  bool get isDisposed => _isDisposed;
  
  void safeSetState(VoidCallback fn) {
    if (!_isDisposed && mounted) {
      setState(fn);
    }
  }
}

// Memory efficient list builder
class OptimizedListView extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;

  const OptimizedListView({
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
      itemBuilder: itemBuilder,
      padding: padding,
      physics: physics,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
    );
  }
}

// Cached widget for expensive operations
class CachedWidget extends StatefulWidget {
  final Widget Function() builder;
  final Duration cacheDuration;
  final String? cacheKey;

  const CachedWidget({
    super.key,
    required this.builder,
    this.cacheDuration = const Duration(minutes: 5),
    this.cacheKey,
  });

  @override
  State<CachedWidget> createState() => _CachedWidgetState();
}

class _CachedWidgetState extends State<CachedWidget> {
  Widget? _cachedWidget;
  DateTime? _cacheTime;
  String? _lastCacheKey;

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    final currentCacheKey = widget.cacheKey ?? 'default';
    
    // Check if cache is valid
    if (_cachedWidget != null && 
        _cacheTime != null && 
        currentTime.difference(_cacheTime!) < widget.cacheDuration &&
        _lastCacheKey == currentCacheKey) {
      return _cachedWidget!;
    }
    
    // Rebuild and cache
    _cachedWidget = widget.builder();
    _cacheTime = currentTime;
    _lastCacheKey = currentCacheKey;
    
    return _cachedWidget!;
  }
}

// Lazy loading widget
class LazyLoadingWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Widget? loadingWidget;

  const LazyLoadingWidget({
    super.key,
    required this.child,
    this.delay = const Duration(milliseconds: 100),
    this.loadingWidget,
  });

  @override
  State<LazyLoadingWidget> createState() => _LazyLoadingWidgetState();
}

class _LazyLoadingWidgetState extends State<LazyLoadingWidget> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadWithDelay();
  }

  void _loadWithDelay() {
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return widget.loadingWidget ?? const Center(child: CircularProgressIndicator());
    }
    return widget.child;
  }
}

// Performance monitoring widget
class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final String? name;
  final bool enabled;

  const PerformanceMonitor({
    super.key,
    required this.child,
    this.name,
    this.enabled = true,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  @override
  void initState() {
    super.initState();
    if (widget.enabled && widget.name != null) {
      PerformanceUtils.startTimer(widget.name!);
    }
  }

  @override
  void dispose() {
    if (widget.enabled && widget.name != null) {
      PerformanceUtils.endTimer(widget.name!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// Memory efficient image cache
class OptimizedImageCache {
  static final Map<String, Image> _cache = {};
  static const int _maxCacheSize = 50;

  static Image? getCachedImage(String key) {
    return _cache[key];
  }

  static void cacheImage(String key, Image image) {
    if (_cache.length >= _maxCacheSize) {
      // Remove oldest entry
      final oldestKey = _cache.keys.first;
      _cache.remove(oldestKey);
    }
    _cache[key] = image;
  }

  static void clearCache() {
    _cache.clear();
  }
}

// Error boundary widget
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error, StackTrace? stackTrace)? errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(_error!, _stackTrace);
      }
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Došlo je do greške',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _error.toString(),
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _error = null;
                  _stackTrace = null;
                });
              },
              child: const Text('Pokušaj ponovo'),
            ),
          ],
        ),
      );
    }

    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    _setupErrorHandling();
  }

  void _setupErrorHandling() {
    FlutterError.onError = (FlutterErrorDetails details) {
      setState(() {
        _error = details.exception;
        _stackTrace = details.stack;
      });
    };
  }
} 