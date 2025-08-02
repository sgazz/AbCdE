import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AnimatedGradientButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final Color? gradientStart;
  final Color? gradientEnd;
  final double? width;
  final double? height;

  const AnimatedGradientButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.gradientStart,
    this.gradientEnd,
    this.width,
    this.height,
  });

  @override
  State<AnimatedGradientButton> createState() => _AnimatedGradientButtonState();
}

class _AnimatedGradientButtonState extends State<AnimatedGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height ?? AppSizes.buttonHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.gradientStart ?? AppColors.primary,
                    widget.gradientEnd ?? AppColors.primaryVariant,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: (widget.gradientStart ?? AppColors.primary).withOpacity(0.3),
                    blurRadius: _isHovered ? 12 : 8,
                    offset: Offset(0, _isHovered ? 4 : 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isLoading ? null : widget.onPressed,
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.padding,
                      vertical: AppSizes.smallPadding,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.isLoading)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        else if (widget.icon != null)
                          Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 20,
                          ),
                        if (widget.icon != null && !widget.isLoading)
                          const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            widget.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GradientOutlinedButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? borderColor;
  final Color? textColor;

  const GradientOutlinedButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.borderColor,
    this.textColor,
  });

  @override
  State<GradientOutlinedButton> createState() => _GradientOutlinedButtonState();
}

class _GradientOutlinedButtonState extends State<GradientOutlinedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.shortDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.defaultCurve,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final Color normalBorder = widget.borderColor ?? AppColors.primary;
    final Color hoverBorder = AppColors.secondary;
    final Color normalText = widget.textColor ?? AppColors.primary;
    final Color hoverText = AppColors.secondary;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: AppAnimations.shortDuration,
                curve: AppAnimations.defaultCurve,
                width: double.infinity,
                height: AppSizes.buttonHeight,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isHovered ? hoverBorder : normalBorder,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  color: Colors.transparent,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.isLoading ? null : widget.onPressed,
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.padding,
                        vertical: AppSizes.smallPadding,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            )
                          else if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: _isHovered ? hoverText : normalText,
                              size: AppSizes.iconSize,
                            ),
                            const SizedBox(width: AppSizes.smallPadding),
                          ],
                          Flexible(
                            child: Text(
                              widget.text,
                              style: TextStyle(
                                color: _isHovered ? hoverText : normalText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 