import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_preferences.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

class SettingsService extends ChangeNotifier {
  static SettingsService? _instance;
  static SettingsService get instance => _instance ??= SettingsService._();

  SettingsService._();

  UserPreferences _preferences = const UserPreferences();
  ThemeProvider _themeProvider = ThemeProvider();

  UserPreferences get preferences => _preferences;
  ThemeProvider get themeProvider => _themeProvider;

  // Theme Options
  static const List<ThemeOption> themeOptions = [
    ThemeOption(
      name: 'default',
      displayName: 'Podrazumevano',
      primaryColor: AppColors.primary,
      secondaryColor: AppColors.secondary,
      icon: Icons.palette,
    ),
    ThemeOption(
      name: 'blue',
      displayName: 'Plava',
      primaryColor: Color(0xFF1976D2),
      secondaryColor: Color(0xFF2196F3),
      icon: Icons.water_drop,
    ),
    ThemeOption(
      name: 'green',
      displayName: 'Zelena',
      primaryColor: Color(0xFF4CAF50),
      secondaryColor: Color(0xFF66BB6A),
      icon: Icons.eco,
    ),
    ThemeOption(
      name: 'purple',
      displayName: 'Ljubičasta',
      primaryColor: Color(0xFF9C27B0),
      secondaryColor: Color(0xFFAB47BC),
      icon: Icons.auto_awesome,
    ),
    ThemeOption(
      name: 'orange',
      displayName: 'Narandžasta',
      primaryColor: Color(0xFFFF9800),
      secondaryColor: Color(0xFFFFA726),
      icon: Icons.local_fire_department,
    ),
  ];

  // Language Options
  static const List<LanguageOption> languageOptions = [
    LanguageOption(
      code: 'sr',
      name: 'Serbian',
      nativeName: 'Српски',
      flag: '🇷🇸',
    ),
    LanguageOption(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flag: '🇺🇸',
    ),
    LanguageOption(
      code: 'de',
      name: 'German',
      nativeName: 'Deutsch',
      flag: '🇩🇪',
    ),
    LanguageOption(
      code: 'fr',
      name: 'French',
      nativeName: 'Français',
      flag: '🇫🇷',
    ),
  ];

  // Difficulty Levels
  static const List<DifficultyLevel> difficultyLevels = [
    DifficultyLevel(
      name: 'easy',
      displayName: 'Lako',
      description: 'Veći tolerancija za greške, više vremena',
      tolerance: 0.8,
      timeLimit: 60,
    ),
    DifficultyLevel(
      name: 'medium',
      displayName: 'Srednje',
      description: 'Uravnotežena težina',
      tolerance: 0.6,
      timeLimit: 45,
    ),
    DifficultyLevel(
      name: 'hard',
      displayName: 'Teško',
      description: 'Manja tolerancija, manje vremena',
      tolerance: 0.4,
      timeLimit: 30,
    ),
  ];

  // Accessibility Options
  static const List<AccessibilityOption> accessibilityOptions = [
    AccessibilityOption(
      name: 'highContrast',
      displayName: 'Visok kontrast',
      description: 'Povećava kontrast za bolju vidljivost',
      icon: Icons.contrast,
    ),
    AccessibilityOption(
      name: 'largeText',
      displayName: 'Veliki tekst',
      description: 'Povećava veličinu teksta',
      icon: Icons.text_fields,
    ),
    AccessibilityOption(
      name: 'reducedMotion',
      displayName: 'Smanjena animacija',
      description: 'Smanjuje animacije za bolju pristupačnost',
      icon: Icons.motion_photos_pause,
    ),
    AccessibilityOption(
      name: 'screenReader',
      displayName: 'Čitač ekrana',
      description: 'Omogućava podršku za čitač ekrana',
      icon: Icons.accessibility,
    ),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  // Load preferences from storage
  Future<void> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final preferencesJson = prefs.getString('user_preferences');
      
      if (preferencesJson != null) {
        final Map<String, dynamic> json = jsonDecode(preferencesJson);
        _preferences = UserPreferences.fromJson(json);
        
        // Apply theme
        _themeProvider.setTheme(_preferences.theme);
        _themeProvider.setThemeMode(_preferences.isDarkMode ? ThemeMode.dark : ThemeMode.light);
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    }
  }

