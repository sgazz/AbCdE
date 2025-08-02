import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6200EE);
  static const Color primaryVariant = Color(0xFF3700B3);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryVariant = Color(0xFF018786);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFF000000);
  static const Color onSurface = Color(0xFF000000);
  static const Color onError = Color(0xFFFFFFFF);
  
  // Custom colors
  static const Color starColor = Color(0xFFFFD700);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color drawingColor = Color(0xFF000000);
  static const Color gridColor = Color(0xFFE0E0E0);
}

class AppSizes {
  static const double padding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double starSize = 30.0;
  static const double letterSize = 120.0;
  static const double canvasSize = 300.0;
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