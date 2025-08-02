import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import '../utils/constants.dart';

class MultiplayerGame extends StatefulWidget {
  final String letter;
  final Function(int) onScoreUpdate;
  final VoidCallback? onGameComplete;

  const MultiplayerGame({
    super.key,
    required this.letter,
    required this.onScoreUpdate,
    this.onGameComplete,
  });

  @override
  State<MultiplayerGame> createState() => _MultiplayerGameState();
}

class _MultiplayerGameState extends State<MultiplayerGame>
    with TickerProviderStateMixin {
  late AnimationController _timerController;
  late AnimationController _countdownController;
  late Timer _gameTimer;
  
  int _timeLeft = 60; // 60 sekundi
  int _playerScore = 0;
  int _opponentScore = 0;
  bool _isGameActive = false;
  bool _isCountdown = true;
  int _countdown = 3;
  
  List<Map<String, dynamic>> _gameHistory = [];

  @override
  void initState() {
    super.initState();
    
    _timerController = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    );
    
    _countdownController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _startCountdown();
  }

  void _startCountdown() {
    _countdownController.forward();
    
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _countdown--;
        });
        
        if (_countdown <= 0) {
          timer.cancel();
          _startGame();
        }
      }
    });
  }

  void _startGame() {
    setState(() {
      _isCountdown = false;
      _isGameActive = true;
    });
    
    _timerController.forward();
    
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _timeLeft--;
        });
        
        if (_timeLeft <= 0) {
          timer.cancel();
          _endGame();
        }
      }
    });
    
    // Simuliramo protivnika
    _simulateOpponent();
  }

  void _simulateOpponent() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!_isGameActive) {
        timer.cancel();
        return;
      }
      
      setState(() {
        _opponentScore += math.Random().nextInt(10) + 5;
      });
    });
  }

  void _endGame() {
    setState(() {
      _isGameActive = false;
    });
    
    _timerController.stop();
    widget.onGameComplete?.call();
    
    _showGameResults();
  }

  void _showGameResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _playerScore > _opponentScore ? Icons.emoji_events : Icons.sports_esports,
              color: _playerScore > _opponentScore ? AppColors.starColor : Colors.grey,
            ),
            const SizedBox(width: AppSizes.smallPadding),
            Text(_playerScore > _opponentScore ? 'Pobedili ste!' : 'Izgubili ste'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text(
                      'Vi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$_playerScore',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Text(
                  'VS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    const Text(
                      'Protivnik',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$_opponentScore',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSizes.padding),
            Text(
              'Slovo: ${widget.letter}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Završi'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
            },
            child: const Text('Ponovo'),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _timeLeft = 60;
      _playerScore = 0;
      _opponentScore = 0;
      _isGameActive = false;
      _isCountdown = true;
      _countdown = 3;
      _gameHistory.clear();
    });
    
    _startCountdown();
  }

  void _addPlayerScore(int points) {
    if (!_isGameActive) return;
    
    setState(() {
      _playerScore += points;
    });
    
    widget.onScoreUpdate(_playerScore);
    
    _gameHistory.add({
      'type': 'player',
      'score': points,
      'timestamp': DateTime.now(),
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    _countdownController.dispose();
    _gameTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiplayer takmičenje'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Game header
          Container(
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
                // Countdown
                if (_isCountdown)
                  AnimatedBuilder(
                    animation: _countdownController,
                    builder: (context, child) {
                      return Text(
                        '$_countdown',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                
                // Game info
                if (!_isCountdown) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Vi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '$_playerScore',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${_timeLeft}s',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Preostalo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Protivnik',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '$_opponentScore',
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
                  const SizedBox(height: AppSizes.smallPadding),
                  LinearProgressIndicator(
                    value: _timeLeft / 60,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ],
            ),
          ),
          
          // Game content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.padding),
              child: Column(
                children: [
                  // Target letter
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.padding),
                      child: Column(
                        children: [
                          const Text(
                            'Nacrtajte slovo:',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: AppSizes.smallPadding),
                          Text(
                            widget.letter,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.padding),
                  
                  // Quick actions
                  if (_isGameActive && !_isCountdown)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _addPlayerScore(5),
                          icon: const Icon(Icons.star),
                          label: const Text('+5'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.successGreen,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _addPlayerScore(10),
                          icon: const Icon(Icons.star),
                          label: const Text('+10'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.warningOrange,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _addPlayerScore(15),
                          icon: const Icon(Icons.star),
                          label: const Text('+15'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: AppSizes.padding),
                  
                  // Game history
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Istorija igre:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppSizes.smallPadding),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _gameHistory.length,
                                itemBuilder: (context, index) {
                                  var entry = _gameHistory[_gameHistory.length - 1 - index];
                                  return ListTile(
                                    leading: Icon(
                                      entry['type'] == 'player' ? Icons.person : Icons.computer,
                                      color: entry['type'] == 'player' ? AppColors.primary : Colors.grey,
                                    ),
                                    title: Text(
                                      '${entry['type'] == 'player' ? 'Vi' : 'Protivnik'} +${entry['score']}',
                                    ),
                                    subtitle: Text(
                                      '${entry['timestamp'].hour}:${entry['timestamp'].minute.toString().padLeft(2, '0')}',
                                    ),
                                    trailing: Text(
                                      '+${entry['score']}',
                                      style: TextStyle(
                                        color: entry['type'] == 'player' ? AppColors.successGreen : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 