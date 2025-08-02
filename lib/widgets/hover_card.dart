import 'package:flutter/material.dart';
import '../utils/constants.dart';

class HoverCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final BorderRadius? borderRadius;

  const HoverCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.elevation,
    this.borderRadius,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = widget.borderRadius ?? BorderRadius.circular(AppSizes.borderRadius);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppAnimations.shortDuration,
        curve: AppAnimations.defaultCurve,
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          gradient: _isHovered ? AppColors.secondaryGradient : null,
          color: _isHovered ? null : AppColors.surface,
          borderRadius: radius,
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: widget.child,
      ),
    );
  }
}