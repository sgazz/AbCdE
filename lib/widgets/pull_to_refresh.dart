import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomPullToRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Widget? refreshIndicator;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final double triggerDistance;
  final Duration animationDuration;

  const CustomPullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.refreshIndicator,
    this.backgroundColor,
    this.indicatorColor,
    this.triggerDistance = 80.0,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<CustomPullToRefresh> createState() => _CustomPullToRefreshState();
}

class _CustomPullToRefreshState extends State<CustomPullToRefresh>
    with TickerProviderStateMixin {
  late AnimationController _pullController;
  late AnimationController _refreshController;
  late Animation<double> _pullAnimation;
  late Animation<double> _refreshAnimation;
  late Animation<double> _scaleAnimation;
  
  double _pullDistance = 0.0;
  bool _isRefreshing = false;
  bool _canRefresh = false;

  @override
  void initState() {
    super.initState();
    _pullController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pullAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pullController,
      curve: Curves.easeOutCubic,
    ));
    
    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshController,
      curve: Curves.linear,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pullController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _pullController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _onVerticalDragStart(DragStartDetails details) {
    // Only start if we're at the top
    if (details.globalPosition.dy < 100) {
      _pullController.forward();
    }
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_isRefreshing) return;
    
    setState(() {
      _pullDistance += details.delta.dy;
      _pullDistance = _pullDistance.clamp(0.0, widget.triggerDistance * 2);
      
      if (_pullDistance >= widget.triggerDistance) {
        _canRefresh = true;
      } else {
        _canRefresh = false;
      }
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_isRefreshing) return;
    
    if (_canRefresh) {
      _startRefresh();
    } else {
      _resetPull();
    }
  }

  void _startRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    
    _refreshController.repeat();
    
    try {
      await widget.onRefresh();
    } finally {
      _stopRefresh();
    }
  }

  void _stopRefresh() {
    setState(() {
      _isRefreshing = false;
    });
    
    _refreshController.stop();
    _resetPull();
  }

  void _resetPull() {
    _pullController.reverse().then((_) {
      setState(() {
        _pullDistance = 0.0;
        _canRefresh = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content
        Transform.translate(
          offset: Offset(0, _pullDistance),
          child: GestureDetector(
            onVerticalDragStart: _onVerticalDragStart,
            onVerticalDragUpdate: _onVerticalDragUpdate,
            onVerticalDragEnd: _onVerticalDragEnd,
            child: widget.child,
          ),
        ),
        
        // Pull indicator
        if (_pullDistance > 0)
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _isRefreshing ? _refreshController : _pullController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.backgroundColor ?? AppColors.surface,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _isRefreshing
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  widget.indicatorColor ?? AppColors.primary,
                                ),
                              ),
                            )
                          : Icon(
                              _canRefresh ? Icons.refresh : Icons.keyboard_arrow_down,
                              color: widget.indicatorColor ?? AppColors.primary,
                              size: 24,
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class AnimatedRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final Color? backgroundColor;
  final double displacement;

  const AnimatedRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.displacement = 40.0,
  });

  @override
  State<AnimatedRefreshIndicator> createState() => _AnimatedRefreshIndicatorState();
}

class _AnimatedRefreshIndicatorState extends State<AnimatedRefreshIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _controller.repeat();
        await widget.onRefresh();
        _controller.stop();
      },
      color: widget.color ?? AppColors.primary,
      backgroundColor: widget.backgroundColor ?? AppColors.surface,
      displacement: widget.displacement,
      child: widget.child,
    );
  }
} 