import 'package:flutter/services.dart';
import '../utils/constants.dart';

class HapticService {
  static final HapticService _instance = HapticService._internal();
  factory HapticService() => _instance;
  HapticService._internal();

  bool _isEnabled = true;

  // Enable/disable haptic feedback
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  bool get isEnabled => _isEnabled;

  // Light haptic feedback
  Future<void> light() async {
    if (!_isEnabled) return;
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Fallback for platforms that don't support haptic feedback
    }
  }

  // Medium haptic feedback
  Future<void> medium() async {
    if (!_isEnabled) return;
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      // Fallback for platforms that don't support haptic feedback
    }
  }

  // Heavy haptic feedback
  Future<void> heavy() async {
    if (!_isEnabled) return;
    try {
      await HapticFeedback.heavyImpact();
    } catch (e) {
      // Fallback for platforms that don't support haptic feedback
    }
  }

  // Selection haptic feedback
  Future<void> selection() async {
    if (!_isEnabled) return;
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      // Fallback for platforms that don't support haptic feedback
    }
  }

  // Success haptic feedback
  Future<void> success() async {
    if (!_isEnabled) return;
    try {
      await HapticFeedback.lightImpact();
      await Future.delayed(AppHaptics.lightDuration);
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Fallback for platforms that don't support haptic feedback
    }
  }

  // Warning haptic feedback
  Future<void> warning() async {
    if (!_isEnabled) return;
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      // Fallback for platforms that don't support haptic feedback
    }
  }

  // Error haptic feedback
  Future<void> error() async {
    if (!_isEnabled) return;
    try {
      await HapticFeedback.heavyImpact();
      await Future.delayed(AppHaptics.mediumDuration);
      await HapticFeedback.heavyImpact();
    } catch (e) {
      // Fallback for platforms that don't support haptic feedback
    }
  }

  // Custom haptic feedback based on type
  Future<void> feedback(String type) async {
    switch (type) {
      case AppHaptics.light:
        await light();
        break;
      case AppHaptics.medium:
        await medium();
        break;
      case AppHaptics.heavy:
        await heavy();
        break;
      case AppHaptics.selection:
        await selection();
        break;
      case AppHaptics.success:
        await success();
        break;
      case AppHaptics.warning:
        await warning();
        break;
      case AppHaptics.error:
        await error();
        break;
      default:
        await light();
    }
  }
} 