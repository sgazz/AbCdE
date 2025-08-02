import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/letter.dart';
import '../screens/writing_screen.dart';
import '../utils/constants.dart';

class LessonsProgressScreen extends StatefulWidget {
  final AlphabetType alphabetType;
  final WritingStyle writingStyle;

  const LessonsProgressScreen({
    super.key,
    required this.alphabetType,
    required this.writingStyle,
  });

  @override
  State<LessonsProgressScreen> createState() => _LessonsProgressScreenState();
}

class _LessonsProgressScreenState extends State<LessonsProgressScreen> {
  List<Lesson> _lessons = [];
  int _totalStars = 0;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  void _loadLessons() {
    switch (widget.alphabetType) {
      case AlphabetType.latin:
        _lessons = LessonData.getLatinLessons();
        break;
      case AlphabetType.cyrillic:
        _lessons = LessonData.getCyrillicLessons();
        break;
      case AlphabetType.numbers:
        _lessons = LessonData.getNumberLessons();
        break;
    }
    
    // Simuliramo total stars za demo
    _totalStars = 25;
    _updateLessonStatus();
  }

  void _updateLessonStatus() {
    for (int i = 0; i < _lessons.length; i++) {
      if (i == 0) {
        _lessons[i] = _lessons[i].copyWith(status: LessonStatus.unlocked);
      } else if (_totalStars >= _lessons[i].requiredStars) {
        _lessons[i] = _lessons[i].copyWith(status: LessonStatus.unlocked);
      } else {
        _lessons[i] = _lessons[i].copyWith(status: LessonStatus.locked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lekcije - ${_getAlphabetName()}'),
        actions: [
          IconButton(
            onPressed: () {
              // Refresh lessons
              setState(() {
                _loadLessons();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress header
          _buildProgressHeader(),
          
          // Lessons list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSizes.padding),
              itemCount: _lessons.length,
              itemBuilder: (context, index) {
                return _buildLessonCard(_lessons[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryVariant,
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ukupno zvezdica',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '$_totalStars',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Otključane lekcije',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${_lessons.where((l) => l.status != LessonStatus.locked).length}/${_lessons.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSizes.padding),
          LinearProgressIndicator(
            value: _lessons.where((l) => l.status != LessonStatus.locked).length / _lessons.length,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(Lesson lesson) {
    bool isLocked = lesson.status == LessonStatus.locked;
    bool isCompleted = lesson.status == LessonStatus.completed;
    
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.padding),
      child: InkWell(
        onTap: isLocked ? null : () => _openLesson(lesson),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            color: isCompleted 
                ? AppColors.successGreen.withOpacity(0.1)
                : isLocked 
                    ? Colors.grey.withOpacity(0.1)
                    : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Row(
              children: [
                // Lesson icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getLessonTypeColor(lesson.type),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    _getLessonTypeIcon(lesson.type),
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                
                const SizedBox(width: AppSizes.padding),
                
                // Lesson info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lesson.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isLocked ? Colors.grey : null,
                              ),
                            ),
                          ),
                          if (isCompleted)
                            Icon(
                              Icons.check_circle,
                              color: AppColors.successGreen,
                              size: 24,
                            ),
                          if (isLocked)
                            Icon(
                              Icons.lock,
                              color: Colors.grey,
                              size: 24,
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.smallPadding),
                      Text(
                        lesson.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isLocked ? Colors.grey : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: AppSizes.smallPadding),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: AppColors.starColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${lesson.requiredStars} zvezdica potrebno',
                            style: TextStyle(
                              fontSize: 12,
                              color: isLocked ? Colors.grey : Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${lesson.letters.length} slova',
                            style: TextStyle(
                              fontSize: 12,
                              color: isLocked ? Colors.grey : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getLessonTypeColor(LessonType type) {
    switch (type) {
      case LessonType.beginner:
        return AppColors.successGreen;
      case LessonType.intermediate:
        return AppColors.warningOrange;
      case LessonType.advanced:
        return AppColors.primary;
    }
  }

  IconData _getLessonTypeIcon(LessonType type) {
    switch (type) {
      case LessonType.beginner:
        return Icons.school;
      case LessonType.intermediate:
        return Icons.trending_up;
      case LessonType.advanced:
        return Icons.emoji_events;
    }
  }

  String _getAlphabetName() {
    switch (widget.alphabetType) {
      case AlphabetType.latin:
        return AppStrings.latinAlphabet;
      case AlphabetType.cyrillic:
        return AppStrings.cyrillicAlphabet;
      case AlphabetType.numbers:
        return AppStrings.numbers;
    }
  }

  void _openLesson(Lesson lesson) {
    // Navigacija na writing screen sa svim slovima iz lekcije
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WritingScreen(
          letter: lesson.letters.first,
          alphabetType: widget.alphabetType,
          writingStyle: widget.writingStyle,
        ),
      ),
    );
  }
} 