import 'dart:math';
import 'package:flutter/material.dart';
import '../models/letter.dart';

/// Napredni ML servis sa real-time feedback funkcionalnostima
class AdvancedMLService {
  static AdvancedMLService? _instance;
  bool _isInitialized = false;
  
  // Real-time analysis cache
  final Map<String, List<StrokeAnalysis>> _strokeCache = {};
  final Map<String, LetterCharacteristics> _characteristicsCache = {};

  static AdvancedMLService get instance {
    _instance ??= AdvancedMLService._internal();
    return _instance!;
  }

  AdvancedMLService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Inicijalizacija naprednih ML funkcionalnosti
      await _initializeRealTimeAnalysis();
      _isInitialized = true;
      print('Advanced ML Service initialized successfully');
    } catch (e) {
      print('Error initializing Advanced ML Service: $e');
      _isInitialized = true; // Fallback na osnovnu logiku
    }
  }

  Future<void> _initializeRealTimeAnalysis() async {
    // Inicijalizacija real-time analize
    // Ovdje će biti učitavanje naprednih ML modela
  }

  /// Real-time analiza pojedinačnih poteza
  Future<StrokeAnalysis> analyzeStrokeInRealTime(List<Offset> currentStroke) async {
    if (!_isInitialized) await initialize();

    if (currentStroke.isEmpty) {
      return StrokeAnalysis(
        quality: StrokeQuality.poor,
        confidence: 0.0,
        suggestions: ['Nacrtajte slovo'],
        isComplete: false,
      );
    }

    // Analiza kvaliteta poteza
    double smoothness = _calculateSmoothness(currentStroke);
    double consistency = _calculateConsistency(currentStroke);
    double direction = _calculateDirectionAccuracy(currentStroke);
    
    // Računanje ukupnog kvaliteta
    double overallQuality = (smoothness + consistency + direction) / 3.0;
    
    // Generisanje sugestija
    List<String> suggestions = _generateStrokeSuggestions(smoothness, consistency, direction);
    
    return StrokeAnalysis(
      quality: _getStrokeQuality(overallQuality),
      confidence: overallQuality,
      suggestions: suggestions,
      isComplete: currentStroke.length > 10,
    );
  }

  /// Analiza karakteristika slova
  Future<LetterCharacteristics> analyzeLetterCharacteristics(List<Offset> strokes) async {
    if (!_isInitialized) await initialize();

    if (strokes.isEmpty) {
      return LetterCharacteristics(
        proportion: 0.0,
        symmetry: 0.0,
        balance: 0.0,
        flow: 0.0,
        overallScore: 0.0,
      );
    }

    // Analiza proporcija
    double proportion = _analyzeProportion(strokes);
    
    // Analiza simetrije
    double symmetry = _analyzeSymmetry(strokes);
    
    // Analiza balansa
    double balance = _analyzeBalance(strokes);
    
    // Analiza toka pisanja
    double flow = _analyzeFlow(strokes);
    
    // Ukupan skor
    double overallScore = (proportion + symmetry + balance + flow) / 4.0;

    return LetterCharacteristics(
      proportion: proportion,
      symmetry: symmetry,
      balance: balance,
      flow: flow,
      overallScore: overallScore,
    );
  }

  /// Napredna analiza slova sa real-time feedback
  Future<RealTimeLetterAnalysis> analyzeLetterInRealTime(
    List<Offset> strokes,
    String targetLetter,
    AlphabetType alphabetType,
  ) async {
    if (!_isInitialized) await initialize();

    // Analiza karakteristika
    LetterCharacteristics characteristics = await analyzeLetterCharacteristics(strokes);
    
    // Analiza tačnosti
    double accuracy = _calculateAccuracy(strokes, targetLetter, alphabetType);
    
    // Generisanje real-time feedback-a
    List<FeedbackItem> feedback = _generateRealTimeFeedback(
      strokes,
      characteristics,
      accuracy,
      targetLetter,
    );

    // Predviđanje završetka
    bool isComplete = _predictCompletion(strokes, targetLetter);
    
    // Računanje zvezdica
    int stars = _calculateStars(accuracy, characteristics.overallScore);

    return RealTimeLetterAnalysis(
      accuracy: accuracy,
      characteristics: characteristics,
      feedback: feedback,
      stars: stars,
      isComplete: isComplete,
      confidence: accuracy * characteristics.overallScore,
    );
  }

  /// Personalizovani model učenja
  Future<void> trainPersonalModel(String userId, List<TrainingData> data) async {
    if (!_isInitialized) await initialize();

    // Implementacija personalizovanog modela
    // Ovdje će biti logika za učenje na osnovu korisnika
  }

  /// Multi-alphabet recognition
  Future<Map<String, double>> recognizeMultiAlphabet(List<Offset> strokes) async {
    if (!_isInitialized) await initialize();

    Map<String, double> predictions = {};
    
    // Latinica (A-Z)
    for (int i = 0; i < 26; i++) {
      String letter = String.fromCharCode(65 + i);
      predictions[letter] = _calculateLetterProbability(strokes, letter, AlphabetType.latin);
    }
    
    // Brojevi (0-9)
    for (int i = 0; i < 10; i++) {
      predictions[i.toString()] = _calculateLetterProbability(strokes, i.toString(), AlphabetType.numbers);
    }
    
    // Ćirilica (А-Я) - osnovnih 26 slova
    String cyrillicLetters = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ';
    for (int i = 0; i < 26; i++) {
      predictions[cyrillicLetters[i]] = _calculateLetterProbability(strokes, cyrillicLetters[i], AlphabetType.cyrillic);
    }
    
    return predictions;
  }

  // Pomoćne metode za analizu

  double _calculateSmoothness(List<Offset> stroke) {
    if (stroke.length < 2) return 0.0;
    
    double totalDistance = 0.0;
    double totalAngle = 0.0;
    
    for (int i = 1; i < stroke.length; i++) {
      Offset prev = stroke[i - 1];
      Offset curr = stroke[i];
      
      // Računanje distance
      double distance = (curr - prev).distance;
      totalDistance += distance;
      
      // Računanje angle (ako ima dovoljno tačaka)
      if (i > 1) {
        Offset prev2 = stroke[i - 2];
        double angle = _calculateAngle(prev2, prev, curr);
        totalAngle += angle.abs();
      }
    }
    
    // Smoothness je obrnuto proporcionalan sa angle varijacijama
    double avgDistance = totalDistance / (stroke.length - 1);
    double avgAngle = totalAngle / (stroke.length - 2);
    
    return (avgDistance / (1 + avgAngle)).clamp(0.0, 1.0);
  }

  double _calculateConsistency(List<Offset> stroke) {
    if (stroke.length < 3) return 0.0;
    
    List<double> distances = [];
    for (int i = 1; i < stroke.length; i++) {
      distances.add((stroke[i] - stroke[i - 1]).distance);
    }
    
    // Računanje standardne devijacije
    double mean = distances.reduce((a, b) => a + b) / distances.length;
    double variance = distances.map((d) => (d - mean) * (d - mean)).reduce((a, b) => a + b) / distances.length;
    double stdDev = sqrt(variance);
    
    // Consistency je obrnuto proporcionalan sa standardnom devijacijom
    return (1.0 / (1.0 + stdDev)).clamp(0.0, 1.0);
  }

  double _calculateDirectionAccuracy(List<Offset> stroke) {
    if (stroke.length < 2) return 0.0;
    
    // Analiza direction-a stroke-a
    // Ova metoda će biti implementirana na osnovu target slova
    return 0.8; // Placeholder
  }

  double _analyzeProportion(List<Offset> strokes) {
    if (strokes.isEmpty) return 0.0;
    
    // Pronalaženje bounding box-a
    double minX = strokes.map((s) => s.dx).reduce((a, b) => a < b ? a : b);
    double maxX = strokes.map((s) => s.dx).reduce((a, b) => a > b ? a : b);
    double minY = strokes.map((s) => s.dy).reduce((a, b) => a < b ? a : b);
    double maxY = strokes.map((s) => s.dy).reduce((a, b) => a > b ? a : b);
    
    double width = maxX - minX;
    double height = maxY - minY;
    
    if (width == 0 || height == 0) return 0.0;
    
    // Idealna proporcija je 1:1 za većinu slova
    double ratio = width / height;
    double idealRatio = 1.0;
    
    return (1.0 - (ratio - idealRatio).abs()).clamp(0.0, 1.0);
  }

  double _analyzeSymmetry(List<Offset> strokes) {
    if (strokes.isEmpty) return 0.0;
    
    // Centar stroke-a
    double centerX = strokes.map((s) => s.dx).reduce((a, b) => a + b) / strokes.length;
    double centerY = strokes.map((s) => s.dy).reduce((a, b) => a + b) / strokes.length;
    
    // Analiza simetrije oko centra
    double symmetryScore = 0.0;
    int comparisons = 0;
    
    for (int i = 0; i < strokes.length / 2; i++) {
      int mirrorIndex = strokes.length - 1 - i;
      if (mirrorIndex > i) {
        Offset point1 = strokes[i];
        Offset point2 = strokes[mirrorIndex];
        
        // Računanje simetrije
        double expectedX = 2 * centerX - point1.dx;
        double expectedY = 2 * centerY - point1.dy;
        
        double distance = sqrt(pow(point2.dx - expectedX, 2) + pow(point2.dy - expectedY, 2));
        symmetryScore += 1.0 / (1.0 + distance);
        comparisons++;
      }
    }
    
    return comparisons > 0 ? symmetryScore / comparisons : 0.0;
  }

  double _analyzeBalance(List<Offset> strokes) {
    if (strokes.isEmpty) return 0.0;
    
    // Analiza balansa stroke-a
    // Ova metoda će biti implementirana na osnovu target slova
    return 0.8; // Placeholder
  }

  double _analyzeFlow(List<Offset> strokes) {
    if (strokes.length < 2) return 0.0;
    
    // Analiza toka pisanja
    double totalFlow = 0.0;
    
    for (int i = 1; i < strokes.length; i++) {
      Offset prev = strokes[i - 1];
      Offset curr = strokes[i];
      
      // Računanje flow-a na osnovu direction-a
      double flow = _calculateFlowBetweenPoints(prev, curr);
      totalFlow += flow;
    }
    
    return (totalFlow / (strokes.length - 1)).clamp(0.0, 1.0);
  }

  double _calculateAccuracy(List<Offset> strokes, String targetLetter, AlphabetType alphabetType) {
    // Implementacija računanja tačnosti
    // Ova metoda će biti implementirana na osnovu ML modela
    return 0.85; // Placeholder
  }

  List<String> _generateStrokeSuggestions(double smoothness, double consistency, double direction) {
    List<String> suggestions = [];
    
    if (smoothness < 0.6) {
      suggestions.add('Pokušajte da pišete glatkije');
    }
    
    if (consistency < 0.6) {
      suggestions.add('Održavajte konzistentnu brzinu');
    }
    
    if (direction < 0.6) {
      suggestions.add('Pratite pravac slova');
    }
    
    if (suggestions.isEmpty) {
      suggestions.add('Odlično! Nastavite tako');
    }
    
    return suggestions;
  }

  List<FeedbackItem> _generateRealTimeFeedback(
    List<Offset> strokes,
    LetterCharacteristics characteristics,
    double accuracy,
    String targetLetter,
  ) {
    List<FeedbackItem> feedback = [];
    
    // Feedback na osnovu karakteristika
    if (characteristics.proportion < 0.7) {
      feedback.add(FeedbackItem(
        type: FeedbackType.warning,
        message: 'Popravite proporcije slova',
        priority: 1,
      ));
    }
    
    if (characteristics.symmetry < 0.7) {
      feedback.add(FeedbackItem(
        type: FeedbackType.warning,
        message: 'Slovo treba biti simetričnije',
        priority: 2,
      ));
    }
    
    if (characteristics.flow < 0.7) {
      feedback.add(FeedbackItem(
        type: FeedbackType.warning,
        message: 'Poboljšajte tok pisanja',
        priority: 3,
      ));
    }
    
    // Pozitivan feedback
    if (accuracy > 0.8 && characteristics.overallScore > 0.8) {
      feedback.add(FeedbackItem(
        type: FeedbackType.success,
        message: 'Odlično pisanje!',
        priority: 0,
      ));
    }
    
    return feedback;
  }

  bool _predictCompletion(List<Offset> strokes, String targetLetter) {
    // Predviđanje da li je slovo završeno
    // Ova metoda će biti implementirana na osnovu ML modela
    return strokes.length > 20; // Placeholder
  }

  int _calculateStars(double accuracy, double characteristicsScore) {
    double overallScore = (accuracy + characteristicsScore) / 2.0;
    
    if (overallScore >= 0.9) return 5;
    if (overallScore >= 0.8) return 4;
    if (overallScore >= 0.7) return 3;
    if (overallScore >= 0.6) return 2;
    return 1;
  }

  double _calculateLetterProbability(List<Offset> strokes, String letter, AlphabetType alphabetType) {
    // Implementacija računanja verovatnoće za slovo
    // Ova metoda će biti implementirana na osnovu ML modela
    return 0.1; // Placeholder
  }

  StrokeQuality _getStrokeQuality(double quality) {
    if (quality >= 0.8) return StrokeQuality.excellent;
    if (quality >= 0.6) return StrokeQuality.good;
    if (quality >= 0.4) return StrokeQuality.fair;
    return StrokeQuality.poor;
  }

  double _calculateAngle(Offset p1, Offset p2, Offset p3) {
    double angle1 = atan2(p2.dy - p1.dy, p2.dx - p1.dx);
    double angle2 = atan2(p3.dy - p2.dy, p3.dx - p2.dx);
    return angle2 - angle1;
  }

  double _calculateFlowBetweenPoints(Offset p1, Offset p2) {
    // Računanje flow-a između dve tačke
    double distance = (p2 - p1).distance;
    return distance > 0 ? 1.0 / (1.0 + distance) : 0.0;
  }
}

