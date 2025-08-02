import 'letter.dart';

class UserProgress {
  final Map<String, LetterProgress> letterProgress;
  final int totalStars;
  final int totalPracticeSessions;
  final DateTime lastSession;
  final List<Achievement> achievements;

  UserProgress({
    required this.letterProgress,
    this.totalStars = 0,
    this.totalPracticeSessions = 0,
    required this.lastSession,
    this.achievements = const [],
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    Map<String, LetterProgress> progress = {};
    if (json['letterProgress'] != null) {
      json['letterProgress'].forEach((key, value) {
        progress[key] = LetterProgress.fromJson(value);
      });
    }

    List<Achievement> achievements = [];
    if (json['achievements'] != null) {
      achievements = (json['achievements'] as List)
          .map((a) => Achievement.fromJson(a))
          .toList();
    }

    return UserProgress(
      letterProgress: progress,
      totalStars: json['totalStars'] ?? 0,
      totalPracticeSessions: json['totalPracticeSessions'] ?? 0,
      lastSession: DateTime.parse(json['lastSession']),
      achievements: achievements,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> progressJson = {};
    letterProgress.forEach((key, value) {
      progressJson[key] = value.toJson();
    });

    return {
      'letterProgress': progressJson,
      'totalStars': totalStars,
      'totalPracticeSessions': totalPracticeSessions,
      'lastSession': lastSession.toIso8601String(),
      'achievements': achievements.map((a) => a.toJson()).toList(),
    };
  }

  double get overallAccuracy {
    if (letterProgress.isEmpty) return 0.0;
    double totalAccuracy = letterProgress.values
        .map((progress) => progress.accuracy)
        .reduce((a, b) => a + b);
    return totalAccuracy / letterProgress.length;
  }

  int get masteredLetters {
    return letterProgress.values
        .where((progress) => progress.stars >= 4)
        .length;
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int requiredStars;
  final int requiredLetters;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    this.isUnlocked = false,
    this.unlockedAt,
    required this.requiredStars,
    required this.requiredLetters,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconPath: json['iconPath'],
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
      requiredStars: json['requiredStars'],
      requiredLetters: json['requiredLetters'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconPath': iconPath,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'requiredStars': requiredStars,
      'requiredLetters': requiredLetters,
    };
  }
} 