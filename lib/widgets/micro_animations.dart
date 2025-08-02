import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';

class MicroAnimations {
  static final HapticService _hapticService = HapticService();

  // Pulse animation
  static Widget pulse({
    required Widget child,
    Duration duration = AppAnimations.shortDuration,
    Curve curve = AppAnimations.defaultCurve,
    bool enableHaptic = false,
    String hapticType = AppHaptics.light,
  }) {
    return _PulseAnimation(
      child: child,
      duration: duration,
      curve: curve,
      enableHaptic: enableHaptic,
      hapticType: hapticType,
    );
  }

  // Bounce animation
  static Widget bounce({
    required Widget child,
    Duration duration = AppAnimations.shortDuration,
    Curve curve = AppAnimations.bounceCurve,
    bool enableHaptic = false,
    String hapticType = AppHaptics.light,
  }) {
    return _BounceAnimation(
      child: child,
      duration: duration,
      curve: curve,
      enableHaptic: enableHaptic,
      hapticType: hapticType,
    );
  }

  // Shake animation
  static Widget shake({
    required Widget child,
    Duration duration = AppAnimations.shortDuration,
    Curve curve = AppAnimations.defaultCurve,
    bool enableHaptic = false,
    String hapticType = AppHaptics.medium,
  }) {
    return _ShakeAnimation(
      child: child,
      duration: duration,
      curve: curve,
      enableHaptic: enableHaptic,
      hapticType: hapticType,
    );
  }

  // Rotate animation
  static Widget rotate({
    required Widget child,
    Duration duration = AppAnimations.mediumDuration,
    Curve curve = AppAnimations.defaultCurve,
    bool enableHaptic = false,
    String hapticType = AppHaptics.light,
  }) {
    return _RotateAnimation(
      child: child,
      duration: duration,
      curve: curve,
      enableHaptic: enableHaptic,
      hapticType: hapticType,
    );
  }

  // Slide animation
  static Widget slide({
    required Widget child,
    Duration duration = AppAnimations.shortDuration,
    Curve curve = AppAnimations.slideCurve,
    bool enableHaptic = false,
    String hapticType = AppHaptics.light,
    Offset begin = const Offset(0, 0),
    Offset end = const Offset(0, 0),
  }) {
    return _SlideAnimation(
      child: child,
      duration: duration,
      curve: curve,
      enableHaptic: enableHaptic,
      hapticType: hapticType,
      begin: begin,
      end: end,
    );
  }
}

class _PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool enableHaptic;
  final String hapticType;

  const _PulseAnimation({
    required this.child,
    required this.duration,
    required this.curve,
    required this.enableHaptic,
    required this.hapticType,
  });

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward().then((_) => _controller.reverse());
        if (widget.enableHaptic) {
          HapticService().feedback(widget.hapticType);
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

class _BounceAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool enableHaptic;
  final String hapticType;

  const _BounceAnimation({
    required this.child,
    required this.duration,
    required this.curve,
    required this.enableHaptic,
    required this.hapticType,
  });

  @override
  State<_BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<_BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward().then((_) => _controller.reverse());
        if (widget.enableHaptic) {
          HapticService().feedback(widget.hapticType);
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

class _ShakeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool enableHaptic;
  final String hapticType;

  const _ShakeAnimation({
    required this.child,
    required this.duration,
    required this.curve,
    required this.enableHaptic,
    required this.hapticType,
  });

  @override
  State<_ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<_ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward().then((_) => _controller.reset());
        if (widget.enableHaptic) {
          HapticService().feedback(widget.hapticType);
        }
      },
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          final shake = (widget.duration.inMilliseconds / 100) * 
                       _shakeAnimation.value * 
                       (1 - _shakeAnimation.value);
          return Transform.translate(
            offset: Offset(shake * 10, 0),
            child: widget.child,
          );
        },
      ),
    );
  }
}

class _RotateAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool enableHaptic;
  final String hapticType;

  const _RotateAnimation({
    required this.child,
    required this.duration,
    required this.curve,
    required this.enableHaptic,
    required this.hapticType,
  });

  @override
  State<_RotateAnimation> createState() => _RotateAnimationState();
}

class _RotateAnimationState extends State<_RotateAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward().then((_) => _controller.reset());
        if (widget.enableHaptic) {
          HapticService().feedback(widget.hapticType);
        }
      },
      child: AnimatedBuilder(
        animation: _rotateAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotateAnimation.value * 2 * 3.14159,
            child: widget.child,
          );
        },
      ),
    );
  }
}

class _SlideAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool enableHaptic;
  final String hapticType;
  final Offset begin;
  final Offset end;

  const _SlideAnimation({
    required this.child,
    required this.duration,
    required this.curve,
    required this.enableHaptic,
    required this.hapticType,
    required this.begin,
    required this.end,
  });

  @override
  State<_SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<_SlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward().then((_) => _controller.reverse());
        if (widget.enableHaptic) {
          HapticService().feedback(widget.hapticType);
        }
      },
      child: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: _slideAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
} 