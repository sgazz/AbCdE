import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SwipeableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeDown;
  final double swipeThreshold;
  final Duration animationDuration;

  const SwipeableCard({
    super.key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeUp,
    this.onSwipeDown,
    this.swipeThreshold = 100.0,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });

    final velocity = details.velocity;
    final distance = _dragOffset.distance;

    if (distance > widget.swipeThreshold) {
      // Determine swipe direction
      if (_dragOffset.dx.abs() > _dragOffset.dy.abs()) {
        // Horizontal swipe
        if (_dragOffset.dx > 0 && widget.onSwipeRight != null) {
          _animateSwipe(Offset(1.0, 0.0), widget.onSwipeRight!);
        } else if (_dragOffset.dx < 0 && widget.onSwipeLeft != null) {
          _animateSwipe(Offset(-1.0, 0.0), widget.onSwipeLeft!);
        } else {
          _resetPosition();
        }
      } else {
        // Vertical swipe
        if (_dragOffset.dy > 0 && widget.onSwipeDown != null) {
          _animateSwipe(Offset(0.0, 1.0), widget.onSwipeDown!);
        } else if (_dragOffset.dy < 0 && widget.onSwipeUp != null) {
          _animateSwipe(Offset(0.0, -1.0), widget.onSwipeUp!);
        } else {
          _resetPosition();
        }
      }
    } else {
      _resetPosition();
    }
  }

  void _animateSwipe(Offset direction, VoidCallback callback) {
    _slideAnimation = Tween<Offset>(
      begin: _dragOffset / 200,
      end: direction * 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward().then((_) {
      callback();
      _resetPosition();
    });
  }

  void _resetPosition() {
    _slideAnimation = Tween<Offset>(
      begin: _dragOffset / 200,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward().then((_) {
      setState(() {
        _dragOffset = Offset.zero;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: _isDragging ? _dragOffset : _slideAnimation.value * 200,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}

class SwipeableList extends StatefulWidget {
  final List<Widget> children;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final double swipeThreshold;
  final Duration animationDuration;

  const SwipeableList({
    super.key,
    required this.children,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.swipeThreshold = 100.0,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<SwipeableList> createState() => _SwipeableListState();
}

class _SwipeableListState extends State<SwipeableList> {
  int _currentIndex = 0;

  void _nextItem() {
    if (_currentIndex < widget.children.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _previousItem() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SwipeableCard(
      onSwipeLeft: _nextItem,
      onSwipeRight: _previousItem,
      swipeThreshold: widget.swipeThreshold,
      animationDuration: widget.animationDuration,
      child: widget.children[_currentIndex],
    );
  }
} 