import 'package:flutter/material.dart';
import '../widgets/letter_animation.dart';
import '../models/letter.dart';
import '../utils/constants.dart';
import '../widgets/gradient_button.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/animated_card.dart';
import '../widgets/swipe_gestures.dart';
import '../widgets/pull_to_refresh.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  String _selectedLetter = 'A';
  AlphabetType _selectedAlphabet = AlphabetType.latin;
  WritingStyle _selectedStyle = WritingStyle.cursive;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demonstracija animacija'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          children: [
            // Odabir slova
            AnimatedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Odaberite slovo:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.padding),
                  Wrap(
                    spacing: AppSizes.smallPadding,
                    children: _getLetters().take(10).map((letter) {
                      return ChoiceChip(
                        label: Text(
                          letter,
                          style: const TextStyle(fontSize: 18),
                        ),
                        selected: _selectedLetter == letter,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedLetter = letter;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSizes.padding),
            
            // Odabir alfabeta i stila
            Row(
              children: [
                Expanded(
                  child: AnimatedCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Alfabet:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSizes.smallPadding),
                        DropdownButton<AlphabetType>(
                          value: _selectedAlphabet,
                          isExpanded: true,
                          items: [
                            DropdownMenuItem(
                              value: AlphabetType.latin,
                              child: Text(AppStrings.latinAlphabet),
                            ),
                            DropdownMenuItem(
                              value: AlphabetType.cyrillic,
                              child: Text(AppStrings.cyrillicAlphabet),
                            ),
                            DropdownMenuItem(
                              value: AlphabetType.numbers,
                              child: Text(AppStrings.numbers),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedAlphabet = value;
                                _selectedLetter = _getLetters().first;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.smallPadding),
                Expanded(
                  child: AnimatedCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Stil:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSizes.smallPadding),
                        DropdownButton<WritingStyle>(
                          value: _selectedStyle,
                          isExpanded: true,
                          items: [
                            DropdownMenuItem(
                              value: WritingStyle.cursive,
                              child: Text(AppStrings.cursive),
                            ),
                            DropdownMenuItem(
                              value: WritingStyle.print,
                              child: Text(AppStrings.print),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedStyle = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.padding),
            
            // Animacija
            Expanded(
              child: AnimatedCard(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Animacija slova $_selectedLetter',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSizes.padding),
                      SizedBox(
                        height: 300,
                        child: Center(
                          child: LetterAnimation(
                            letter: _selectedLetter,
                            alphabetType: _selectedAlphabet,
                            writingStyle: _selectedStyle,
                            autoPlay: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: AppSizes.padding),
            
            // Instrukcije
            AnimatedCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: AppColors.primary,
                        size: AppSizes.iconSize,
                      ),
                      const SizedBox(width: AppSizes.smallPadding),
                      const Text(
                        'Instrukcije:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.smallPadding),
                  Flexible(
                    child: const Text(
                      '• Odaberite slovo iz liste iznad\n'
                      '• Animacija će pokazati kako se crta slovo\n'
                      '• Koristite kontrole za pauziranje/ponavljanje\n'
                      '• Možete promeniti alfabet i stil pisanja',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSizes.padding),
            
            // Animated gradient buttons
            Row(
              children: [
                Expanded(
                  child: AnimatedGradientButton(
                    onPressed: () {
                      // Demo action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Animated button pressed!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    text: 'Animated Button',
                    icon: Icons.play_arrow,
                    gradientStart: AppColors.primary,
                    gradientEnd: AppColors.primaryVariant,
                  ),
                ),
                const SizedBox(width: AppSizes.smallPadding),
                Expanded(
                  child: AnimatedGradientButton(
                    onPressed: () {
                      // Demo action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Secondary button pressed!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    text: 'Secondary',
                    icon: Icons.settings,
                    gradientStart: AppColors.secondary,
                    gradientEnd: AppColors.secondaryVariant,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.padding),
            
            // Swipe gestures demo
            AnimatedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Swipe Gestures Demo:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.padding),
                  SwipeableCard(
                    onSwipeLeft: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Swipe Left!')),
                      );
                    },
                    onSwipeRight: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Swipe Right!')),
                      );
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryVariant],
                        ),
                        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                      ),
                      child: const Center(
                        child: Text(
                          'Swipe me!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSizes.padding),
            
            // Pull to refresh demo
            AnimatedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pull to Refresh Demo:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.padding),
                  SizedBox(
                    height: 100,
                    child: CustomPullToRefresh(
                      onRefresh: () async {
                        await Future.delayed(const Duration(seconds: 2));
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Refreshed!')),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                        ),
                        child: const Center(
                          child: Text(
                            'Pull down to refresh',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getLetters() {
    switch (_selectedAlphabet) {
      case AlphabetType.latin:
        return LetterData.latinLetters;
      case AlphabetType.cyrillic:
        return LetterData.cyrillicLetters;
      case AlphabetType.numbers:
        return LetterData.numbers;
    }
  }
} 