// Modeli za real-time analizu

class StrokeAnalysis {
  final StrokeQuality quality;
  final double confidence;
  final List<String> suggestions;
  final bool isComplete;

  StrokeAnalysis({
    required this.quality,
    required this.confidence,
    required this.suggestions,
    required this.isComplete,
  });
}

enum StrokeQuality {
  excellent,
  good,
  fair,
  poor,
}

class LetterCharacteristics {
  final double proportion;
  final double symmetry;
  final double balance;
  final double flow;
  final double overallScore;

  LetterCharacteristics({
    required this.proportion,
    required this.symmetry,
    required this.balance,
    required this.flow,
    required this.overallScore,
  });
}

class RealTimeLetterAnalysis {
  final double accuracy;
  final LetterCharacteristics characteristics;
  final List<FeedbackItem> feedback;
  final int stars;
  final bool isComplete;
  final double confidence;

  RealTimeLetterAnalysis({
    required this.accuracy,
    required this.characteristics,
    required this.feedback,
    required this.stars,
    required this.isComplete,
    required this.confidence,
  });
}

class FeedbackItem {
  final FeedbackType type;
  final String message;
  final int priority;

  FeedbackItem({
    required this.type,
    required this.message,
    required this.priority,
  });
}

enum FeedbackType {
  success,
  warning,
  error,
  info,
}

class TrainingData {
  final String userId;
  final List<Offset> strokes;
  final String targetLetter;
  final double accuracy;
  final DateTime timestamp;

  TrainingData({
    required this.userId,
    required this.strokes,
    required this.targetLetter,
    required this.accuracy,
    required this.timestamp,
  });
} 