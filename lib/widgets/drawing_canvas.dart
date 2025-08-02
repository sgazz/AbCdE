import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../utils/constants.dart';

class DrawingCanvas extends StatefulWidget {
  final String targetLetter;
  final Function(List<Offset>) onDrawingComplete;
  final bool showGrid;
  final bool showTargetLetter;
  final Color strokeColor;
  final double strokeWidth;

  const DrawingCanvas({
    super.key,
    required this.targetLetter,
    required this.onDrawingComplete,
    this.showGrid = true,
    this.showTargetLetter = true,
    this.strokeColor = AppColors.drawingColor,
    this.strokeWidth = 3.0,
  });

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];
  bool _isDrawing = false;

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
          
          // Drawing canvas
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: CustomPaint(
              painter: DrawingPainter(
                strokes: _strokes,
                currentStroke: _currentStroke,
                strokeColor: widget.strokeColor,
                strokeWidth: widget.strokeWidth,
              ),
              size: Size(AppSizes.canvasSize, AppSizes.canvasSize),
            ),
          ),
          
          // Clear button
          Positioned(
            top: 8,
            right: 8,
            child: FloatingActionButton.small(
              heroTag: null, // Disable hero animation on iOS
              onPressed: _clearCanvas,
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              child: const Icon(Icons.clear),
            ),
          ),
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
      child: Text(
        widget.targetLetter,
        style: TextStyle(
          fontSize: AppSizes.letterSize,
          fontWeight: FontWeight.bold,
          color: AppColors.primary.withOpacity(0.1),
        ),
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
    if (_isDrawing) {
      setState(() {
        _currentStroke.add(details.localPosition);
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isDrawing) {
      setState(() {
        _isDrawing = false;
        if (_currentStroke.isNotEmpty) {
          _strokes.add(List.from(_currentStroke));
          _currentStroke = [];
        }
      });
      
      // Pozivamo callback sa svim stroke-ovima
      List<Offset> allStrokes = [];
      for (var stroke in _strokes) {
        allStrokes.addAll(stroke);
      }
      widget.onDrawingComplete(allStrokes);
    }
  }

  void _clearCanvas() {
    setState(() {
      _strokes.clear();
      _currentStroke.clear();
      _isDrawing = false;
    });
  }

  void resetCanvas() {
    _clearCanvas();
  }

  List<List<Offset>> get strokes => _strokes;
}

class DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;
  final Color strokeColor;
  final double strokeWidth;

  DrawingPainter({
    required this.strokes,
    required this.currentStroke,
    required this.strokeColor,
    required this.strokeWidth,
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
    for (var stroke in strokes) {
      if (stroke.length > 1) {
        final path = Path();
        path.moveTo(stroke[0].dx, stroke[0].dy);
        for (int i = 1; i < stroke.length; i++) {
          path.lineTo(stroke[i].dx, stroke[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }

    // Crtanje trenutnog stroke-a
    if (currentStroke.length > 1) {
      final path = Path();
      path.moveTo(currentStroke[0].dx, currentStroke[0].dy);
      for (int i = 1; i < currentStroke.length; i++) {
        path.lineTo(currentStroke[i].dx, currentStroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gridColor
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