  // Save preferences to storage
  Future<void> savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final preferencesJson = jsonEncode(_preferences.toJson());
      await prefs.setString('user_preferences', preferencesJson);
    } catch (e) {
      debugPrint('Error saving preferences: $e');
    }
  }

  // Update preferences
  Future<void> updatePreferences(UserPreferences newPreferences) async {
    _preferences = newPreferences;
    
    // Apply theme changes
    _themeProvider.setTheme(_preferences.theme);
    _themeProvider.setThemeMode(_preferences.isDarkMode ? ThemeMode.dark : ThemeMode.light);
    
    await savePreferences();
    notifyListeners();
  }

  // Update specific preference
  Future<void> updatePreference<T>(String key, T value) async {
    UserPreferences newPreferences;
    
    switch (key) {
      case 'theme':
        newPreferences = _preferences.copyWith(theme: value as String);
        break;
      case 'isDarkMode':
        newPreferences = _preferences.copyWith(isDarkMode: value as bool);
        break;
      case 'language':
        newPreferences = _preferences.copyWith(language: value as String);
        break;
      case 'soundEnabled':
        newPreferences = _preferences.copyWith(soundEnabled: value as bool);
        break;
      case 'vibrationEnabled':
        newPreferences = _preferences.copyWith(vibrationEnabled: value as bool);
        break;
      case 'animationSpeed':
        newPreferences = _preferences.copyWith(animationSpeed: value as double);
        break;
      case 'difficultyLevel':
        newPreferences = _preferences.copyWith(difficultyLevel: value as String);
        break;
      case 'showHints':
        newPreferences = _preferences.copyWith(showHints: value as bool);
        break;
      case 'autoSave':
        newPreferences = _preferences.copyWith(autoSave: value as bool);
        break;
      case 'preferredAlphabet':
        newPreferences = _preferences.copyWith(preferredAlphabet: value as String);
        break;
      case 'preferredWritingStyle':
        newPreferences = _preferences.copyWith(preferredWritingStyle: value as String);
        break;
      case 'accessibilityMode':
        newPreferences = _preferences.copyWith(accessibilityMode: value as bool);
        break;
      case 'fontSize':
        newPreferences = _preferences.copyWith(fontSize: value as double);
        break;
      case 'highContrast':
        newPreferences = _preferences.copyWith(highContrast: value as bool);
        break;
      default:
        return;
    }
    
    await updatePreferences(newPreferences);
  }

  // Get theme option by name
  ThemeOption? getThemeOption(String name) {
    try {
      return themeOptions.firstWhere((option) => option.name == name);
    } catch (e) {
      return null;
    }
  }

  // Get language option by code
  LanguageOption? getLanguageOption(String code) {
    try {
      return languageOptions.firstWhere((option) => option.code == code);
    } catch (e) {
      return null;
    }
  }

  // Get difficulty level by name
  DifficultyLevel? getDifficultyLevel(String name) {
    try {
      return difficultyLevels.firstWhere((level) => level.name == name);
    } catch (e) {
      return null;
    }
  }

  // Get accessibility option by name
  AccessibilityOption? getAccessibilityOption(String name) {
    try {
      return accessibilityOptions.firstWhere((option) => option.name == name);
    } catch (e) {
      return null;
    }
  }

  // Reset to default preferences
  Future<void> resetToDefaults() async {
    await updatePreferences(const UserPreferences());
  }

  // Export preferences
  String exportPreferences() {
    return jsonEncode(_preferences.toJson());
  }

  // Import preferences
  Future<void> importPreferences(String jsonString) async {
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      final importedPreferences = UserPreferences.fromJson(json);
      await updatePreferences(importedPreferences);
    } catch (e) {
      debugPrint('Error importing preferences: $e');
    }
  }

  // Get current theme
  ThemeData getTheme() {
    switch (_preferences.theme) {
      case 'blue':
        return AppTheme.blueTheme;
      case 'green':
        return AppTheme.greenTheme;
      case 'purple':
        return AppTheme.purpleTheme;
      case 'orange':
        return AppTheme.orangeTheme;
      case 'dark':
        return AppTheme.darkTheme;
      default:
        return AppTheme.lightTheme;
    }
  }
} 