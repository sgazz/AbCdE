import 'package:flutter/material.dart';
import '../utils/constants.dart';

class StarRating extends StatelessWidget {
  final int stars;
  final double size;
  final Color? color;
  final bool showNumber;
  final VoidCallback? onTap;

  const StarRating({
    super.key,
    required this.stars,
    this.size = AppSizes.starSize,
    this.color,
    this.showNumber = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(5, (index) {
            return Icon(
              index < stars ? Icons.star : Icons.star_border,
              color: color ?? AppColors.starColor,
              size: size,
            );
          }),
          if (showNumber) ...[
            const SizedBox(width: AppSizes.smallPadding),
            Text(
              '$stars/5',
              style: TextStyle(
                fontSize: size * 0.4,
                fontWeight: FontWeight.bold,
                color: color ?? AppColors.starColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AnimatedStarRating extends StatefulWidget {
  final int stars;
  final double size;
  final Color? color;
  final bool showNumber;
  final Duration animationDuration;

  const AnimatedStarRating({
    super.key,
    required this.stars,
    this.size = AppSizes.starSize,
    this.color,
    this.showNumber = true,
    this.animationDuration = AppAnimations.mediumDuration,
  });

  @override
  State<AnimatedStarRating> createState() => _AnimatedStarRatingState();
}

class _AnimatedStarRatingState extends State<AnimatedStarRating>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentStars = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _animateStars();
  }

  void _animateStars() {
    _controller.reset();
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedStarRating oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stars != widget.stars) {
      _animateStars();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        _currentStars = (widget.stars * _animation.value).round();
        
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(5, (index) {
              return Transform.scale(
                scale: index < _currentStars ? 1.0 + (_animation.value * 0.2) : 1.0,
                child: Icon(
                  index < _currentStars ? Icons.star : Icons.star_border,
                  color: widget.color ?? AppColors.starColor,
                  size: widget.size,
                ),
              );
            }),
            if (widget.showNumber) ...[
              const SizedBox(width: AppSizes.smallPadding),
              AnimatedDefaultTextStyle(
                duration: widget.animationDuration,
                style: TextStyle(
                  fontSize: widget.size * 0.4,
                  fontWeight: FontWeight.bold,
                  color: widget.color ?? AppColors.starColor,
                ),
                child: Text('$_currentStars/5'),
              ),
            ],
          ],
        );
      },
    );
  }
}

class StarRatingCard extends StatelessWidget {
  final int stars;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool showAnimation;

  const StarRatingCard({
    super.key,
    required this.stars,
    required this.title,
    this.subtitle,
    this.onTap,
    this.showAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSizes.smallPadding),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: AppSizes.padding),
              showAnimation
                  ? AnimatedStarRating(stars: stars)
                  : StarRating(stars: stars),
            ],
          ),
        ),
      ),
    );
  }
}

class StarRatingWithFeedback extends StatelessWidget {
  final int stars;
  final String feedback;
  final Color feedbackColor;

  const StarRatingWithFeedback({
    super.key,
    required this.stars,
    required this.feedback,
    required this.feedbackColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedStarRating(stars: stars),
        const SizedBox(height: AppSizes.smallPadding),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.padding,
            vertical: AppSizes.smallPadding,
          ),
          decoration: BoxDecoration(
            color: feedbackColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            border: Border.all(color: feedbackColor.withOpacity(0.3)),
          ),
          child: Text(
            feedback,
            style: TextStyle(
              color: feedbackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
} 