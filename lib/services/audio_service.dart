import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

class AudioService {
  static AudioService? _instance;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Map<String, AudioPlayer> _effectPlayers = {};
  
  static AudioService get instance {
    _instance ??= AudioService._internal();
    return _instance!;
  }

  AudioService._internal();

  Future<void> playLetterAudio(String letter) async {
    try {
      String audioPath = 'assets/audio/letters/$letter.mp3';
      await _audioPlayer.play(AssetSource(audioPath));
    } catch (e) {
      print('Error playing letter audio: $e');
      // Fallback - koristimo text-to-speech ili osnovni zvuk
      await _playFallbackAudio();
    }
  }

  Future<void> playInstruction(String instruction) async {
    try {
      String audioPath = 'assets/audio/instructions/$instruction.mp3';
      await _audioPlayer.play(AssetSource(audioPath));
    } catch (e) {
      print('Error playing instruction: $e');
    }
  }

  Future<void> playSuccessSound() async {
    await _playEffect('success');
  }

  Future<void> playErrorSound() async {
    await _playEffect('error');
  }

  Future<void> playStarSound(int stars) async {
    await _playEffect('star_$stars');
  }

  Future<void> playAchievementSound() async {
    await _playEffect('achievement');
  }

  Future<void> _playEffect(String effectName) async {
    try {
      if (!_effectPlayers.containsKey(effectName)) {
        _effectPlayers[effectName] = AudioPlayer();
      }
      
      String audioPath = 'assets/audio/effects/$effectName.mp3';
      await _effectPlayers[effectName]!.play(AssetSource(audioPath));
    } catch (e) {
      print('Error playing effect $effectName: $e');
    }
  }

  Future<void> _playFallbackAudio() async {
    // Osnovni zvuk ako audio fajl nije dostupan
    try {
      await _audioPlayer.play(AssetSource('assets/audio/fallback.mp3'));
    } catch (e) {
      print('Error playing fallback audio: $e');
    }
  }

  Future<void> playLetterPronunciation(String letter, String language) async {
    try {
      String audioPath = 'assets/audio/pronunciation/$language/$letter.mp3';
      await _audioPlayer.play(AssetSource(audioPath));
    } catch (e) {
      print('Error playing pronunciation: $e');
      await playLetterAudio(letter);
    }
  }

  Future<void> playWritingAnimationAudio(String letter) async {
    try {
      String audioPath = 'assets/audio/animations/$letter.mp3';
      await _audioPlayer.play(AssetSource(audioPath));
    } catch (e) {
      print('Error playing animation audio: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
    for (var player in _effectPlayers.values) {
      await player.setVolume(volume);
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    for (var player in _effectPlayers.values) {
      await player.stop();
    }
  }

  void dispose() {
    _audioPlayer.dispose();
    for (var player in _effectPlayers.values) {
      player.dispose();
    }
    _effectPlayers.clear();
  }
} 