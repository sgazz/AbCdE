import 'package:flutter/material.dart';
import '../services/advanced_ml_service.dart';
import '../utils/constants.dart';
import '../models/letter.dart';

/// Napredni drawing canvas sa real-time ML feedback
class AdvancedDrawingCanvas extends StatefulWidget {
  final String targetLetter;
  final AlphabetType alphabetType;
  final WritingStyle writingStyle;
  final Function(List<Offset>) onDrawingComplete;
  final Function(RealTimeLetterAnalysis) onRealTimeAnalysis;
  final bool showGrid;
  final bool showTargetLetter;
  final bool showRealTimeFeedback;
  final Color strokeColor;
  final double strokeWidth;

  const AdvancedDrawingCanvas({
    super.key,
    required this.targetLetter,
    required this.alphabetType,
    required this.writingStyle,
    required this.onDrawingComplete,
    required this.onRealTimeAnalysis,
    this.showGrid = true,
    this.showTargetLetter = true,
    this.showRealTimeFeedback = true,
    this.strokeColor = AppColors.drawingColor,
    this.strokeWidth = 3.0,
  });

  @override
  State<AdvancedDrawingCanvas> createState() => _AdvancedDrawingCanvasState();
}

class _AdvancedDrawingCanvasState extends State<AdvancedDrawingCanvas>
    with TickerProviderStateMixin {
  final AdvancedMLService _mlService = AdvancedMLService.instance;
  
  List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];
  bool _isDrawing = false;
  bool _isAnalyzing = false;
  
  // Real-time feedback state
  RealTimeLetterAnalysis? _currentAnalysis;
  StrokeAnalysis? _currentStrokeAnalysis;
  List<FeedbackItem> _activeFeedback = [];
  
  // Animation controllers
  late AnimationController _feedbackController;
  late AnimationController _guidanceController;
  late Animation<double> _feedbackAnimation;
  late Animation<double> _guidanceAnimation;

  @override
  void initState() {
    super.initState();
    
    _feedbackController = AnimationController(
      duration: AppAnimations.mediumDuration,
      vsync: this,
    );
    
    _guidanceController = AnimationController(
      duration: AppAnimations.longDuration,
      vsync: this,
    );
    
    _feedbackAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.easeOutBack),
    );
    
    _guidanceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _guidanceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _guidanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.canvasSize,
      height: AppSizes.canvasSize,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.gridColor, width: 2),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Grid pozadina
          if (widget.showGrid) _buildGrid(),
          
          // Target letter pozadina
          if (widget.showTargetLetter) _buildTargetLetter(),
          
          // AI guidance overlay
          if (widget.showRealTimeFeedback) _buildAIGuidance(),
          
          // Drawing canvas
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: CustomPaint(
              painter: AdvancedDrawingPainter(
                strokes: _strokes,
                currentStroke: _currentStroke,
                strokeColor: widget.strokeColor,
                strokeWidth: widget.strokeWidth,
                analysis: _currentAnalysis,
              ),
              size: Size(AppSizes.canvasSize, AppSizes.canvasSize),
            ),
          ),
          
          // Real-time feedback overlay
          if (widget.showRealTimeFeedback) _buildRealTimeFeedback(),
          
          // Control buttons
          _buildControlButtons(),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return CustomPaint(
      painter: GridPainter(),
      size: Size(AppSizes.canvasSize, AppSizes.canvasSize),
    );
  }

  Widget _buildTargetLetter() {
    return Center(
      child: AnimatedOpacity(
        opacity: _currentStroke.isEmpty ? 0.3 : 0.1,
        duration: AppAnimations.shortDuration,
        child: Text(
          widget.targetLetter,
          style: TextStyle(
            fontSize: 120,
            fontWeight: FontWeight.bold,
            color: AppColors.neutral300,
            fontFamily: widget.writingStyle == WritingStyle.cursive 
                ? 'Cursive' 
                : 'Print',
          ),
        ),
      ),
    );
  }

  Widget _buildAIGuidance() {
    if (_currentAnalysis == null) return const SizedBox.shrink();
    
    return AnimatedBuilder(
      animation: _guidanceAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _guidanceAnimation.value * 0.1,
          child: CustomPaint(
            painter: AIGuidancePainter(
              analysis: _currentAnalysis!,
              targetLetter: widget.targetLetter,
            ),
            size: Size(AppSizes.canvasSize, AppSizes.canvasSize),
          ),
        );
      },
    );
  }

  Widget _buildRealTimeFeedback() {
    if (_activeFeedback.isEmpty) return const SizedBox.shrink();
    
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: AnimatedBuilder(
        animation: _feedbackAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _feedbackAnimation.value,
            child: _buildFeedbackCard(),
          );
        },
      ),
    );
  }

  Widget _buildFeedbackCard() {
    // Sortiraj feedback po prioritetu
    _activeFeedback.sort((a, b) => a.priority.compareTo(b.priority));
    
    return Card(
      elevation: 8,
      color: _getFeedbackColor(_activeFeedback.first.type),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  _getFeedbackIcon(_activeFeedback.first.type),
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _activeFeedback.first.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            if (_currentAnalysis != null) ...[
              const SizedBox(height: 8),
              _buildProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: _currentAnalysis!.accuracy,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(_currentAnalysis!.accuracy * 100).toInt()}%',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildControlButtons() {
    return Positioned(
      top: 8,
      right: 8,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Clear button
          FloatingActionButton.small(
            heroTag: 'clear',
            onPressed: _clearCanvas,
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            child: const Icon(Icons.clear),
          ),
          const SizedBox(width: 8),
          // Analyze button
          FloatingActionButton.small(
            heroTag: 'analyze',
            onPressed: _isAnalyzing ? null : _analyzeDrawing,
            backgroundColor: _isAnalyzing 
                ? AppColors.neutral300 
                : AppColors.primary,
            foregroundColor: Colors.white,
            child: _isAnalyzing 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.analytics),
          ),
        ],
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDrawing = true;
      _currentStroke = [details.localPosition];
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDrawing) return;
    
    setState(() {
      _currentStroke.add(details.localPosition);
    });
    
    // Real-time analiza stroke-a
    _analyzeStrokeInRealTime();
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_isDrawing) return;
    
    setState(() {
      _isDrawing = false;
      _strokes.add(List.from(_currentStroke));
      _currentStroke = [];
    });
    
    // Analiza završenog stroke-a
    _analyzeCompletedStroke();
    
    // Poziv callback-a
    List<Offset> allStrokes = _strokes.expand((stroke) => stroke).toList();
    widget.onDrawingComplete(allStrokes);
  }

  Future<void> _analyzeStrokeInRealTime() async {
    if (_currentStroke.length < 3) return;
    
    try {
      // Analiza trenutnog stroke-a
      StrokeAnalysis strokeAnalysis = await _mlService.analyzeStrokeInRealTime(_currentStroke);
      
      setState(() {
        _currentStrokeAnalysis = strokeAnalysis;
      });
      
      // Ako je stroke završen, analiziraj ceo drawing
      if (strokeAnalysis.isComplete) {
        await _analyzeDrawingInRealTime();
      }
    } catch (e) {
      print('Error analyzing stroke in real-time: $e');
    }
  }

  Future<void> _analyzeCompletedStroke() async {
    try {
      // Analiza završenog stroke-a
      StrokeAnalysis strokeAnalysis = await _mlService.analyzeStrokeInRealTime(_currentStroke);
      
      // Dodaj feedback ako je potrebno
      if (strokeAnalysis.quality == StrokeQuality.poor) {
        _showFeedback(strokeAnalysis.suggestions.first, FeedbackType.warning);
      }
    } catch (e) {
      print('Error analyzing completed stroke: $e');
    }
  }

  Future<void> _analyzeDrawingInRealTime() async {
    if (_strokes.isEmpty) return;
    
    try {
      List<Offset> allStrokes = _strokes.expand((stroke) => stroke).toList();
      
      RealTimeLetterAnalysis analysis = await _mlService.analyzeLetterInRealTime(
        allStrokes,
        widget.targetLetter,
        widget.alphabetType,
      );
      
      setState(() {
        _currentAnalysis = analysis;
        _activeFeedback = analysis.feedback;
      });
      
      // Poziv callback-a
      widget.onRealTimeAnalysis(analysis);
      
      // Animiraj feedback
      _feedbackController.forward().then((_) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            _feedbackController.reverse();
          }
        });
      });
      
    } catch (e) {
      print('Error analyzing drawing in real-time: $e');
    }
  }

  Future<void> _analyzeDrawing() async {
    if (_strokes.isEmpty) {
      _showFeedback('Nacrtajte slovo prvo!', FeedbackType.warning);
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      List<Offset> allStrokes = _strokes.expand((stroke) => stroke).toList();
      
      RealTimeLetterAnalysis analysis = await _mlService.analyzeLetterInRealTime(
        allStrokes,
        widget.targetLetter,
        widget.alphabetType,
      );
      
      setState(() {
        _currentAnalysis = analysis;
        _activeFeedback = analysis.feedback;
        _isAnalyzing = false;
      });
      
      // Poziv callback-a
      widget.onRealTimeAnalysis(analysis);
      
      // Animiraj feedback
      _feedbackController.forward();
      
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      _showFeedback('Greška pri analizi: $e', FeedbackType.error);
    }
  }

  void _clearCanvas() {
    setState(() {
      _strokes.clear();
      _currentStroke.clear();
      _currentAnalysis = null;
      _currentStrokeAnalysis = null;
      _activeFeedback.clear();
    });
    
    _feedbackController.reset();
    _guidanceController.reset();
  }

  void _showFeedback(String message, FeedbackType type) {
    setState(() {
      _activeFeedback = [
        FeedbackItem(
          type: type,
          message: message,
          priority: 0,
        ),
      ];
    });
    
    _feedbackController.forward().then((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _feedbackController.reverse();
        }
      });
    });
  }

  Color _getFeedbackColor(FeedbackType type) {
    switch (type) {
      case FeedbackType.success:
        return AppColors.successGreen;
      case FeedbackType.warning:
        return AppColors.warningOrange;
      case FeedbackType.error:
        return AppColors.error;
      case FeedbackType.info:
        return AppColors.primary;
    }
  }

  IconData _getFeedbackIcon(FeedbackType type) {
    switch (type) {
      case FeedbackType.success:
        return Icons.check_circle;
      case FeedbackType.warning:
        return Icons.warning;
      case FeedbackType.error:
        return Icons.error;
      case FeedbackType.info:
        return Icons.info;
    }
  }
}

