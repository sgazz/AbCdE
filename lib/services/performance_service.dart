import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  // Performance metrics
  final Map<String, dynamic> _metrics = {};
  final List<PerformanceEvent> _events = [];
  Timer? _periodicTimer;
  bool _isMonitoring = false;

  // Performance thresholds
  static const double _targetFPS = 60.0;
  static const int _maxMemoryMB = 100;
  static const Duration _maxFrameTime = Duration(milliseconds: 16);

  // Performance monitoring
  void startMonitoring() {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    _periodicTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _collectMetrics();
    });

    // Enable performance overlay in debug mode
    if (kDebugMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _enablePerformanceOverlay();
      });
    }

    developer.log('Performance monitoring started', name: 'PerformanceService');
  }

  void stopMonitoring() {
    _isMonitoring = false;
    _periodicTimer?.cancel();
    _periodicTimer = null;
    developer.log('Performance monitoring stopped', name: 'PerformanceService');
  }

  void _enablePerformanceOverlay() {
    // This would be implemented based on your app's structure
    // For now, we'll just log that it's enabled
    developer.log('Performance overlay enabled', name: 'PerformanceService');
  }

  void _collectMetrics() {
    final frameTime = _getFrameTime();
    final memoryUsage = _getMemoryUsage();
    final fps = _calculateFPS();

    _metrics['frameTime'] = frameTime;
    _metrics['memoryUsage'] = memoryUsage;
    _metrics['fps'] = fps;
    _metrics['timestamp'] = DateTime.now().millisecondsSinceEpoch;

    _checkPerformanceThresholds();
    _logMetrics();
  }

  Duration _getFrameTime() {
    // This is a simplified implementation
    // In a real app, you'd use Flutter's frame timing APIs
    return const Duration(milliseconds: 16);
  }

  int _getMemoryUsage() {
    // This is a placeholder
    // In a real app, you'd use platform-specific APIs
    return 50; // MB
  }

  double _calculateFPS() {
    // This is a simplified implementation
    // In a real app, you'd track frame times and calculate FPS
    return 60.0;
  }

  void _checkPerformanceThresholds() {
    final fps = _metrics['fps'] as double? ?? 0.0;
    final memoryUsage = _metrics['memoryUsage'] as int? ?? 0;
    final frameTime = _metrics['frameTime'] as Duration? ?? Duration.zero;

    if (fps < _targetFPS) {
      _logPerformanceIssue('Low FPS: $fps', 'fps');
    }

    if (memoryUsage > _maxMemoryMB) {
      _logPerformanceIssue('High memory usage: ${memoryUsage}MB', 'memory');
    }

    if (frameTime > _maxFrameTime) {
      _logPerformanceIssue('Slow frame time: ${frameTime.inMilliseconds}ms', 'frame_time');
    }
  }

  void _logPerformanceIssue(String message, String type) {
    final event = PerformanceEvent(
      type: type,
      message: message,
      timestamp: DateTime.now(),
      severity: PerformanceSeverity.warning,
    );
    
    _events.add(event);
    developer.log('Performance issue: $message', name: 'PerformanceService');
  }

  void _logMetrics() {
    if (kDebugMode) {
      developer.log('Performance metrics: $_metrics', name: 'PerformanceService');
    }
  }

  // Event tracking
  void trackEvent(String name, {Map<String, dynamic>? parameters}) {
    final event = PerformanceEvent(
      type: 'custom',
      message: name,
      timestamp: DateTime.now(),
      severity: PerformanceSeverity.info,
      parameters: parameters,
    );
    
    _events.add(event);
  }

  void trackError(String error, StackTrace? stackTrace) {
    final event = PerformanceEvent(
      type: 'error',
      message: error,
      timestamp: DateTime.now(),
      severity: PerformanceSeverity.error,
      parameters: {'stackTrace': stackTrace.toString()},
    );
    
    _events.add(event);
    developer.log('Performance error: $error', name: 'PerformanceService');
  }

  // Memory management
  void trackMemoryAllocation(String allocation, int size) {
    trackEvent('memory_allocation', parameters: {
      'allocation': allocation,
      'size': size,
    });
  }

  void trackMemoryDeallocation(String deallocation) {
    trackEvent('memory_deallocation', parameters: {
      'deallocation': deallocation,
    });
  }

  // Animation performance
  void trackAnimationPerformance(String animationName, Duration duration) {
    trackEvent('animation_performance', parameters: {
      'animation': animationName,
      'duration': duration.inMilliseconds,
    });
  }

  // Widget rebuild tracking
  void trackWidgetRebuild(String widgetName) {
    trackEvent('widget_rebuild', parameters: {
      'widget': widgetName,
    });
  }

  // Get performance report
  Map<String, dynamic> getPerformanceReport() {
    return {
      'metrics': Map<String, dynamic>.from(_metrics),
      'events': _events.map((e) => e.toJson()).toList(),
      'summary': _generateSummary(),
    };
  }

  Map<String, dynamic> _generateSummary() {
    final totalEvents = _events.length;
    final errorEvents = _events.where((e) => e.severity == PerformanceSeverity.error).length;
    final warningEvents = _events.where((e) => e.severity == PerformanceSeverity.warning).length;

    return {
      'totalEvents': totalEvents,
      'errorEvents': errorEvents,
      'warningEvents': warningEvents,
      'averageFPS': _calculateAverageFPS(),
      'peakMemoryUsage': _getPeakMemoryUsage(),
    };
  }

  double _calculateAverageFPS() {
    final fpsValues = _metrics.values.whereType<double>().toList();
    if (fpsValues.isEmpty) return 0.0;
    return fpsValues.reduce((a, b) => a + b) / fpsValues.length;
  }

  int _getPeakMemoryUsage() {
    final memoryValues = _metrics.values.whereType<int>().toList();
    if (memoryValues.isEmpty) return 0;
    return memoryValues.reduce((a, b) => a > b ? a : b);
  }

  // Clear old events
  void clearOldEvents({Duration? olderThan}) {
    final cutoff = DateTime.now().subtract(olderThan ?? const Duration(hours: 1));
    _events.removeWhere((event) => event.timestamp.isBefore(cutoff));
  }

  // Dispose
  void dispose() {
    stopMonitoring();
    _events.clear();
    _metrics.clear();
  }
}

class PerformanceEvent {
  final String type;
  final String message;
  final DateTime timestamp;
  final PerformanceSeverity severity;
  final Map<String, dynamic>? parameters;

  PerformanceEvent({
    required this.type,
    required this.message,
    required this.timestamp,
    required this.severity,
    this.parameters,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'severity': severity.name,
      'parameters': parameters,
    };
  }
}

enum PerformanceSeverity {
  info,
  warning,
  error,
}

// Performance mixin for widgets
mixin PerformanceMixin<T extends StatefulWidget> on State<T> {
  PerformanceService get _performanceService => PerformanceService();

  @override
  void initState() {
    super.initState();
    _performanceService.trackEvent('widget_initialized', parameters: {
      'widget': widget.runtimeType.toString(),
    });
  }

  @override
  void dispose() {
    _performanceService.trackEvent('widget_disposed', parameters: {
      'widget': widget.runtimeType.toString(),
    });
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    _performanceService.trackWidgetRebuild(widget.runtimeType.toString());
    super.setState(fn);
  }
}

// Performance widget wrapper
class PerformanceWidget extends StatelessWidget {
  final Widget child;
  final String name;

  const PerformanceWidget({
    super.key,
    required this.child,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    PerformanceService().trackWidgetRebuild(name);
    return child;
  }
} 