import 'package:flutter/material.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/star_rating.dart';
import '../services/ml_service.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../services/haptic_service.dart';
import '../models/letter.dart';
import '../screens/trace_screen.dart';
import '../widgets/multiplayer_game.dart';
import '../widgets/gesture_interactions.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.neutral50,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Column(
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: AppSizes.largeSpacing),
                
                // Instructions card
                _buildInstructionsCard(),
                const SizedBox(height: AppSizes.padding),
                
                // Drawing canvas
                Expanded(
                  child: _buildDrawingSection(),
                ),
                
                const SizedBox(height: AppSizes.padding),
                
                // Controls
                _buildControls(),
                
                const SizedBox(height: AppSizes.padding),
                
                // Results
                if (_stars > 0) _buildResults(),
                
                const SizedBox(height: AppSizes.padding),
                
                // Additional options
                _buildAdditionalOptions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.padding),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.smallPadding),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            ),
            child: const Icon(
              Icons.edit,
              color: Colors.white,
              size: AppSizes.largeIconSize,
            ),
          ),
          const SizedBox(width: AppSizes.padding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Slovo ${widget.letter}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSizes.smallSpacing),
                Text(
                  '${widget.alphabetType.name} - ${widget.writingStyle.name}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.padding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral200.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.smallPadding),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            ),
            child: Icon(
              Icons.lightbulb_outline,
              color: AppColors.secondary,
              size: AppSizes.iconSize,
            ),
          ),
          const SizedBox(width: AppSizes.padding),
          Expanded(
            child: Text(
              'Nacrtajte slovo "${widget.letter}" u polju ispod',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawingSection() {
    return GestureInteractions.pinch(
      onPinch: (scale) {
        // Handle pinch to zoom canvas
        HapticService().light();
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.neutral200.withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
          child: DrawingCanvas(
            targetLetter: widget.letter,
            onDrawingComplete: _onDrawingComplete,
            showGrid: true,
            showTargetLetter: true,
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      children: [
        // Analyze button
        Expanded(
          child: GestureInteractions.longPress(
            onLongPress: () {
              // Quick analyze with haptic feedback
              HapticService().medium();
              _analyzeDrawing();
            },
            child: Container(
              height: AppSizes.largeButtonHeight,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                  onTap: () {
                    HapticService().selection();
                    _isAnalyzing ? null : _analyzeDrawing();
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isAnalyzing)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        else
                          const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: AppSizes.iconSize,
                          ),
                        const SizedBox(width: AppSizes.smallPadding),
                        Text(
                          _isAnalyzing ? 'Analiziram...' : 'Analiziraj',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(width: AppSizes.padding),
        
        // Reset button
        Expanded(
          child: GestureInteractions.doubleTap(
            onDoubleTap: () {
              // Double tap to reset with haptic feedback
              HapticService().warning();
              _resetCanvas();
            },
            child: Container(
              height: AppSizes.largeButtonHeight,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                border: Border.all(color: AppColors.neutral200),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neutral200.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                  onTap: () {
                    HapticService().light();
                    _resetCanvas();
                  },
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh,
                          color: AppColors.primary,
                          size: AppSizes.iconSize,
                        ),
                        SizedBox(width: AppSizes.smallPadding),
                        Text(
                          'Ponovo',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.padding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral200.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
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
              color: AppColors.neutral600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        // First row
        Row(
          children: [
            Expanded(
              child: Container(
                height: AppSizes.buttonHeight,
                decoration: BoxDecoration(
                  gradient: AppColors.secondaryGradient,
                  borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                    onTap: () {
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
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.touch_app,
                            color: Colors.white,
                            size: AppSizes.iconSize,
                          ),
                          SizedBox(width: AppSizes.smallPadding),
                          Text(
                            'Prati liniju',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: AppSizes.padding),
            
            Expanded(
              child: Container(
                height: AppSizes.buttonHeight,
                decoration: BoxDecoration(
                  gradient: AppColors.successGradient,
                  borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.successGreen.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                    onTap: () {
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
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.emoji_events,
                            color: Colors.white,
                            size: AppSizes.iconSize,
                          ),
                          SizedBox(width: AppSizes.smallPadding),
                          Text(
                            'Takmičenje',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppSizes.padding),
        
        // Second row
        Row(
          children: [
            Expanded(
              child: Container(
                height: AppSizes.buttonHeight,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                  border: Border.all(color: AppColors.neutral200),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neutral200.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                    onTap: () {
                      // Navigacija na sledeće slovo
                    },
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.skip_next,
                            color: AppColors.primary,
                            size: AppSizes.iconSize,
                          ),
                          SizedBox(width: AppSizes.smallPadding),
                          Text(
                            'Sledeće',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: AppSizes.padding),
            
            Expanded(
              child: Container(
                height: AppSizes.buttonHeight,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                  border: Border.all(color: AppColors.neutral200),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neutral200.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                    onTap: () {
                      // Navigacija na napredak
                    },
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assessment,
                            color: AppColors.secondary,
                            size: AppSizes.iconSize,
                          ),
                          SizedBox(width: AppSizes.smallPadding),
                          Text(
                            'Napredak',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
} 