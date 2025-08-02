import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';

class AdvancedAnimations {
  static final HapticService _hapticService = HapticService();

  // Elastic animation
  static Widget elastic({
    required Widget child,
    Duration duration = AppAnimations.mediumDuration,
    bool enableHaptic = false,
    String hapticType = AppHaptics.light,
  }) {
    return _ElasticAnimation(
      child: child,
      duration: duration,
      enableHaptic: enableHaptic,
      hapticType: hapticType,
    );
  }

  // Bounce with rotation
  static Widget bounceRotate({
    required Widget child,
    Duration duration = AppAnimations.mediumDuration,
    bool enableHaptic = false,
    String hapticType = AppHaptics.light,
  }) {
    return _BounceRotateAnimation(
      child: child,
      duration: duration,
      enableHaptic: enableHaptic,
      hapticType: hapticType,
    );
  }

  // Wave animation
  static Widget wave({
    required Widget child,
    Duration duration = AppAnimations.longDuration,
    bool enableHaptic = false,
    String hapticType = AppHaptics.light,
  }) {
    return _WaveAnimation(
      child: child,
      duration: duration,
      enableHaptic: enableHaptic,
      hapticType: hapticType,
    );
  }

  // Morphing animation
  static Widget morph({
    required Widget child,
    Duration duration = AppAnimations.mediumDuration,
    bool enableHaptic = false,
    String hapticType = AppHaptics.light,
  }) {
    return _MorphAnimation(
      child: child,
      duration: duration,
      enableHaptic: enableHaptic,
      hapticType: hapticType,
    );
  }
}

class _ElasticAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool enableHaptic;
  final String hapticType;

  const _ElasticAnimation({
    required this.child,
    required this.duration,
    required this.enableHaptic,
    required this.hapticType,
  });

  @override
  State<_ElasticAnimation> createState() => _ElasticAnimationState();
}

class _ElasticAnimationState extends State<_ElasticAnimation>
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
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
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

class _BounceRotateAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool enableHaptic;
  final String hapticType;

  const _BounceRotateAnimation({
    required this.child,
    required this.duration,
    required this.enableHaptic,
    required this.hapticType,
  });

  @override
  State<_BounceRotateAnimation> createState() => _BounceRotateAnimationState();
}

class _BounceRotateAnimationState extends State<_BounceRotateAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

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
      curve: Curves.bounceOut,
    ));
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
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
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotateAnimation.value,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

class _WaveAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool enableHaptic;
  final String hapticType;

  const _WaveAnimation({
    required this.child,
    required this.duration,
    required this.enableHaptic,
    required this.hapticType,
  });

  @override
  State<_WaveAnimation> createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<_WaveAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
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
        animation: _waveAnimation,
        builder: (context, child) {
          final wave = (widget.duration.inMilliseconds / 100) * 
                       _waveAnimation.value * 
                       (1 - _waveAnimation.value);
          return Transform.translate(
            offset: Offset(0, wave * 5),
            child: widget.child,
          );
        },
      ),
    );
  }
}

class _MorphAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool enableHaptic;
  final String hapticType;

  const _MorphAnimation({
    required this.child,
    required this.duration,
    required this.enableHaptic,
    required this.hapticType,
  });

  @override
  State<_MorphAnimation> createState() => _MorphAnimationState();
}

class _MorphAnimationState extends State<_MorphAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _morphAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _morphAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
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
        animation: _morphAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_morphAnimation.value * 0.1),
            child: Transform.rotate(
              angle: _morphAnimation.value * 0.05,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
} 