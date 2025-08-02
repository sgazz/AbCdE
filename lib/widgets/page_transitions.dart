import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';

class PageTransitions {
  static final HapticService _hapticService = HapticService();

  // Slide transition
  static PageRouteBuilder slideTransition({
    required Widget page,
    RouteSettings? settings,
    bool enableHaptic = true,
    String hapticType = AppHaptics.selection,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: AppAnimations.mediumDuration,
    );
  }

  // Fade transition
  static PageRouteBuilder fadeTransition({
    required Widget page,
    RouteSettings? settings,
    bool enableHaptic = true,
    String hapticType = AppHaptics.selection,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: AppAnimations.shortDuration,
    );
  }

  // Scale transition
  static PageRouteBuilder scaleTransition({
    required Widget page,
    RouteSettings? settings,
    bool enableHaptic = true,
    String hapticType = AppHaptics.selection,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      transitionDuration: AppAnimations.mediumDuration,
    );
  }

  // Custom transition with haptic feedback
  static PageRouteBuilder customTransition({
    required Widget page,
    RouteSettings? settings,
    required Widget Function(BuildContext, Animation<double>, Animation<double>, Widget) transitionsBuilder,
    Duration? duration,
    bool enableHaptic = true,
    String hapticType = AppHaptics.selection,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (enableHaptic && animation.status == AnimationStatus.forward) {
          _hapticService.feedback(hapticType);
        }
        return transitionsBuilder(context, animation, secondaryAnimation, child);
      },
      transitionDuration: duration ?? AppAnimations.mediumDuration,
    );
  }
}

// Custom transition widgets
class SlidePageTransition extends StatelessWidget {
  final Widget child;
  final bool enableHaptic;

  const SlidePageTransition({
    super.key,
    required this.child,
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(ModalRoute.of(context)!.animation!),
      child: child,
    );
  }
}

class FadePageTransition extends StatelessWidget {
  final Widget child;
  final bool enableHaptic;

  const FadePageTransition({
    super.key,
    required this.child,
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: ModalRoute.of(context)!.animation!,
      child: child,
    );
  }
}

class ScalePageTransition extends StatelessWidget {
  final Widget child;
  final bool enableHaptic;

  const ScalePageTransition({
    super.key,
    required this.child,
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: ModalRoute.of(context)!.animation!,
      child: child,
    );
  }
} 