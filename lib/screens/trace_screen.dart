import 'package:flutter/material.dart';
import '../widgets/trace_writing.dart';
import '../models/letter.dart';
import '../services/audio_service.dart';
import '../utils/constants.dart';

class TraceScreen extends StatefulWidget {
  final String letter;
  final AlphabetType alphabetType;
  final WritingStyle writingStyle;

  const TraceScreen({
    super.key,
    required this.letter,
    required this.alphabetType,
    required this.writingStyle,
  });

  @override
  State<TraceScreen> createState() => _TraceScreenState();
}

class _TraceScreenState extends State<TraceScreen> {
  final AudioService _audioService = AudioService.instance;
  double _currentAccuracy = 0.0;
  int _attempts = 0;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _playInstruction();
  }

  Future<void> _playInstruction() async {
    await _audioService.playInstruction('follow_trace');
    await Future.delayed(const Duration(seconds: 1));
    await _audioService.playLetterAudio(widget.letter);
  }

  void _onProgress(double accuracy) {
    setState(() {
      _currentAccuracy = accuracy;
    });
  }

  void _onComplete() {
    setState(() {
      _isCompleted = true;
      _attempts++;
    });
    
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _currentAccuracy > 0.8 ? Icons.check_circle : Icons.info,
              color: _currentAccuracy > 0.8 ? AppColors.successGreen : AppColors.warningOrange,
            ),
            const SizedBox(width: AppSizes.smallPadding),
            Text(_currentAccuracy > 0.8 ? 'Odlično!' : 'Dobro!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tačnost: ${(_currentAccuracy * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.smallPadding),
            Text(
              _currentAccuracy > 0.8 
                ? 'Savršeno ste pratili liniju!'
                : 'Možete bolje - pokušajte ponovo.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetTrace();
            },
            child: const Text('Ponovo'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Završi'),
          ),
        ],
      ),
    );
  }

  void _resetTrace() {
    setState(() {
      _currentAccuracy = 0.0;
      _isCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prati liniju - ${widget.letter}'),
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.touch_app,
                          color: AppColors.primary,
                          size: AppSizes.iconSize,
                        ),
                        const SizedBox(width: AppSizes.smallPadding),
                        const Expanded(
                          child: Text(
                            'Pratite sivu liniju prstom',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.smallPadding),
                    LinearProgressIndicator(
                      value: _currentAccuracy,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _currentAccuracy > 0.8 ? AppColors.successGreen : AppColors.warningOrange,
                      ),
                    ),
                    const SizedBox(height: AppSizes.smallPadding),
                    Text(
                      'Tačnost: ${(_currentAccuracy * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 14,
                        color: _currentAccuracy > 0.8 ? AppColors.successGreen : AppColors.warningOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppSizes.padding),
            
            // Trace writing widget
            Expanded(
              child: Center(
                child: GestureDetector(
                  onPanStart: (details) {
                    // Trace writing widget će handle-ovati touch events
                  },
                  onPanUpdate: (details) {
                    // Trace writing widget će handle-ovati touch events
                  },
                  onPanEnd: (details) {
                    // Trace writing widget će handle-ovati touch events
                  },
                  child: TraceWriting(
                    letter: widget.letter,
                    alphabetType: widget.alphabetType,
                    writingStyle: widget.writingStyle,
                    onProgress: _onProgress,
                    onComplete: _onComplete,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: AppSizes.padding),
            
            // Kontrole
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: _resetTrace,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Ponovo'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Nazad'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigacija na sledeće slovo
                  },
                  icon: const Icon(Icons.skip_next),
                  label: const Text('Sledeće'),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.padding),
            
            // Statistike
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Pokušaji',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '$_attempts',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Najbolja tačnost',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${(_currentAccuracy * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _currentAccuracy > 0.8 ? AppColors.successGreen : AppColors.warningOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 