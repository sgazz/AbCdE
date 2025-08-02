import 'package:flutter/material.dart';
import '../utils/constants.dart';

class InteractiveTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final Widget? richMessage;
  final Duration showDuration;
  final Duration hideDuration;
  final Offset? offset;
  final bool preferBelow;
  final Color? backgroundColor;
  final Color? textColor;
  final double? maxWidth;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const InteractiveTooltip({
    super.key,
    required this.child,
    required this.message,
    this.richMessage,
    this.showDuration = const Duration(milliseconds: 200),
    this.hideDuration = const Duration(milliseconds: 150),
    this.offset,
    this.preferBelow = true,
    this.backgroundColor,
    this.textColor,
    this.maxWidth,
    this.padding,
    this.borderRadius,
  });

  @override
  State<InteractiveTooltip> createState() => _InteractiveTooltipState();
}

class _InteractiveTooltipState extends State<InteractiveTooltip>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.showDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hideTooltip();
    super.dispose();
  }

  void _showTooltip() {
    if (_isVisible) return;
    
    setState(() {
      _isVisible = true;
    });

    _overlayEntry = OverlayEntry(
      builder: (context) => _TooltipOverlay(
        message: widget.message,
        richMessage: widget.richMessage,
        offset: widget.offset,
        preferBelow: widget.preferBelow,
        backgroundColor: widget.backgroundColor,
        textColor: widget.textColor,
        maxWidth: widget.maxWidth,
        padding: widget.padding,
        borderRadius: widget.borderRadius,
        fadeAnimation: _fadeAnimation,
        slideAnimation: _slideAnimation,
        onHide: _hideTooltip,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
  }

  void _hideTooltip() {
    if (!_isVisible) return;

    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      setState(() {
        _isVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _showTooltip(),
      onExit: (_) => _hideTooltip(),
      child: GestureDetector(
        onTapDown: (_) => _showTooltip(),
        onTapUp: (_) => _hideTooltip(),
        onTapCancel: () => _hideTooltip(),
        child: widget.child,
      ),
    );
  }
}

class _TooltipOverlay extends StatelessWidget {
  final String message;
  final Widget? richMessage;
  final Offset? offset;
  final bool preferBelow;
  final Color? backgroundColor;
  final Color? textColor;
  final double? maxWidth;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final VoidCallback onHide;

  const _TooltipOverlay({
    required this.message,
    this.richMessage,
    this.offset,
    required this.preferBelow,
    this.backgroundColor,
    this.textColor,
    this.maxWidth,
    this.padding,
    this.borderRadius,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.onHide,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Background overlay
            Positioned.fill(
              child: GestureDetector(
                onTap: onHide,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            // Tooltip content
            Positioned(
              left: offset?.dx ?? 0,
              top: offset?.dy ?? 0,
              child: AnimatedBuilder(
                animation: Listenable.merge([fadeAnimation, slideAnimation]),
                builder: (context, child) {
                  return Opacity(
                    opacity: fadeAnimation.value,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: _TooltipContent(
                        message: message,
                        richMessage: richMessage,
                        preferBelow: preferBelow,
                        backgroundColor: backgroundColor,
                        textColor: textColor,
                        maxWidth: maxWidth,
                        padding: padding,
                        borderRadius: borderRadius,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TooltipContent extends StatelessWidget {
  final String message;
  final Widget? richMessage;
  final bool preferBelow;
  final Color? backgroundColor;
  final Color? textColor;
  final double? maxWidth;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const _TooltipContent({
    required this.message,
    this.richMessage,
    required this.preferBelow,
    this.backgroundColor,
    this.textColor,
    this.maxWidth,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? 200,
      ),
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.black87,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: richMessage ?? Text(
        message,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class InfoTooltip extends StatelessWidget {
  final Widget child;
  final String info;
  final IconData? icon;

  const InfoTooltip({
    super.key,
    required this.child,
    required this.info,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveTooltip(
      message: info,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          const SizedBox(width: 4),
          Icon(
            icon ?? Icons.info_outline,
            size: 16,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
} 