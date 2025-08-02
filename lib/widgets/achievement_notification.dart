import 'package:flutter/material.dart';
import '../models/user_progress.dart';
import '../utils/constants.dart';

class AchievementNotification extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback? onDismiss;

  const AchievementNotification({
    super.key,
    required this.achievement,
    this.onDismiss,
  });

  @override
  State<AchievementNotification> createState() => _AchievementNotificationState();
}

class _AchievementNotificationState extends State<AchievementNotification>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _starController;
  
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _starAnimation;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: AppAnimations.mediumDuration,
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: AppAnimations.shortDuration,
      vsync: this,
    );
    
    _starController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.bounceOut,
    ));
    
    _starAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _starController,
      curve: Curves.easeInOut,
    ));
    
    _startAnimation();
  }

  void _startAnimation() async {
    await _slideController.forward();
    await _scaleController.forward();
    _starController.repeat();
    
    // Auto dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  void _dismiss() async {
    await _slideController.reverse();
    widget.onDismiss?.call();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.all(AppSizes.padding),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.starColor,
                  AppColors.starColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.padding),
              child: Row(
                children: [
                  // Achievement icon
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        size: 32,
                        color: AppColors.starColor,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: AppSizes.padding),
                  
                  // Achievement content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.achievement.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _dismiss,
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.achievement.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppSizes.smallPadding),
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return AnimatedBuilder(
                                animation: _starAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: 1.0 + (_starAnimation.value * 0.2) * (index % 2 == 0 ? 1 : -1),
                                    child: Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              );
                            }),
                            const SizedBox(width: AppSizes.smallPadding),
                            Text(
                              'Dostignuće otključano!',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.8),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AchievementOverlay extends StatefulWidget {
  final List<Achievement> achievements;
  final VoidCallback? onDismiss;

  const AchievementOverlay({
    super.key,
    required this.achievements,
    this.onDismiss,
  });

  @override
  State<AchievementOverlay> createState() => _AchievementOverlayState();
}

class _AchievementOverlayState extends State<AchievementOverlay> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _showNextAchievement();
  }

  void _showNextAchievement() {
    if (_currentIndex < widget.achievements.length) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _currentIndex++;
          });
          _showNextAchievement();
        }
      });
    } else {
      widget.onDismiss?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= widget.achievements.length) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AchievementNotification(
        achievement: widget.achievements[_currentIndex],
        onDismiss: () {
          setState(() {
            _currentIndex++;
          });
          if (_currentIndex >= widget.achievements.length) {
            widget.onDismiss?.call();
          }
        },
      ),
    );
  }
} 