enum LessonType { beginner, intermediate, advanced }
enum LessonStatus { locked, unlocked, completed }

class Lesson {
  final String id;
  final String title;
  final String description;
  final LessonType type;
  final List<String> letters;
  final int requiredStars;
  final String iconPath;
  final LessonStatus status;
  final DateTime? completedAt;
  final double accuracy;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.letters,
    required this.requiredStars,
    required this.iconPath,
    this.status = LessonStatus.locked,
    this.completedAt,
    this.accuracy = 0.0,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: LessonType.values.firstWhere(
        (e) => e.toString() == 'LessonType.${json['type']}',
      ),
      letters: List<String>.from(json['letters']),
      requiredStars: json['requiredStars'],
      iconPath: json['iconPath'],
      status: LessonStatus.values.firstWhere(
        (e) => e.toString() == 'LessonStatus.${json['status']}',
      ),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      accuracy: json['accuracy']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'letters': letters,
      'requiredStars': requiredStars,
      'iconPath': iconPath,
      'status': status.toString().split('.').last,
      'completedAt': completedAt?.toIso8601String(),
      'accuracy': accuracy,
    };
  }

  Lesson copyWith({
    String? id,
    String? title,
    String? description,
    LessonType? type,
    List<String>? letters,
    int? requiredStars,
    String? iconPath,
    LessonStatus? status,
    DateTime? completedAt,
    double? accuracy,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      letters: letters ?? this.letters,
      requiredStars: requiredStars ?? this.requiredStars,
      iconPath: iconPath ?? this.iconPath,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      accuracy: accuracy ?? this.accuracy,
    );
  }
}

class LessonProgress {
  final String lessonId;
  final int completedLetters;
  final int totalStars;
  final double averageAccuracy;
  final DateTime lastPracticed;
  final int practiceCount;

  LessonProgress({
    required this.lessonId,
    this.completedLetters = 0,
    this.totalStars = 0,
    this.averageAccuracy = 0.0,
    required this.lastPracticed,
    this.practiceCount = 0,
  });

  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    return LessonProgress(
      lessonId: json['lessonId'],
      completedLetters: json['completedLetters'] ?? 0,
      totalStars: json['totalStars'] ?? 0,
      averageAccuracy: json['averageAccuracy']?.toDouble() ?? 0.0,
      lastPracticed: DateTime.parse(json['lastPracticed']),
      practiceCount: json['practiceCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'completedLetters': completedLetters,
      'totalStars': totalStars,
      'averageAccuracy': averageAccuracy,
      'lastPracticed': lastPracticed.toIso8601String(),
      'practiceCount': practiceCount,
    };
  }
}

class LessonData {
  static List<Lesson> getLatinLessons() {
    return [
      Lesson(
        id: 'latin_basic_1',
        title: 'Osnovna slova',
        description: 'Naučite prva slova alfabeta',
        type: LessonType.beginner,
        letters: ['A', 'B', 'C', 'D', 'E'],
        requiredStars: 0,
        iconPath: 'assets/images/lessons/basic_1.png',
        status: LessonStatus.unlocked,
      ),
      Lesson(
        id: 'latin_basic_2',
        title: 'Srednja slova',
        description: 'Nastavite sa sledećim slovima',
        type: LessonType.beginner,
        letters: ['F', 'G', 'H', 'I', 'J'],
        requiredStars: 15,
        iconPath: 'assets/images/lessons/basic_2.png',
        status: LessonStatus.locked,
      ),
      Lesson(
        id: 'latin_basic_3',
        title: 'Završna slova',
        description: 'Završite osnovna slova',
        type: LessonType.beginner,
        letters: ['K', 'L', 'M', 'N', 'O'],
        requiredStars: 30,
        iconPath: 'assets/images/lessons/basic_3.png',
        status: LessonStatus.locked,
      ),
      Lesson(
        id: 'latin_intermediate_1',
        title: 'Složenija slova',
        description: 'Naučite složenija slova',
        type: LessonType.intermediate,
        letters: ['P', 'Q', 'R', 'S', 'T'],
        requiredStars: 45,
        iconPath: 'assets/images/lessons/intermediate_1.png',
        status: LessonStatus.locked,
      ),
      Lesson(
        id: 'latin_intermediate_2',
        title: 'Preostala slova',
        description: 'Završite alfabet',
        type: LessonType.intermediate,
        letters: ['U', 'V', 'W', 'X', 'Y', 'Z'],
        requiredStars: 60,
        iconPath: 'assets/images/lessons/intermediate_2.png',
        status: LessonStatus.locked,
      ),
      Lesson(
        id: 'latin_advanced_1',
        title: 'Napredno pisanje',
        description: 'Savladajte napredne tehnike',
        type: LessonType.advanced,
        letters: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'],
        requiredStars: 90,
        iconPath: 'assets/images/lessons/advanced_1.png',
        status: LessonStatus.locked,
      ),
    ];
  }

  static List<Lesson> getCyrillicLessons() {
    return [
      Lesson(
        id: 'cyrillic_basic_1',
        title: 'Osnovna ćirilična slova',
        description: 'Naučite prva ćirilična slova',
        type: LessonType.beginner,
        letters: ['А', 'Б', 'В', 'Г', 'Д'],
        requiredStars: 0,
        iconPath: 'assets/images/lessons/cyrillic_basic_1.png',
        status: LessonStatus.unlocked,
      ),
      Lesson(
        id: 'cyrillic_basic_2',
        title: 'Srednja ćirilična slova',
        description: 'Nastavite sa ćiriličnim slovima',
        type: LessonType.beginner,
        letters: ['Е', 'Ё', 'Ж', 'З', 'И'],
        requiredStars: 15,
        iconPath: 'assets/images/lessons/cyrillic_basic_2.png',
        status: LessonStatus.locked,
      ),
      Lesson(
        id: 'cyrillic_intermediate_1',
        title: 'Složenija ćirilična slova',
        description: 'Naučite složenija ćirilična slova',
        type: LessonType.intermediate,
        letters: ['Й', 'К', 'Л', 'М', 'Н', 'О'],
        requiredStars: 45,
        iconPath: 'assets/images/lessons/cyrillic_intermediate_1.png',
        status: LessonStatus.locked,
      ),
    ];
  }

  static List<Lesson> getNumberLessons() {
    return [
      Lesson(
        id: 'numbers_basic_1',
        title: 'Osnovni brojevi',
        description: 'Naučite prve brojeve',
        type: LessonType.beginner,
        letters: ['0', '1', '2', '3', '4'],
        requiredStars: 0,
        iconPath: 'assets/images/lessons/numbers_basic_1.png',
        status: LessonStatus.unlocked,
      ),
      Lesson(
        id: 'numbers_basic_2',
        title: 'Preostali brojevi',
        description: 'Naučite preostale brojeve',
        type: LessonType.beginner,
        letters: ['5', '6', '7', '8', '9'],
        requiredStars: 15,
        iconPath: 'assets/images/lessons/numbers_basic_2.png',
        status: LessonStatus.locked,
      ),
    ];
  }
} 