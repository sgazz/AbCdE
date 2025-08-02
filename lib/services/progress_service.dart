import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_progress.dart';
import '../models/letter.dart';

class ProgressService {
  static ProgressService? _instance;
  static const String _progressKey = 'user_progress';
  static const String _settingsKey = 'app_settings';
  
  static ProgressService get instance {
    _instance ??= ProgressService._internal();
    return _instance!;
  }

  ProgressService._internal();

  Future<UserProgress> loadProgress() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? progressJson = prefs.getString(_progressKey);
      
      if (progressJson != null) {
        Map<String, dynamic> progressMap = json.decode(progressJson);
        return UserProgress.fromJson(progressMap);
      }
    } catch (e) {
      print('Error loading progress: $e');
    }
    
    // Vraćanje praznog progres-a ako nema podataka
    return UserProgress(
      letterProgress: {},
      lastSession: DateTime.now(),
    );
  }

  Future<void> saveProgress(UserProgress progress) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String progressJson = json.encode(progress.toJson());
      await prefs.setString(_progressKey, progressJson);
    } catch (e) {
      print('Error saving progress: $e');
    }
  }

  Future<void> updateLetterProgress(String letter, LetterProgress letterProgress) async {
    UserProgress progress = await loadProgress();
    
    Map<String, LetterProgress> updatedProgress = Map.from(progress.letterProgress);
    updatedProgress[letter] = letterProgress;
    
    // Ažuriranje ukupnih statistika
    int totalStars = updatedProgress.values
        .map((p) => p.stars)
        .reduce((a, b) => a + b);
    
    UserProgress updatedUserProgress = UserProgress(
      letterProgress: updatedProgress,
      totalStars: totalStars,
      totalPracticeSessions: progress.totalPracticeSessions + 1,
      lastSession: DateTime.now(),
      achievements: progress.achievements,
    );
    
    await saveProgress(updatedUserProgress);
  }

  Future<void> addAchievement(Achievement achievement) async {
    UserProgress progress = await loadProgress();
    
    List<Achievement> updatedAchievements = List.from(progress.achievements);
    updatedAchievements.add(achievement);
    
    UserProgress updatedUserProgress = UserProgress(
      letterProgress: progress.letterProgress,
      totalStars: progress.totalStars,
      totalPracticeSessions: progress.totalPracticeSessions,
      lastSession: progress.lastSession,
      achievements: updatedAchievements,
    );
    
    await saveProgress(updatedUserProgress);
  }

  Future<Map<String, dynamic>> loadSettings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? settingsJson = prefs.getString(_settingsKey);
      
      if (settingsJson != null) {
        return json.decode(settingsJson);
      }
    } catch (e) {
      print('Error loading settings: $e');
    }
    
    // Vraćanje default postavki
    return {
      'audioEnabled': true,
      'audioVolume': 0.8,
      'animationsEnabled': true,
      'selectedAlphabet': 'latin',
      'selectedWritingStyle': 'cursive',
      'difficultyLevel': 'beginner',
    };
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String settingsJson = json.encode(settings);
      await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  Future<List<Achievement>> checkForNewAchievements(UserProgress progress) async {
    List<Achievement> newAchievements = [];
    
    // Achievement za prvi uspešan pokušaj
    if (progress.totalPracticeSessions == 1) {
      newAchievements.add(Achievement(
        id: 'first_practice',
        title: 'Prvi korak',
        description: 'Završili ste svoju prvu lekciju!',
        iconPath: 'assets/images/achievements/first_practice.png',
        requiredStars: 1,
        requiredLetters: 1,
      ));
    }
    
    // Achievement za 5 zvezdica
    if (progress.totalStars >= 5) {
      bool hasFiveStarAchievement = progress.achievements
          .any((a) => a.id == 'five_stars');
      
      if (!hasFiveStarAchievement) {
        newAchievements.add(Achievement(
          id: 'five_stars',
          title: 'Zvezdica',
          description: 'Osvojili ste 5 zvezdica!',
          iconPath: 'assets/images/achievements/five_stars.png',
          requiredStars: 5,
          requiredLetters: 1,
        ));
      }
    }
    
    // Achievement za 10 savladanih slova
    if (progress.masteredLetters >= 10) {
      bool hasTenLettersAchievement = progress.achievements
          .any((a) => a.id == 'ten_letters');
      
      if (!hasTenLettersAchievement) {
        newAchievements.add(Achievement(
          id: 'ten_letters',
          title: 'Pismen',
          description: 'Savladali ste 10 slova!',
          iconPath: 'assets/images/achievements/ten_letters.png',
          requiredStars: 40,
          requiredLetters: 10,
        ));
      }
    }
    
    // Achievement za 100% tačnost
    if (progress.overallAccuracy >= 0.9 && progress.letterProgress.length >= 5) {
      bool hasPerfectAchievement = progress.achievements
          .any((a) => a.id == 'perfect_writer');
      
      if (!hasPerfectAchievement) {
        newAchievements.add(Achievement(
          id: 'perfect_writer',
          title: 'Savršen pisac',
          description: 'Dostigli ste 90% tačnost!',
          iconPath: 'assets/images/achievements/perfect_writer.png',
          requiredStars: 45,
          requiredLetters: 5,
        ));
      }
    }
    
    return newAchievements;
  }

  Future<void> resetProgress() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_progressKey);
    } catch (e) {
      print('Error resetting progress: $e');
    }
  }

  Future<Map<String, dynamic>> getStatistics() async {
    UserProgress progress = await loadProgress();
    
    return {
      'totalLettersPracticed': progress.letterProgress.length,
      'totalStars': progress.totalStars,
      'totalSessions': progress.totalPracticeSessions,
      'overallAccuracy': progress.overallAccuracy,
      'masteredLetters': progress.masteredLetters,
      'achievementsUnlocked': progress.achievements.length,
      'lastSession': progress.lastSession.toIso8601String(),
    };
  }
} 