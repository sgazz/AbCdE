enum AlphabetType { latin, cyrillic, numbers }
enum WritingStyle { cursive, print }

class Letter {
  final String character;
  final AlphabetType alphabetType;
  final WritingStyle writingStyle;
  final String audioPath;
  final String animationPath;
  final List<String> strokeOrder;
  final Map<String, dynamic> expectedShape;

  Letter({
    required this.character,
    required this.alphabetType,
    required this.writingStyle,
    required this.audioPath,
    required this.animationPath,
    required this.strokeOrder,
    required this.expectedShape,
  });

  factory Letter.fromJson(Map<String, dynamic> json) {
    return Letter(
      character: json['character'],
      alphabetType: AlphabetType.values.firstWhere(
        (e) => e.toString() == 'AlphabetType.${json['alphabetType']}',
      ),
      writingStyle: WritingStyle.values.firstWhere(
        (e) => e.toString() == 'WritingStyle.${json['writingStyle']}',
      ),
      audioPath: json['audioPath'],
      animationPath: json['animationPath'],
      strokeOrder: List<String>.from(json['strokeOrder']),
      expectedShape: json['expectedShape'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'character': character,
      'alphabetType': alphabetType.toString().split('.').last,
      'writingStyle': writingStyle.toString().split('.').last,
      'audioPath': audioPath,
      'animationPath': animationPath,
      'strokeOrder': strokeOrder,
      'expectedShape': expectedShape,
    };
  }
}

class LetterProgress {
  final String character;
  final int stars;
  final double accuracy;
  final DateTime lastPracticed;
  final int practiceCount;

  LetterProgress({
    required this.character,
    this.stars = 0,
    this.accuracy = 0.0,
    required this.lastPracticed,
    this.practiceCount = 0,
  });

  factory LetterProgress.fromJson(Map<String, dynamic> json) {
    return LetterProgress(
      character: json['character'],
      stars: json['stars'] ?? 0,
      accuracy: json['accuracy']?.toDouble() ?? 0.0,
      lastPracticed: DateTime.parse(json['lastPracticed']),
      practiceCount: json['practiceCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'character': character,
      'stars': stars,
      'accuracy': accuracy,
      'lastPracticed': lastPracticed.toIso8601String(),
      'practiceCount': practiceCount,
    };
  }
} 