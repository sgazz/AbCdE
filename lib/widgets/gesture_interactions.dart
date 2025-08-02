import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';

class GestureInteractions {
  static final HapticService _hapticService = HapticService();

  // Swipe gesture
  static Widget swipe({
    required Widget child,
    required Function() onSwipeLeft,
    required Function() onSwipeRight,
    Function()? onSwipeUp,
    Function()? onSwipeDown,
    bool enableHaptic = true,
    String hapticType = AppHaptics.light,
    double sensitivity = 50.0,
  }) {
    return _SwipeGesture(
      child: child,
      onSwipeLeft: onSwipeLeft,
      onSwipeRight: onSwipeRight,
      onSwipeUp: onSwipeUp,
      onSwipeDown: onSwipeDown,
      enableHaptic: enableHaptic,
      hapticType: hapticType,
      sensitivity: sensitivity,
    );
  }

  // Long press gesture
  static Widget longPress({
    required Widget child,
    required Function() onLongPress,
    bool enableHaptic = true,
    String hapticType = AppHaptics.medium,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return _LongPressGesture(
      child: child,
      onLongPress: onLongPress,
      enableHaptic: enableHaptic,
      hapticType: hapticType,
      duration: duration,
    );
  }

  // Double tap gesture
  static Widget doubleTap({
    required Widget child,
    required Function() onDoubleTap,
    bool enableHaptic = true,
    String hapticType = AppHaptics.light,
  }) {
    return _DoubleTapGesture(
      child: child,
      onDoubleTap: onDoubleTap,
      enableHaptic: enableHaptic,
      hapticType: hapticType,
    );
  }

  // Pinch gesture
  static Widget pinch({
    required Widget child,
    required Function(double scale) onPinch,
    bool enableHaptic = true,
    String hapticType = AppHaptics.light,
  }) {
    return _PinchGesture(
      child: child,
      onPinch: onPinch,
      enableHaptic: enableHaptic,
      hapticType: hapticType,
    );
  }
}

class _SwipeGesture extends StatefulWidget {
  final Widget child;
  final Function() onSwipeLeft;
  final Function() onSwipeRight;
  final Function()? onSwipeUp;
  final Function()? onSwipeDown;
  final bool enableHaptic;
  final String hapticType;
  final double sensitivity;

  const _SwipeGesture({
    required this.child,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    this.onSwipeUp,
    this.onSwipeDown,
    required this.enableHaptic,
    required this.hapticType,
    required this.sensitivity,
  });

  @override
  State<_SwipeGesture> createState() => _SwipeGestureState();
}

class _SwipeGestureState extends State<_SwipeGesture> {
  Offset? _startPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        _startPosition = details.globalPosition;
      },
      onPanEnd: (details) {
        if (_startPosition == null) return;

        final endPosition = details.globalPosition;
        final delta = endPosition - _startPosition!;

        if (delta.dx.abs() > widget.sensitivity || delta.dy.abs() > widget.sensitivity) {
          if (delta.dx.abs() > delta.dy.abs()) {
            // Horizontal swipe
            if (delta.dx > 0) {
              widget.onSwipeRight();
            } else {
              widget.onSwipeLeft();
            }
          } else {
            // Vertical swipe
            if (delta.dy > 0) {
              widget.onSwipeDown?.call();
            } else {
              widget.onSwipeUp?.call();
            }
          }

          if (widget.enableHaptic) {
            HapticService().feedback(widget.hapticType);
          }
        }

        _startPosition = null;
      },
      child: widget.child,
    );
  }
}

class _LongPressGesture extends StatelessWidget {
  final Widget child;
  final Function() onLongPress;
  final bool enableHaptic;
  final String hapticType;
  final Duration duration;

  const _LongPressGesture({
    required this.child,
    required this.onLongPress,
    required this.enableHaptic,
    required this.hapticType,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onLongPress();
        if (enableHaptic) {
          HapticService().feedback(hapticType);
        }
      },
      child: child,
    );
  }
}

class _DoubleTapGesture extends StatelessWidget {
  final Widget child;
  final Function() onDoubleTap;
  final bool enableHaptic;
  final String hapticType;

  const _DoubleTapGesture({
    required this.child,
    required this.onDoubleTap,
    required this.enableHaptic,
    required this.hapticType,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        onDoubleTap();
        if (enableHaptic) {
          HapticService().feedback(hapticType);
        }
      },
      child: child,
    );
  }
}

class _PinchGesture extends StatefulWidget {
  final Widget child;
  final Function(double scale) onPinch;
  final bool enableHaptic;
  final String hapticType;

  const _PinchGesture({
    required this.child,
    required this.onPinch,
    required this.enableHaptic,
    required this.hapticType,
  });

  @override
  State<_PinchGesture> createState() => _PinchGestureState();
}

class _PinchGestureState extends State<_PinchGesture> {
  double _scale = 1.0;
  double _baseScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _baseScale = _scale;
      },
      onScaleUpdate: (details) {
        setState(() {
          _scale = (_baseScale * details.scale).clamp(0.5, 3.0);
        });
        widget.onPinch(_scale);
      },
      onScaleEnd: (details) {
        if (widget.enableHaptic) {
          HapticService().feedback(widget.hapticType);
        }
      },
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
} 