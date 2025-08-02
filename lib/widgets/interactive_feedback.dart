import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';

class InteractiveFeedback {
  static final HapticService _hapticService = HapticService();

  // Success feedback with animation and haptic
  static Widget success({
    required Widget child,
    String message = 'Uspešno!',
    Duration duration = AppAnimations.shortDuration,
    bool enableHaptic = true,
  }) {
    return _SuccessFeedback(
      child: child,
      message: message,
      duration: duration,
      enableHaptic: enableHaptic,
    );
  }

  // Error feedback with animation and haptic
  static Widget error({
    required Widget child,
    String message = 'Greška!',
    Duration duration = AppAnimations.shortDuration,
    bool enableHaptic = true,
  }) {
    return _ErrorFeedback(
      child: child,
      message: message,
      duration: duration,
      enableHaptic: enableHaptic,
    );
  }

  // Warning feedback with animation and haptic
  static Widget warning({
    required Widget child,
    String message = 'Upozorenje!',
    Duration duration = AppAnimations.shortDuration,
    bool enableHaptic = true,
  }) {
    return _WarningFeedback(
      child: child,
      message: message,
      duration: duration,
      enableHaptic: enableHaptic,
    );
  }

  // Info feedback with animation and haptic
  static Widget info({
    required Widget child,
    String message = 'Informacija',
    Duration duration = AppAnimations.shortDuration,
    bool enableHaptic = true,
  }) {
    return _InfoFeedback(
      child: child,
      message: message,
      duration: duration,
      enableHaptic: enableHaptic,
    );
  }
}

class _SuccessFeedback extends StatefulWidget {
  final Widget child;
  final String message;
  final Duration duration;
  final bool enableHaptic;

  const _SuccessFeedback({
    required this.child,
    required this.message,
    required this.duration,
    required this.enableHaptic,
  });

  @override
  State<_SuccessFeedback> createState() => _SuccessFeedbackState();
}

class _SuccessFeedbackState extends State<_SuccessFeedback>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _showFeedback = false;

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
      curve: Curves.elasticOut,
    ));
    _opacityAnimation = Tween<double>(
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

  void _showSuccessFeedback() {
    setState(() {
      _showFeedback = true;
    });
    
    if (widget.enableHaptic) {
      HapticService().success();
    }
    
    _controller.forward().then((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showFeedback = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showSuccessFeedback,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: widget.child,
              );
            },
          ),
          if (_showFeedback)
            Positioned(
              top: 10,
              right: 10,
              child: AnimatedBuilder(
                animation: _opacityAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.smallPadding,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen,
                        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.successGreen.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ErrorFeedback extends StatefulWidget {
  final Widget child;
  final String message;
  final Duration duration;
  final bool enableHaptic;

  const _ErrorFeedback({
    required this.child,
    required this.message,
    required this.duration,
    required this.enableHaptic,
  });

  @override
  State<_ErrorFeedback> createState() => _ErrorFeedbackState();
}

class _ErrorFeedbackState extends State<_ErrorFeedback>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  late Animation<double> _opacityAnimation;
  bool _showFeedback = false;

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
      curve: Curves.easeInOut,
    ));
    _opacityAnimation = Tween<double>(
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

  void _showErrorFeedback() {
    setState(() {
      _showFeedback = true;
    });
    
    if (widget.enableHaptic) {
      HapticService().error();
    }
    
    _controller.forward().then((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showFeedback = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showErrorFeedback,
      child: Stack(
        children: [
          AnimatedBuilder(
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
          if (_showFeedback)
            Positioned(
              top: 10,
              right: 10,
              child: AnimatedBuilder(
                animation: _opacityAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.smallPadding,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.error.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _WarningFeedback extends StatefulWidget {
  final Widget child;
  final String message;
  final Duration duration;
  final bool enableHaptic;

  const _WarningFeedback({
    required this.child,
    required this.message,
    required this.duration,
    required this.enableHaptic,
  });

  @override
  State<_WarningFeedback> createState() => _WarningFeedbackState();
}

class _WarningFeedbackState extends State<_WarningFeedback>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _opacityAnimation;
  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _opacityAnimation = Tween<double>(
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

  void _showWarningFeedback() {
    setState(() {
      _showFeedback = true;
    });
    
    if (widget.enableHaptic) {
      HapticService().warning();
    }
    
    _controller.forward().then((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showFeedback = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showWarningFeedback,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: widget.child,
              );
            },
          ),
          if (_showFeedback)
            Positioned(
              top: 10,
              right: 10,
              child: AnimatedBuilder(
                animation: _opacityAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.smallPadding,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warningOrange,
                        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.warningOrange.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.warning,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoFeedback extends StatefulWidget {
  final Widget child;
  final String message;
  final Duration duration;
  final bool enableHaptic;

  const _InfoFeedback({
    required this.child,
    required this.message,
    required this.duration,
    required this.enableHaptic,
  });

  @override
  State<_InfoFeedback> createState() => _InfoFeedbackState();
}

class _InfoFeedbackState extends State<_InfoFeedback>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _opacityAnimation;
  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _opacityAnimation = Tween<double>(
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

  void _showInfoFeedback() {
    setState(() {
      _showFeedback = true;
    });
    
    if (widget.enableHaptic) {
      HapticService().light();
    }
    
    _controller.forward().then((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showFeedback = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showInfoFeedback,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: widget.child,
              );
            },
          ),
          if (_showFeedback)
            Positioned(
              top: 10,
              right: 10,
              child: AnimatedBuilder(
                animation: _opacityAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.smallPadding,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.info,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
} 