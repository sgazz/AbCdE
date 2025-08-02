import 'package:flutter/material.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/star_rating.dart';
import '../services/ml_service.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../models/letter.dart';
import '../screens/trace_screen.dart';
import '../widgets/multiplayer_game.dart';
import '../utils/constants.dart';

class WritingScreen extends StatefulWidget {
  final String letter;
  final AlphabetType alphabetType;
  final WritingStyle writingStyle;

  const WritingScreen({
    super.key,
    required this.letter,
    required this.alphabetType,
    required this.writingStyle,
  });

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen>
    with TickerProviderStateMixin {
  final MLService _mlService = MLService.instance;
  final AudioService _audioService = AudioService.instance;
  final ProgressService _progressService = ProgressService.instance;
  
  List<Offset> _currentStrokes = [];
  bool _isAnalyzing = false;
  int _stars = 0;
  double _accuracy = 0.0;
  String _feedback = '';
  Color _feedbackColor = AppColors.successGreen;
  
  late AnimationController _feedbackController;
  late Animation<double> _feedbackAnimation;

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      duration: AppAnimations.mediumDuration,
      vsync: this,
    );
    _feedbackAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.easeOutBack),
    );
    
    // Puštamo audio uputstvo
    _playInstruction();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _playInstruction() async {
    await _audioService.playInstruction('draw_letter');
    await Future.delayed(const Duration(seconds: 1));
    await _audioService.playLetterAudio(widget.letter);
  }

  void _onDrawingComplete(List<Offset> strokes) {
    setState(() {
      _currentStrokes = strokes;
    });
  }

  Future<void> _analyzeDrawing() async {
    if (_currentStrokes.isEmpty) {
      _showFeedback('Nacrtajte slovo prvo!', AppColors.warningOrange);
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      // ML analiza
      Map<String, double> predictions = await _mlService.recognizeLetter(_currentStrokes);
      
      // Računanje tačnosti
      double accuracy = _mlService.calculateAccuracy(widget.letter, predictions);
      int stars = _mlService.calculateStars(accuracy);
      
      // Generisanje feedback-a
      String feedback = _generateFeedback(stars, accuracy);
      Color feedbackColor = _getFeedbackColor(stars);
      
      setState(() {
        _accuracy = accuracy;
        _stars = stars;
        _feedback = feedback;
        _feedbackColor = feedbackColor;
        _isAnalyzing = false;
      });

      // Puštanje zvuka
      if (stars > 0) {
        await _audioService.playStarSound(stars);
      } else {
        await _audioService.playErrorSound();
      }

      // Prikaz feedback-a
      _showFeedback(_feedback, _feedbackColor);
      
      // Čuvanje napretka
      await _saveProgress();
      
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      _showFeedback('Greška pri analizi. Pokušajte ponovo.', AppColors.error);
    }
  }

  String _generateFeedback(int stars, double accuracy) {
    if (stars >= 4) {
      return AppStrings.excellent;
    } else if (stars >= 3) {
      return AppStrings.good;
    } else if (stars >= 2) {
      return 'Dobro, ali možete bolje!';
    } else if (stars >= 1) {
      return 'Pokušajte ponovo';
    } else {
      return AppStrings.tryAgain;
    }
  }

  Color _getFeedbackColor(int stars) {
    if (stars >= 4) return AppColors.successGreen;
    if (stars >= 2) return AppColors.warningOrange;
    return AppColors.error;
  }

  void _showFeedback(String message, Color color) {
    _feedbackController.reset();
    _feedbackController.forward();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _saveProgress() async {
    if (_stars > 0) {
      LetterProgress progress = LetterProgress(
        character: widget.letter,
        stars: _stars,
        accuracy: _accuracy,
        lastPracticed: DateTime.now(),
        practiceCount: 1,
      );
      
      await _progressService.updateLetterProgress(widget.letter, progress);
    }
  }

  void _resetCanvas() {
    setState(() {
      _currentStrokes.clear();
      _stars = 0;
      _accuracy = 0.0;
      _feedback = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Naučite slovo ${widget.letter}'),
        actions: [
          IconButton(
            onPressed: _playInstruction,
            icon: const Icon(Icons.volume_up),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          children: [
            // Instrukcije
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.padding),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: AppColors.primary,
                      size: AppSizes.iconSize,
                    ),
                    const SizedBox(width: AppSizes.smallPadding),
                    Expanded(
                      child: Text(
                        'Nacrtajte slovo "${widget.letter}" u polju ispod',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppSizes.padding),
            
            // Drawing canvas
            Center(
              child: DrawingCanvas(
                targetLetter: widget.letter,
                onDrawingComplete: _onDrawingComplete,
                showGrid: true,
                showTargetLetter: true,
              ),
            ),
            
            const SizedBox(height: AppSizes.padding),
            
            // Kontrole
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _isAnalyzing ? null : _analyzeDrawing,
                  icon: _isAnalyzing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(_isAnalyzing ? 'Analiziram...' : 'Analiziraj'),
                ),
                OutlinedButton.icon(
                  onPressed: _resetCanvas,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Ponovo'),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.padding),
            
            // Rezultati
            if (_stars > 0) ...[
              AnimatedStarRating(stars: _stars),
              const SizedBox(height: AppSizes.smallPadding),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.padding,
                  vertical: AppSizes.smallPadding,
                ),
                decoration: BoxDecoration(
                  color: _feedbackColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  border: Border.all(color: _feedbackColor.withOpacity(0.3)),
                ),
                child: Text(
                  _feedback,
                  style: TextStyle(
                    color: _feedbackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.smallPadding),
              Text(
                'Tačnost: ${(_accuracy * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
            
            const Spacer(),
            
            // Dodatne opcije
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TraceScreen(
                          letter: widget.letter,
                          alphabetType: widget.alphabetType,
                          writingStyle: widget.writingStyle,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.touch_app),
                  label: const Text('Prati liniju'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiplayerGame(
                          letter: widget.letter,
                          onScoreUpdate: (score) {
                            // Handle score update
                          },
                          onGameComplete: () {
                            // Handle game completion
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.emoji_events),
                  label: const Text('Takmičenje'),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Navigacija na sledeće slovo
                  },
                  icon: const Icon(Icons.skip_next),
                  label: const Text('Sledeće'),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Navigacija na napredak
                  },
                  icon: const Icon(Icons.assessment),
                  label: const Text('Napredak'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 