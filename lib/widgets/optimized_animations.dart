import 'package:flutter/material.dart';
import '../services/performance_service.dart';
import '../utils/constants.dart';

// Optimized animation controller with performance tracking
class OptimizedAnimationController extends AnimationController {
  final String animationName;
  final PerformanceService _performanceService = PerformanceService();

  OptimizedAnimationController({
    required super.duration,
    required super.vsync,
    required this.animationName,
  });

  @override
  TickerFuture forward({double? from}) {
    final startTime = DateTime.now();
    final future = super.forward(from: from);
    
    addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final duration = DateTime.now().difference(startTime);
        _performanceService.trackAnimationPerformance(animationName, duration);
      }
    });
    
    return future;
  }
}

// Optimized animated builder with performance tracking
class OptimizedAnimatedBuilder extends StatelessWidget {
  final Listenable animation;
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;
  final String name;

  const OptimizedAnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    PerformanceService().trackWidgetRebuild('OptimizedAnimatedBuilder_$name');
    
    return AnimatedBuilder(
      animation: animation,
      builder: builder,
      child: child,
    );
  }
}

// Optimized fade animation
class OptimizedFadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool show;

  const OptimizedFadeAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.show = true,
  });

  @override
  State<OptimizedFadeAnimation> createState() => _OptimizedFadeAnimationState();
}

class _OptimizedFadeAnimationState extends State<OptimizedFadeAnimation>
    with SingleTickerProviderStateMixin, PerformanceMixin {
  late OptimizedAnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = OptimizedAnimationController(
      duration: widget.duration,
      vsync: this,
      animationName: 'FadeAnimation',
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
    
    if (widget.show) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(OptimizedFadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.show != oldWidget.show) {
      if (widget.show) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OptimizedAnimatedBuilder(
      animation: _animation,
      name: 'FadeAnimation',
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

// Optimized scale animation
class OptimizedScaleAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double scale;
  final bool animate;

  const OptimizedScaleAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.scale = 1.0,
    this.animate = true,
  });

  @override
  State<OptimizedScaleAnimation> createState() => _OptimizedScaleAnimationState();
}

class _OptimizedScaleAnimationState extends State<OptimizedScaleAnimation>
    with SingleTickerProviderStateMixin, PerformanceMixin {
  late OptimizedAnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = OptimizedAnimationController(
      duration: widget.duration,
      vsync: this,
      animationName: 'ScaleAnimation',
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.scale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(OptimizedScaleAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.scale != oldWidget.scale) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.scale,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ));
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OptimizedAnimatedBuilder(
      animation: _animation,
      name: 'ScaleAnimation',
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

// Optimized slide animation
class OptimizedSlideAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Offset begin;
  final Offset end;
  final bool animate;

  const OptimizedSlideAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.begin = const Offset(0, 1),
    this.end = Offset.zero,
    this.animate = true,
  });

  @override
  State<OptimizedSlideAnimation> createState() => _OptimizedSlideAnimationState();
}

class _OptimizedSlideAnimationState extends State<OptimizedSlideAnimation>
    with SingleTickerProviderStateMixin, PerformanceMixin {
  late OptimizedAnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = OptimizedAnimationController(
      duration: widget.duration,
      vsync: this,
      animationName: 'SlideAnimation',
    );
    
    _animation = Tween<Offset>(
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OptimizedAnimatedBuilder(
      animation: _animation,
      name: 'SlideAnimation',
      builder: (context, child) {
        return SlideTransition(
          position: _animation,
          child: widget.child,
        );
      },
    );
  }
}

// Optimized staggered animation
class OptimizedStaggeredAnimation extends StatefulWidget {
  final List<Widget> children;
  final Duration interval;
  final Duration duration;
  final Curve curve;

  const OptimizedStaggeredAnimation({
    super.key,
    required this.children,
    this.interval = const Duration(milliseconds: 100),
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  State<OptimizedStaggeredAnimation> createState() => _OptimizedStaggeredAnimationState();
}

class _OptimizedStaggeredAnimationState extends State<OptimizedStaggeredAnimation>
    with TickerProviderStateMixin, PerformanceMixin {
  late List<OptimizedAnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.children.length,
      (index) => OptimizedAnimationController(
        duration: widget.duration,
        vsync: this,
        animationName: 'StaggeredAnimation_$index',
      ),
    );

    _animations = _controllers.map((controller) {
      return CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      );
    }).toList();

    _startStaggeredAnimation();
  }

  void _startStaggeredAnimation() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.interval * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.children.length, (index) {
        return OptimizedAnimatedBuilder(
          animation: _animations[index],
          name: 'StaggeredAnimation_$index',
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - _animations[index].value)),
              child: Opacity(
                opacity: _animations[index].value,
                child: widget.children[index],
              ),
            );
          },
        );
      }),
    );
  }
}

// Optimized performance-aware container
class OptimizedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final Clip? clipBehavior;

  const OptimizedContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.decoration,
    this.width,
    this.height,
    this.alignment,
    this.clipBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return PerformanceWidget(
      name: 'OptimizedContainer',
      child: Container(
        padding: padding,
        margin: margin,
        decoration: decoration,
        width: width,
        height: height,
        alignment: alignment,
        clipBehavior: clipBehavior ?? Clip.none,
        child: child,
      ),
    );
  }
}

// Optimized list view with performance tracking
class OptimizedListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;

  const OptimizedListView({
    super.key,
    required this.children,
    this.controller,
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
  });

  @override
  Widget build(BuildContext context) {
    return PerformanceWidget(
      name: 'OptimizedListView',
      child: ListView.builder(
        controller: controller,
        padding: padding,
        itemCount: children.length,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        itemBuilder: (context, index) {
          return PerformanceWidget(
            name: 'ListViewItem_$index',
            child: children[index],
          );
        },
      ),
    );
  }
} 