import 'package:flutter/material.dart';

class UserPreferences {
  final String theme;
  final bool isDarkMode;
  final String language;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final double animationSpeed;
  final String difficultyLevel;
  final bool showHints;
  final bool autoSave;
  final String preferredAlphabet;
  final String preferredWritingStyle;
  final bool accessibilityMode;
  final double fontSize;
  final bool highContrast;

  const UserPreferences({
    this.theme = 'default',
    this.isDarkMode = false,
    this.language = 'sr',
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.animationSpeed = 1.0,
    this.difficultyLevel = 'medium',
    this.showHints = true,
    this.autoSave = true,
    this.preferredAlphabet = 'latin',
    this.preferredWritingStyle = 'cursive',
    this.accessibilityMode = false,
    this.fontSize = 1.0,
    this.highContrast = false,
  });

  UserPreferences copyWith({
    String? theme,
    bool? isDarkMode,
    String? language,
    bool? soundEnabled,
    bool? vibrationEnabled,
    double? animationSpeed,
    String? difficultyLevel,
    bool? showHints,
    bool? autoSave,
    String? preferredAlphabet,
    String? preferredWritingStyle,
    bool? accessibilityMode,
    double? fontSize,
    bool? highContrast,
  }) {
    return UserPreferences(
      theme: theme ?? this.theme,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      animationSpeed: animationSpeed ?? this.animationSpeed,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      showHints: showHints ?? this.showHints,
      autoSave: autoSave ?? this.autoSave,
      preferredAlphabet: preferredAlphabet ?? this.preferredAlphabet,
      preferredWritingStyle: preferredWritingStyle ?? this.preferredWritingStyle,
      accessibilityMode: accessibilityMode ?? this.accessibilityMode,
      fontSize: fontSize ?? this.fontSize,
      highContrast: highContrast ?? this.highContrast,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'isDarkMode': isDarkMode,
      'language': language,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'animationSpeed': animationSpeed,
      'difficultyLevel': difficultyLevel,
      'showHints': showHints,
      'autoSave': autoSave,
      'preferredAlphabet': preferredAlphabet,
      'preferredWritingStyle': preferredWritingStyle,
      'accessibilityMode': accessibilityMode,
      'fontSize': fontSize,
      'highContrast': highContrast,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      theme: json['theme'] ?? 'default',
      isDarkMode: json['isDarkMode'] ?? false,
      language: json['language'] ?? 'sr',
      soundEnabled: json['soundEnabled'] ?? true,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      animationSpeed: json['animationSpeed']?.toDouble() ?? 1.0,
      difficultyLevel: json['difficultyLevel'] ?? 'medium',
      showHints: json['showHints'] ?? true,
      autoSave: json['autoSave'] ?? true,
      preferredAlphabet: json['preferredAlphabet'] ?? 'latin',
      preferredWritingStyle: json['preferredWritingStyle'] ?? 'cursive',
      accessibilityMode: json['accessibilityMode'] ?? false,
      fontSize: json['fontSize']?.toDouble() ?? 1.0,
      highContrast: json['highContrast'] ?? false,
    );
  }

  @override
  String toString() {
    return 'UserPreferences(theme: $theme, isDarkMode: $isDarkMode, language: $language, soundEnabled: $soundEnabled, vibrationEnabled: $vibrationEnabled, animationSpeed: $animationSpeed, difficultyLevel: $difficultyLevel, showHints: $showHints, autoSave: $autoSave, preferredAlphabet: $preferredAlphabet, preferredWritingStyle: $preferredWritingStyle, accessibilityMode: $accessibilityMode, fontSize: $fontSize, highContrast: $highContrast)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserPreferences &&
        other.theme == theme &&
        other.isDarkMode == isDarkMode &&
        other.language == language &&
        other.soundEnabled == soundEnabled &&
        other.vibrationEnabled == vibrationEnabled &&
        other.animationSpeed == animationSpeed &&
        other.difficultyLevel == difficultyLevel &&
        other.showHints == showHints &&
        other.autoSave == autoSave &&
        other.preferredAlphabet == preferredAlphabet &&
        other.preferredWritingStyle == preferredWritingStyle &&
        other.accessibilityMode == accessibilityMode &&
        other.fontSize == fontSize &&
        other.highContrast == highContrast;
  }

  @override
  int get hashCode {
    return Object.hash(
      theme,
      isDarkMode,
      language,
      soundEnabled,
      vibrationEnabled,
      animationSpeed,
      difficultyLevel,
      showHints,
      autoSave,
      preferredAlphabet,
      preferredWritingStyle,
      accessibilityMode,
      fontSize,
      highContrast,
    );
  }
}

// Theme Options
class ThemeOption {
  final String name;
  final String displayName;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;

  const ThemeOption({
    required this.name,
    required this.displayName,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
  });
}

// Language Options
class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });

  String get displayName => nativeName.isNotEmpty ? nativeName : name;
}

// Difficulty Levels
class DifficultyLevel {
  final String name;
  final String displayName;
  final String description;
  final double tolerance;
  final int timeLimit;

  const DifficultyLevel({
    required this.name,
    required this.displayName,
    required this.description,
    required this.tolerance,
    required this.timeLimit,
  });
}

// Accessibility Options
class AccessibilityOption {
  final String name;
  final String displayName;
  final String description;
  final IconData icon;
  final bool isEnabled;

  const AccessibilityOption({
    required this.name,
    required this.displayName,
    required this.description,
    required this.icon,
    this.isEnabled = false,
  });
} 