import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';

class AccessibilityWidgets {
  static final HapticService _hapticService = HapticService();

  // Accessible button with screen reader support
  static Widget accessibleButton({
    required Widget child,
    required String label,
    String? hint,
    VoidCallback? onPressed,
    bool enableHaptic = true,
    String hapticType = AppHaptics.selection,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: onPressed != null,
      child: GestureDetector(
        onTap: () {
          if (onPressed != null) {
            onPressed();
            if (enableHaptic) {
              _hapticService.feedback(hapticType);
            }
          }
        },
        child: child,
      ),
    );
  }

  // Accessible image with description
  static Widget accessibleImage({
    required Widget child,
    required String description,
    String? hint,
  }) {
    return Semantics(
      label: description,
      hint: hint,
      image: true,
      child: child,
    );
  }

  // Accessible text with screen reader support
  static Widget accessibleText({
    required String text,
    required TextStyle style,
    String? hint,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return Semantics(
      label: text,
      hint: hint,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
      ),
    );
  }

  // Accessible container with description
  static Widget accessibleContainer({
    required Widget child,
    required String description,
    String? hint,
  }) {
    return Semantics(
      label: description,
      hint: hint,
      child: child,
    );
  }

  // Accessible progress indicator
  static Widget accessibleProgress({
    required double value,
    required String label,
    String? hint,
    Color? color,
  }) {
    return Semantics(
      label: '$label: ${(value * 100).toStringAsFixed(0)}%',
      hint: hint,
      child: LinearProgressIndicator(
        value: value.toDouble(),
        backgroundColor: AppColors.neutral200,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primary,
        ),
      ),
    );
  }

  // Accessible icon with description
  static Widget accessibleIcon({
    required IconData icon,
    required String description,
    String? hint,
    double? size,
    Color? color,
  }) {
    return Semantics(
      label: description,
      hint: hint,
      child: Icon(
        icon,
        size: size,
        color: color,
      ),
    );
  }
}

// Screen reader announcement widget
class ScreenReaderAnnouncement extends StatelessWidget {
  final String message;
  final Duration duration;
  final bool enableHaptic;

  const ScreenReaderAnnouncement({
    super.key,
    required this.message,
    this.duration = const Duration(seconds: 3),
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: message,
      child: Container(
        width: 0,
        height: 0,
        child: Text(message),
      ),
    );
  }
}

// Accessible navigation widget
class AccessibleNavigation extends StatelessWidget {
  final Widget child;
  final String label;
  final String? hint;
  final VoidCallback? onTap;
  final bool enableHaptic;

  const AccessibleNavigation({
    super.key,
    required this.child,
    required this.label,
    this.hint,
    this.onTap,
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: onTap != null,
      child: GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!();
            if (enableHaptic) {
              HapticService().selection();
            }
          }
        },
        child: child,
      ),
    );
  }
}

// Accessible form field
class AccessibleFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final Widget child;
  final bool isRequired;

  const AccessibleFormField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    required this.child,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isRequired ? '$label (obavezno)' : label,
      hint: hint,
      textField: true,
      child: child,
    );
  }
}

// Accessible list item
class AccessibleListItem extends StatelessWidget {
  final Widget child;
  final String label;
  final String? hint;
  final VoidCallback? onTap;
  final bool isSelected;

  const AccessibleListItem({
    super.key,
    required this.child,
    required this.label,
    this.hint,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isSelected ? '$label (izabrano)' : label,
      hint: hint,
      button: true,
      selected: isSelected,
      enabled: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }
} 