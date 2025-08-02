import 'dart:typed_data';
import 'package:flutter/material.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';  // Temporarily disabled

class MLService {
  static MLService? _instance;
  // Interpreter? _interpreter;  // Temporarily disabled
  bool _isInitialized = false;

  static MLService get instance {
    _instance ??= MLService._internal();
    return _instance!;
  }

  MLService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Učitavanje TensorFlow Lite modela - temporarily disabled
      // _interpreter = await Interpreter.fromAsset('assets/models/letter_recognition.tflite');
      _isInitialized = true;
      print('ML Service initialized successfully (basic mode)');
    } catch (e) {
      print('Error initializing ML Service: $e');
      // Fallback na osnovnu logiku ako model nije dostupan
      _isInitialized = true;
    }
  }

  Future<Map<String, double>> recognizeLetter(List<Offset> strokes) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Temporarily use only basic shape analysis
    return _basicShapeAnalysis(strokes);
  }

  List<List<List<double>>> _preprocessStrokes(List<Offset> strokes) {
    // Normalizacija stroke-ova na 28x28 grid
    var grid = List.generate(28, (_) => List.generate(28, (_) => 0.0));
    
    if (strokes.isEmpty) return [grid];

    // Pronalaženje bounding box-a
    double minX = strokes.map((s) => s.dx).reduce((a, b) => a < b ? a : b);
    double maxX = strokes.map((s) => s.dx).reduce((a, b) => a > b ? a : b);
    double minY = strokes.map((s) => s.dy).reduce((a, b) => a < b ? a : b);
    double maxY = strokes.map((s) => s.dy).reduce((a, b) => a > b ? a : b);

    double scaleX = 26.0 / (maxX - minX);
    double scaleY = 26.0 / (maxY - minY);
    double scale = scaleX < scaleY ? scaleX : scaleY;

    // Centriranje i skaliranje
    double centerX = (minX + maxX) / 2;
    double centerY = (minY + maxY) / 2;

    for (var stroke in strokes) {
      int x = ((stroke.dx - centerX) * scale + 14).round();
      int y = ((stroke.dy - centerY) * scale + 14).round();
      
      if (x >= 0 && x < 28 && y >= 0 && y < 28) {
        grid[y][x] = 1.0;
      }
    }

    return [grid];
  }

  Map<String, double> _convertOutputToMap(List<double> output) {
    Map<String, double> predictions = {};
    
    // Latinica (A-Z)
    for (int i = 0; i < 26; i++) {
      predictions[String.fromCharCode(65 + i)] = output[i];
    }
    
    // Brojevi (0-9)
    for (int i = 0; i < 10; i++) {
      predictions[i.toString()] = output[26 + i];
    }
    
    // Ćirilica (А-Я) - osnovnih 26 slova
    String cyrillicLetters = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ';
    for (int i = 0; i < 26; i++) {
      predictions[cyrillicLetters[i]] = output[36 + i];
    }
    
    return predictions;
  }

  Map<String, double> _basicShapeAnalysis(List<Offset> strokes) {
    // Osnovna analiza oblika bez ML modela
    if (strokes.isEmpty) return {};
    
    // Pronalaženje bounding box-a
    double minX = strokes.map((s) => s.dx).reduce((a, b) => a < b ? a : b);
    double maxX = strokes.map((s) => s.dx).reduce((a, b) => a > b ? a : b);
    double minY = strokes.map((s) => s.dy).reduce((a, b) => a < b ? a : b);
    double maxY = strokes.map((s) => s.dy).reduce((a, b) => a > b ? a : b);
    
    double width = maxX - minX;
    double height = maxY - minY;
    double aspectRatio = width / height;
    
    // Osnovna heuristika za prepoznavanje oblika
    Map<String, double> predictions = {};
    
    // Analiza na osnovu aspect ratio-a i pozicije
    if (aspectRatio > 0.8 && aspectRatio < 1.2) {
      // Kvadratni oblici - mogu biti O, D, 0, 8
      predictions['O'] = 0.7;
      predictions['0'] = 0.6;
      predictions['D'] = 0.5;
    } else if (aspectRatio > 1.5) {
      // Široki oblici - mogu biti W, M, 3
      predictions['W'] = 0.6;
      predictions['M'] = 0.5;
      predictions['3'] = 0.4;
    } else if (aspectRatio < 0.5) {
      // Uski oblici - mogu biti I, 1, l
      predictions['I'] = 0.7;
      predictions['1'] = 0.6;
      predictions['l'] = 0.5;
    }
    
    return predictions;
  }

  double calculateAccuracy(String expectedLetter, Map<String, double> predictions) {
    if (predictions.isEmpty) return 0.0;
    
    // Pronalaženje najbolje predviđene slovo
    String predictedLetter = predictions.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    
    // Računanje tačnosti
    double maxConfidence = predictions.values.reduce((a, b) => a > b ? a : b);
    
    if (predictedLetter == expectedLetter) {
      return maxConfidence;
    } else {
      // Ako je predviđeno pogrešno slovo, ali je confidence visok
      // za očekivano slovo, dajemo delimičnu tačnost
      double expectedConfidence = predictions[expectedLetter] ?? 0.0;
      return expectedConfidence * 0.5;
    }
  }

  int calculateStars(double accuracy) {
    if (accuracy >= 0.9) return 5;
    if (accuracy >= 0.8) return 4;
    if (accuracy >= 0.7) return 3;
    if (accuracy >= 0.6) return 2;
    if (accuracy >= 0.5) return 1;
    return 0;
  }

  void dispose() {
    // _interpreter?.close();  // Temporarily disabled
    // _interpreter = null;    // Temporarily disabled
    _isInitialized = false;
  }
} 