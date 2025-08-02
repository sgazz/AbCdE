import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'haptic_service.dart';

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  bool _isEnabled = false;
  bool _isListening = false;

  // Enable/disable voice commands
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  bool get isEnabled => _isEnabled;
  bool get isListening => _isListening;

  // Start listening for voice commands
  Future<void> startListening() async {
    if (!_isEnabled) return;
    
    setState(() {
      _isListening = true;
    });
    
    HapticService().light();
    
    // Simulate voice recognition
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isListening = false;
    });
  }

  // Stop listening
  void stopListening() {
    _isListening = false;
    HapticService().light();
  }

  // Process voice command
  Future<void> processCommand(String command) async {
    if (!_isEnabled) return;

    final lowerCommand = command.toLowerCase();
    
    // Voice commands mapping
    if (lowerCommand.contains('start') || lowerCommand.contains('započni')) {
      HapticService().success();
      // Navigate to writing screen
    } else if (lowerCommand.contains('reset') || lowerCommand.contains('ponovo')) {
      HapticService().warning();
      // Reset current activity
    } else if (lowerCommand.contains('analyze') || lowerCommand.contains('analiziraj')) {
      HapticService().medium();
      // Analyze current drawing
    } else if (lowerCommand.contains('next') || lowerCommand.contains('sledeće')) {
      HapticService().light();
      // Go to next letter
    } else if (lowerCommand.contains('back') || lowerCommand.contains('nazad')) {
      HapticService().light();
      // Go back
    } else {
      HapticService().error();
    }
  }

  // Voice feedback for actions
  Future<void> speakFeedback(String message) async {
    if (!_isEnabled) return;
    
    // Simulate text-to-speech
    await Future.delayed(const Duration(milliseconds: 500));
    HapticService().light();
  }

  // Voice instructions
  Future<void> speakInstruction(String instruction) async {
    if (!_isEnabled) return;
    
    await speakFeedback(instruction);
  }

  void setState(VoidCallback fn) {
    fn();
  }
}

// Voice command widget
class VoiceCommandWidget extends StatefulWidget {
  final Widget child;
  final Function(String) onCommand;
  final bool enableHaptic;

  const VoiceCommandWidget({
    super.key,
    required this.child,
    required this.onCommand,
    this.enableHaptic = true,
  });

  @override
  State<VoiceCommandWidget> createState() => _VoiceCommandWidgetState();
}

class _VoiceCommandWidgetState extends State<VoiceCommandWidget> {
  final VoiceService _voiceService = VoiceService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _voiceService.startListening();
        if (widget.enableHaptic) {
          HapticService().medium();
        }
      },
      child: Stack(
        children: [
          widget.child,
          if (_voiceService.isListening)
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(AppSizes.smallPadding),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: AppSizes.smallIconSize,
                    ),
                    SizedBox(width: AppSizes.smallPadding),
                    Text(
                      'Slušam...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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