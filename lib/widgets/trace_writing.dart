import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/letter.dart';
import '../utils/constants.dart';

class TraceWriting extends StatefulWidget {
  final String letter;
  final AlphabetType alphabetType;
  final WritingStyle writingStyle;
  final Function(double) onProgress;
  final VoidCallback? onComplete;

  const TraceWriting({
    super.key,
    required this.letter,
    required this.alphabetType,
    required this.writingStyle,
    required this.onProgress,
    this.onComplete,
  });

  @override
  State<TraceWriting> createState() => _TraceWritingState();
}

class _TraceWritingState extends State<TraceWriting>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<Offset> _tracePath = [];
  List<Offset> _userPath = [];
  bool _isTracing = false;
  double _accuracy = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _generateTracePath();
    _startTraceAnimation();
  }

  void _generateTracePath() {
    _tracePath = _getLetterPath(widget.letter);
  }

  List<Offset> _getLetterPath(String letter) {
    // Koristimo iste path-ove kao u LetterAnimation
    switch (letter.toUpperCase()) {
      case 'A':
        return _getLetterAPath();
      case 'B':
        return _getLetterBPath();
      case 'C':
        return _getLetterCPath();
      case 'O':
        return _getLetterOPath();
      case 'S':
        return _getLetterSPath();
      default:
        return _getDefaultLetterPath();
    }
  }

  List<Offset> _getLetterAPath() {
    List<Offset> points = [];
    double centerX = 150;
    double centerY = 150;
    double size = 80;
    
    // Leva linija
    for (int i = 0; i <= 20; i++) {
      double t = i / 20.0;
      double x = centerX - size * 0.5;
      double y = centerY + size * 0.5 - t * size;
      points.add(Offset(x, y));
    }
    
    // Desna linija
    for (int i = 0; i <= 20; i++) {
      double t = i / 20.0;
      double x = centerX + size * 0.5;
      double y = centerY + size * 0.5 - t * size;
      points.add(Offset(x, y));
    }
    
    // Horizontalna linija
    for (int i = 0; i <= 15; i++) {
      double t = i / 15.0;
      double x = centerX - size * 0.4 + t * size * 0.8;
      double y = centerY;
      points.add(Offset(x, y));
    }
    
    return points;
  }

  List<Offset> _getLetterBPath() {
    List<Offset> points = [];
    double centerX = 150;
    double centerY = 150;
    double size = 80;
    
    // Vertikalna linija
    for (int i = 0; i <= 20; i++) {
      double t = i / 20.0;
      double x = centerX - size * 0.4;
      double y = centerY - size * 0.5 + t * size;
      points.add(Offset(x, y));
    }
    
    // Gornja krivina
    for (int i = 0; i <= 15; i++) {
      double t = i / 15.0;
      double angle = math.pi * t;
      double x = centerX - size * 0.4 + size * 0.3 * math.cos(angle);
      double y = centerY - size * 0.2 + size * 0.2 * math.sin(angle);
      points.add(Offset(x, y));
    }
    
    // Donja krivina
    for (int i = 0; i <= 15; i++) {
      double t = i / 15.0;
      double angle = math.pi * t;
      double x = centerX - size * 0.4 + size * 0.3 * math.cos(angle);
      double y = centerY + size * 0.2 + size * 0.2 * math.sin(angle);
      points.add(Offset(x, y));
    }
    
    return points;
  }

  List<Offset> _getLetterCPath() {
    List<Offset> points = [];
    double centerX = 150;
    double centerY = 150;
    double size = 80;
    
    // C krivina
    for (int i = 0; i <= 30; i++) {
      double t = i / 30.0;
      double angle = math.pi * 0.5 + math.pi * 1.5 * t;
      double x = centerX + size * 0.3 * math.cos(angle);
      double y = centerY + size * 0.3 * math.sin(angle);
      points.add(Offset(x, y));
    }
    
    return points;
  }

  List<Offset> _getLetterOPath() {
    List<Offset> points = [];
    double centerX = 150;
    double centerY = 150;
    double size = 80;
    
    // O krug
    for (int i = 0; i <= 40; i++) {
      double t = i / 40.0;
      double angle = 2 * math.pi * t;
      double x = centerX + size * 0.3 * math.cos(angle);
      double y = centerY + size * 0.3 * math.sin(angle);
      points.add(Offset(x, y));
    }
    
    return points;
  }

  List<Offset> _getLetterSPath() {
    List<Offset> points = [];
    double centerX = 150;
    double centerY = 150;
    double size = 80;
    
    // S krivina
    for (int i = 0; i <= 40; i++) {
      double t = i / 40.0;
      double angle = 2 * math.pi * t;
      double x = centerX + size * 0.3 * math.cos(angle);
      double y = centerY + size * 0.3 * math.sin(angle) * 0.5;
      points.add(Offset(x, y));
    }
    
    return points;
  }

  List<Offset> _getDefaultLetterPath() {
    List<Offset> points = [];
    double centerX = 150;
    double centerY = 150;
    double size = 60;
    
    // Gornja linija
    for (int i = 0; i <= 10; i++) {
      double t = i / 10.0;
      double x = centerX - size * 0.5 + t * size;
      double y = centerY - size * 0.5;
      points.add(Offset(x, y));
    }
    
    // Desna linija
    for (int i = 0; i <= 10; i++) {
      double t = i / 10.0;
      double x = centerX + size * 0.5;
      double y = centerY - size * 0.5 + t * size;
      points.add(Offset(x, y));
    }
    
    // Donja linija
    for (int i = 0; i <= 10; i++) {
      double t = i / 10.0;
      double x = centerX + size * 0.5 - t * size;
      double y = centerY + size * 0.5;
      points.add(Offset(x, y));
    }
    
    // Leva linija
    for (int i = 0; i <= 10; i++) {
      double t = i / 10.0;
      double x = centerX - size * 0.5;
      double y = centerY + size * 0.5 - t * size;
      points.add(Offset(x, y));
    }
    
    return points;
  }

  void _startTraceAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isTracing = true;
      _userPath = [details.localPosition];
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isTracing) {
      setState(() {
        _userPath.add(details.localPosition);
      });
      _calculateAccuracy();
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isTracing = false;
    });
    _calculateFinalAccuracy();
  }

  void _calculateAccuracy() {
    if (_userPath.isEmpty || _tracePath.isEmpty) return;
    
    double totalDistance = 0.0;
    int samplePoints = math.min(_userPath.length, _tracePath.length);
    
    for (int i = 0; i < samplePoints; i++) {
      double userIndex = (i / samplePoints) * _userPath.length;
      double traceIndex = (i / samplePoints) * _tracePath.length;
      
      Offset userPoint = _userPath[userIndex.floor()];
      Offset tracePoint = _tracePath[traceIndex.floor()];
      
      totalDistance += (userPoint - tracePoint).distance;
    }
    
    double averageDistance = totalDistance / samplePoints;
    double maxDistance = 50.0; // Maksimalna dozvoljena udaljenost
    
    _accuracy = math.max(0.0, 1.0 - (averageDistance / maxDistance));
    widget.onProgress(_accuracy);
  }

  void _calculateFinalAccuracy() {
    _calculateAccuracy();
    if (_accuracy > 0.7) {
      widget.onComplete?.call();
    }
  }

  void _reset() {
    setState(() {
      _userPath.clear();
      _accuracy = 0.0;
    });
    _startTraceAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.gridColor),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Stack(
        children: [
          // Grid pozadina
          CustomPaint(
            painter: GridPainter(),
            size: const Size(300, 300),
          ),
          
          // Trace path (siva linija)
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              int currentIndex = (_animation.value * _tracePath.length).floor();
              currentIndex = currentIndex.clamp(0, _tracePath.length - 1);
              
              return CustomPaint(
                painter: TracePathPainter(
                  points: _tracePath.take(currentIndex + 1).toList(),
                  strokeColor: Colors.grey.withOpacity(0.5),
                  strokeWidth: 3,
                ),
                size: const Size(300, 300),
              );
            },
          ),
          
          // User path (plava linija)
          CustomPaint(
            painter: UserPathPainter(
              points: _userPath,
              strokeColor: AppColors.primary,
              strokeWidth: 4,
            ),
            size: const Size(300, 300),
          ),
          
          // Kontrole
          Positioned(
            bottom: 8,
            right: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.small(
                  heroTag: null, // Disable hero animation on iOS
                  onPressed: _reset,
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _accuracy > 0.7 ? AppColors.successGreen : AppColors.warningOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(_accuracy * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TracePathPainter extends CustomPainter {
  final List<Offset> points;
  final Color strokeColor;
  final double strokeWidth;

  TracePathPainter({
    required this.points,
    required this.strokeColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class UserPathPainter extends CustomPainter {
  final List<Offset> points;
  final Color strokeColor;
  final double strokeWidth;

  UserPathPainter({
    required this.points,
    required this.strokeColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gridColor.withOpacity(0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const gridSize = 50.0;
    
    // Vertikalne linije
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    // Horizontalne linije
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 