/// Napredni painter za drawing canvas
class AdvancedDrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;
  final Color strokeColor;
  final double strokeWidth;
  final RealTimeLetterAnalysis? analysis;

  AdvancedDrawingPainter({
    required this.strokes,
    required this.currentStroke,
    required this.strokeColor,
    required this.strokeWidth,
    this.analysis,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Crtanje završenih stroke-ova
    for (final stroke in strokes) {
      if (stroke.length < 2) continue;
      
      final path = Path();
      path.moveTo(stroke.first.dx, stroke.first.dy);
      
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      
      canvas.drawPath(path, paint);
    }

    // Crtanje trenutnog stroke-a
    if (currentStroke.length >= 2) {
      final currentPaint = Paint()
        ..color = analysis != null && analysis!.accuracy > 0.8 
            ? AppColors.successGreen 
            : strokeColor
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(currentStroke.first.dx, currentStroke.first.dy);
      
      for (int i = 1; i < currentStroke.length; i++) {
        path.lineTo(currentStroke[i].dx, currentStroke[i].dy);
      }
      
      canvas.drawPath(path, currentPaint);
    }
  }

  @override
  bool shouldRepaint(AdvancedDrawingPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
           oldDelegate.currentStroke != currentStroke ||
           oldDelegate.analysis != analysis;
  }
}

/// Painter za AI guidance overlay
class AIGuidancePainter extends CustomPainter {
  final RealTimeLetterAnalysis analysis;
  final String targetLetter;

  AIGuidancePainter({
    required this.analysis,
    required this.targetLetter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Implementacija AI guidance vizuelizacije
    // Ovdje će biti crtanje sugestija za poboljšanje
  }

  @override
  bool shouldRepaint(AIGuidancePainter oldDelegate) {
    return oldDelegate.analysis != analysis ||
           oldDelegate.targetLetter != targetLetter;
  }
}

/// Painter za grid
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gridColor.withOpacity(0.3)
      ..strokeWidth = 1;

    // Horizontalne linije
    for (int i = 0; i <= 4; i++) {
      double y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Vertikalne linije
    for (int i = 0; i <= 4; i++) {
      double x = size.width * i / 4;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
} 