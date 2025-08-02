import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'dart:async';

class ErrorHandler {
  static final List<ErrorInfo> _errors = [];
  static final StreamController<ErrorInfo> _errorController = StreamController<ErrorInfo>.broadcast();
  
  static Stream<ErrorInfo> get errorStream => _errorController.stream;
  
  // Error types
  static const String networkError = 'network_error';
  static const String audioError = 'audio_error';
  static const String mlError = 'ml_error';
  static const String storageError = 'storage_error';
  static const String uiError = 'ui_error';
  static const String unknownError = 'unknown_error';
  
  // Handle error
  static void handleError(
    Object error,
    StackTrace? stackTrace, {
    String? type,
    String? context,
    bool showSnackBar = true,
  }) {
    final errorInfo = ErrorInfo(
      error: error,
      stackTrace: stackTrace,
      type: type ?? unknownError,
      context: context,
      timestamp: DateTime.now(),
    );
    
    _errors.add(errorInfo);
    _errorController.add(errorInfo);
    
    // Log error
    developer.log(
      'Error [$type]: $error',
      name: 'ErrorHandler',
      error: error,
      stackTrace: stackTrace,
    );
    
    // Show snackbar if enabled
    if (showSnackBar) {
      _showErrorSnackBar(errorInfo);
    }
  }
  
  // Handle specific error types
  static void handleNetworkError(Object error, StackTrace? stackTrace, {String? context}) {
    handleError(error, stackTrace, type: networkError, context: context);
  }
  
  static void handleAudioError(Object error, StackTrace? stackTrace, {String? context}) {
    handleError(error, stackTrace, type: audioError, context: context);
  }
  
  static void handleMLError(Object error, StackTrace? stackTrace, {String? context}) {
    handleError(error, stackTrace, type: mlError, context: context);
  }
  
  static void handleStorageError(Object error, StackTrace? stackTrace, {String? context}) {
    handleError(error, stackTrace, type: storageError, context: context);
  }
  
  static void handleUIError(Object error, StackTrace? stackTrace, {String? context}) {
    handleError(error, stackTrace, type: uiError, context: context);
  }
  
  // Show error snackbar
  static void _showErrorSnackBar(ErrorInfo errorInfo) {
    final context = _getCurrentContext();
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getErrorMessage(errorInfo)),
          backgroundColor: _getErrorColor(errorInfo.type),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Detalji',
            textColor: Colors.white,
            onPressed: () => _showErrorDialog(context, errorInfo),
          ),
        ),
      );
    }
  }
  
  // Get current context (this is a simplified approach)
  static BuildContext? _getCurrentContext() {
    // In a real app, you might use a global navigator key or context
    return null;
  }
  
  // Get error message
  static String _getErrorMessage(ErrorInfo errorInfo) {
    switch (errorInfo.type) {
      case networkError:
        return 'Greška pri povezivanju sa internetom';
      case audioError:
        return 'Greška pri reprodukciji zvuka';
      case mlError:
        return 'Greška pri analizi pisanja';
      case storageError:
        return 'Greška pri čuvanju podataka';
      case uiError:
        return 'Greška pri prikazu';
      default:
        return 'Došlo je do neočekivane greške';
    }
  }
  
  // Get error color
  static Color _getErrorColor(String type) {
    switch (type) {
      case networkError:
        return Colors.orange;
      case audioError:
        return Colors.blue;
      case mlError:
        return Colors.purple;
      case storageError:
        return Colors.red;
      case uiError:
        return Colors.grey;
      default:
        return Colors.red;
    }
  }
  
  // Show error dialog
  static void _showErrorDialog(BuildContext context, ErrorInfo errorInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalji greške'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tip: ${errorInfo.type}'),
              const SizedBox(height: 8),
              Text('Kontekst: ${errorInfo.context ?? 'N/A'}'),
              const SizedBox(height: 8),
              Text('Vreme: ${errorInfo.timestamp.toString()}'),
              const SizedBox(height: 8),
              Text('Greška: ${errorInfo.error.toString()}'),
              if (errorInfo.stackTrace != null) ...[
                const SizedBox(height: 8),
                const Text('Stack Trace:'),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    errorInfo.stackTrace.toString(),
                    style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Zatvori'),
          ),
        ],
      ),
    );
  }
  
  // Get all errors
  static List<ErrorInfo> getErrors() {
    return List.unmodifiable(_errors);
  }
  
  // Clear errors
  static void clearErrors() {
    _errors.clear();
  }
  
  // Get errors by type
  static List<ErrorInfo> getErrorsByType(String type) {
    return _errors.where((error) => error.type == type).toList();
  }
  
  // Dispose
  static void dispose() {
    _errorController.close();
  }
}

// Error information class
class ErrorInfo {
  final Object error;
  final StackTrace? stackTrace;
  final String type;
  final String? context;
  final DateTime timestamp;
  
  const ErrorInfo({
    required this.error,
    this.stackTrace,
    required this.type,
    this.context,
    required this.timestamp,
  });
  
  @override
  String toString() {
    return 'ErrorInfo(type: $type, context: $context, error: $error)';
  }
}

// Error boundary widget
class ErrorBoundaryWidget extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error, StackTrace? stackTrace)? errorBuilder;
  final bool showErrorDialog;

  const ErrorBoundaryWidget({
    super.key,
    required this.child,
    this.errorBuilder,
    this.showErrorDialog = true,
  });

  @override
  State<ErrorBoundaryWidget> createState() => _ErrorBoundaryWidgetState();
}

class _ErrorBoundaryWidgetState extends State<ErrorBoundaryWidget> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(_error!, _stackTrace);
      }
      return _buildDefaultErrorWidget();
    }
    return widget.child;
  }

  Widget _buildDefaultErrorWidget() {
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
      
      if (widget.showErrorDialog) {
        ErrorHandler.handleError(
          details.exception,
          details.stack,
          type: ErrorHandler.uiError,
          context: 'ErrorBoundaryWidget',
        );
      }
    };
  }
}

// Try-catch widget
class TryCatchWidget extends StatefulWidget {
  final Widget Function() builder;
  final Widget Function(Object error, StackTrace? stackTrace)? errorBuilder;
  final VoidCallback? onError;

  const TryCatchWidget({
    super.key,
    required this.builder,
    this.errorBuilder,
    this.onError,
  });

  @override
  State<TryCatchWidget> createState() => _TryCatchWidgetState();
}

class _TryCatchWidgetState extends State<TryCatchWidget> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(_error!, _stackTrace);
      }
      return _buildDefaultErrorWidget();
    }

    try {
      return widget.builder();
    } catch (error, stackTrace) {
      _error = error;
      _stackTrace = stackTrace;
      
      widget.onError?.call();
      
      return _buildDefaultErrorWidget();
    }
  }

  Widget _buildDefaultErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Greška pri učitavanju',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Error reporting service
class ErrorReportingService {
  static Future<void> reportError(ErrorInfo errorInfo) async {
    // In a real app, you would send this to a service like Crashlytics, Sentry, etc.
    developer.log(
      'Reporting error: ${errorInfo.type}',
      name: 'ErrorReporting',
      error: errorInfo.error,
      stackTrace: errorInfo.stackTrace,
    );
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
  }
  
  static Future<void> reportErrorBatch(List<ErrorInfo> errors) async {
    for (final error in errors) {
      await reportError(error);
    }
  }
} 