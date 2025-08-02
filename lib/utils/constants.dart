import 'package:flutter/material.dart';

class AppColors {
  // Moderna paleta boja
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryVariant = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF10B981); // Emerald
  static const Color secondaryVariant = Color(0xFF059669);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFEF4444);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF1E293B);
  static const Color onSurface = Color(0xFF1E293B);
  static const Color onError = Color(0xFFFFFFFF);
  
  // Gradijenti
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Custom colors
  static const Color starColor = Color(0xFFFFD700);
  static const Color successGreen = Color(0xFF22C55E);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color drawingColor = Color(0xFF1E293B);
  static const Color gridColor = Color(0xFFE2E8F0);
  
  // Neutral colors
  static const Color neutral50 = Color(0xFFF8FAFC);
  static const Color neutral100 = Color(0xFFF1F5F9);
  static const Color neutral200 = Color(0xFFE2E8F0);
  static const Color neutral300 = Color(0xFFCBD5E1);
  static const Color neutral400 = Color(0xFF94A3B8);
  static const Color neutral500 = Color(0xFF64748B);
  static const Color neutral600 = Color(0xFF475569);
  static const Color neutral700 = Color(0xFF334155);
  static const Color neutral800 = Color(0xFF1E293B);
  static const Color neutral900 = Color(0xFF0F172A);
  
  // Additional colors for performance monitor
  static const Color warning = Color(0xFFF6AD55);
  static const Color info = Color(0xFF4299E1);
}

class AppSizes {
  // Osnovne veličine
  static const double padding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  // Border radius
  static const double radius = 12.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
  static const double extraLargeBorderRadius = 24.0;
  
  // Button dimensions
  static const double buttonHeight = 48.0;
  static const double smallButtonHeight = 40.0;
  static const double largeButtonHeight = 56.0;
  
  // Icon sizes
  static const double iconSize = 24.0;
  static const double smallIconSize = 20.0;
  static const double largeIconSize = 32.0;
  static const double extraLargeIconSize = 48.0;
  
  // Special sizes
  static const double starSize = 30.0;
  static const double letterSize = 120.0;
  static const double canvasSize = 300.0;
  
  // Spacing
  static const double spacing = 16.0;
  static const double smallSpacing = 8.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;
  
  // Elevation
  static const double elevation = 4.0;
  static const double smallElevation = 2.0;
  static const double largeElevation = 8.0;
}

class AppStrings {
  // App title
  static const String appTitle = 'Učenje pisanja';
  
  // Navigation
  static const String home = 'Početna';
  static const String lessons = 'Lekcije';
  static const String progress = 'Napredak';
  static const String settings = 'Podešavanja';
  
  // Lessons
  static const String latinAlphabet = 'Latinica';
  static const String cyrillicAlphabet = 'Ćirilica';
  static const String numbers = 'Brojevi';
  static const String cursive = 'Rukopis';
  static const String print = 'Štampana slova';
  
  // Instructions
  static const String drawLetter = 'Nacrtaj slovo';
  static const String followTrace = 'Prati liniju';
  static const String practiceAgain = 'Vežbaj ponovo';
  static const String excellent = 'Odlično!';
  static const String good = 'Dobro!';
  static const String tryAgain = 'Pokušaj ponovo';
  
  // Achievements
  static const String achievementUnlocked = 'Dostignuće otključano!';
  static const String newAchievement = 'Novo dostignuće';
  
  // Settings
  static const String audioEnabled = 'Zvuk uključen';
  static const String animationsEnabled = 'Animacije uključene';
  static const String volume = 'Glasnoća';
  static const String difficulty = 'Težina';
  static const String language = 'Jezik';
  
  // Errors
  static const String errorLoading = 'Greška pri učitavanju';
  static const String errorSaving = 'Greška pri čuvanju';
  static const String tryAgainLater = 'Pokušajte ponovo kasnije';
}

class AppAnimations {
  static const Duration shortDuration = Duration(milliseconds: 300);
  static const Duration mediumDuration = Duration(milliseconds: 500);
  static const Duration longDuration = Duration(milliseconds: 800);
  
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve slideCurve = Curves.easeInOutCubic;
}

class AppHaptics {
  static const Duration lightDuration = Duration(milliseconds: 50);
  static const Duration mediumDuration = Duration(milliseconds: 100);
  static const Duration heavyDuration = Duration(milliseconds: 200);
  
  // Haptic feedback types
  static const String light = 'light';
  static const String medium = 'medium';
  static const String heavy = 'heavy';
  static const String selection = 'selection';
  static const String impact = 'impact';
  static const String notification = 'notification';
  static const String success = 'success';
  static const String warning = 'warning';
  static const String error = 'error';
}

class LetterData {
  static const List<String> latinLetters = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
    'U', 'V', 'W', 'X', 'Y', 'Z'
  ];
  
  static const List<String> cyrillicLetters = [
    'А', 'Б', 'В', 'Г', 'Д', 'Е', 'Ё', 'Ж', 'З', 'И',
    'Й', 'К', 'Л', 'М', 'Н', 'О', 'П', 'Р', 'С', 'Т',
    'У', 'Ф', 'Х', 'Ц', 'Ч', 'Ш', 'Щ', 'Ъ', 'Ы', 'Ь',
    'Э', 'Ю', 'Я'
  ];
  
  static const List<String> numbers = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
  ];
}

class AchievementData {
  static const Map<String, Map<String, dynamic>> achievements = {
    'first_practice': {
      'title': 'Prvi korak',
      'description': 'Završili ste svoju prvu lekciju!',
      'icon': 'first_practice.png',
      'requiredStars': 1,
      'requiredLetters': 1,
    },
    'five_stars': {
      'title': 'Zvezdica',
      'description': 'Osvojili ste 5 zvezdica!',
      'icon': 'five_stars.png',
      'requiredStars': 5,
      'requiredLetters': 1,
    },
    'ten_letters': {
      'title': 'Pismen',
      'description': 'Savladali ste 10 slova!',
      'icon': 'ten_letters.png',
      'requiredStars': 40,
      'requiredLetters': 10,
    },
    'perfect_writer': {
      'title': 'Savršen pisac',
      'description': 'Dostigli ste 90% tačnost!',
      'icon': 'perfect_writer.png',
      'requiredStars': 45,
      'requiredLetters': 5,
    },
    'alphabet_master': {
      'title': 'Majstor alfabeta',
      'description': 'Savladali ste ceo alfabet!',
      'icon': 'alphabet_master.png',
      'requiredStars': 130,
      'requiredLetters': 26,
    },
  };
} 