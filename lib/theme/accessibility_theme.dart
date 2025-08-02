import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AccessibilityTheme {
  // High contrast colors
  static const Color highContrastPrimary = Color(0xFF000000);
  static const Color highContrastSecondary = Color(0xFFFFFFFF);
  static const Color highContrastBackground = Color(0xFFFFFFFF);
  static const Color highContrastSurface = Color(0xFF000000);
  static const Color highContrastError = Color(0xFFFF0000);
  static const Color highContrastSuccess = Color(0xFF00FF00);
  static const Color highContrastWarning = Color(0xFFFF8000);

  // High contrast theme
  static ThemeData get highContrastTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: highContrastPrimary,
        primaryContainer: highContrastPrimary,
        secondary: highContrastSecondary,
        secondaryContainer: highContrastSecondary,
        surface: highContrastSurface,
        background: highContrastBackground,
        error: highContrastError,
        onPrimary: highContrastSecondary,
        onSecondary: highContrastPrimary,
        onSurface: highContrastSecondary,
        onBackground: highContrastPrimary,
        onError: highContrastSecondary,
      ),
      cardTheme: CardThemeData(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        color: highContrastSurface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: highContrastPrimary,
          foregroundColor: highContrastSecondary,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: highContrastPrimary,
          side: const BorderSide(color: highContrastPrimary, width: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: highContrastPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: const BorderSide(color: highContrastPrimary, width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: const BorderSide(color: highContrastPrimary, width: 4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: const BorderSide(color: highContrastPrimary, width: 3),
        ),
        filled: true,
        fillColor: highContrastBackground,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: highContrastPrimary,
        foregroundColor: highContrastSecondary,
        elevation: 8,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: highContrastSurface,
        selectedItemColor: highContrastPrimary,
        unselectedItemColor: highContrastSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: highContrastSurface,
        selectedColor: highContrastPrimary,
        disabledColor: highContrastSecondary,
        labelStyle: const TextStyle(
          color: highContrastPrimary,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          side: const BorderSide(color: highContrastPrimary, width: 2),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: highContrastPrimary,
        linearTrackColor: highContrastSecondary,
        circularTrackColor: highContrastSecondary,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: highContrastPrimary,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: highContrastPrimary,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: highContrastPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: highContrastPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: highContrastPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: highContrastPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: highContrastPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: highContrastPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(
          color: highContrastPrimary,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: highContrastPrimary,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: highContrastPrimary,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: highContrastPrimary,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: highContrastPrimary,
          fontWeight: FontWeight.bold,
        ),
        labelMedium: TextStyle(
          color: highContrastPrimary,
          fontWeight: FontWeight.bold,
        ),
        labelSmall: TextStyle(
          color: highContrastPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Large text theme
  static ThemeData get largeTextTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 48),
        displayMedium: TextStyle(fontSize: 40),
        displaySmall: TextStyle(fontSize: 32),
        headlineLarge: TextStyle(fontSize: 28),
        headlineMedium: TextStyle(fontSize: 24),
        headlineSmall: TextStyle(fontSize: 20),
        titleLarge: TextStyle(fontSize: 18),
        titleMedium: TextStyle(fontSize: 16),
        titleSmall: TextStyle(fontSize: 14),
        bodyLarge: TextStyle(fontSize: 18),
        bodyMedium: TextStyle(fontSize: 16),
        bodySmall: TextStyle(fontSize: 14),
        labelLarge: TextStyle(fontSize: 16),
        labelMedium: TextStyle(fontSize: 14),
        labelSmall: TextStyle(fontSize: 12),
      ),
    );
  }

  // Reduced motion theme
  static ThemeData get reducedMotionTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      // Disable animations for reduced motion
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

// Accessibility theme provider
class AccessibilityThemeProvider extends ChangeNotifier {
  bool _isHighContrast = false;
  bool _isLargeText = false;
  bool _isReducedMotion = false;

  bool get isHighContrast => _isHighContrast;
  bool get isLargeText => _isLargeText;
  bool get isReducedMotion => _isReducedMotion;

  void setHighContrast(bool enabled) {
    _isHighContrast = enabled;
    notifyListeners();
  }

  void setLargeText(bool enabled) {
    _isLargeText = enabled;
    notifyListeners();
  }

  void setReducedMotion(bool enabled) {
    _isReducedMotion = enabled;
    notifyListeners();
  }

  ThemeData getTheme(ThemeData baseTheme) {
    if (_isHighContrast) {
      return AccessibilityTheme.highContrastTheme;
    }
    
    if (_isLargeText) {
      return baseTheme.copyWith(
        textTheme: AccessibilityTheme.largeTextTheme.textTheme,
      );
    }
    
    if (_isReducedMotion) {
      return baseTheme.copyWith(
        pageTransitionsTheme: AccessibilityTheme.reducedMotionTheme.pageTransitionsTheme,
      );
    }
    
    return baseTheme;
  }
} 