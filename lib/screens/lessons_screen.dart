import 'package:flutter/material.dart';
import '../models/letter.dart';
import '../screens/writing_screen.dart';
import '../screens/lessons_progress_screen.dart';
import '../utils/constants.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  AlphabetType _selectedAlphabet = AlphabetType.latin;
  WritingStyle _selectedStyle = WritingStyle.cursive;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.lessons),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Odabir alfabeta
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Odaberite alfabet:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.padding),
                    Wrap(
                      spacing: AppSizes.smallPadding,
                      children: [
                        _buildAlphabetChip(
                          AlphabetType.latin,
                          AppStrings.latinAlphabet,
                          'A-Z',
                        ),
                        _buildAlphabetChip(
                          AlphabetType.cyrillic,
                          AppStrings.cyrillicAlphabet,
                          'А-Я',
                        ),
                        _buildAlphabetChip(
                          AlphabetType.numbers,
                          AppStrings.numbers,
                          '0-9',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppSizes.padding),
            
            // Odabir stila pisanja
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Odaberite stil pisanja:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.padding),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStyleChip(
                            WritingStyle.cursive,
                            AppStrings.cursive,
                            Icons.edit,
                          ),
                        ),
                        const SizedBox(width: AppSizes.smallPadding),
                        Expanded(
                          child: _buildStyleChip(
                            WritingStyle.print,
                            AppStrings.print,
                            Icons.text_fields,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppSizes.padding),
            
            // Opcije učenja
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Način učenja:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.padding),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LessonsProgressScreen(
                                    alphabetType: _selectedAlphabet,
                                    writingStyle: _selectedStyle,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.school),
                            label: const Text('Progresivne lekcije'),
                          ),
                        ),
                        const SizedBox(width: AppSizes.smallPadding),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Navigacija na sva slova
                            },
                            icon: const Icon(Icons.grid_view),
                            label: const Text('Sva slova'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppSizes.padding),
            
            // Lista slova
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Slova za učenje (${_getLetters().length}):',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSizes.padding),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            crossAxisSpacing: AppSizes.smallPadding,
                            mainAxisSpacing: AppSizes.smallPadding,
                            childAspectRatio: 1,
                          ),
                          itemCount: _getLetters().length,
                          itemBuilder: (context, index) {
                            String letter = _getLetters()[index];
                            return _buildLetterCard(letter);
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
    );
  }

  Widget _buildAlphabetChip(
    AlphabetType alphabet,
    String title,
    String subtitle,
  ) {
    bool isSelected = _selectedAlphabet == alphabet;
    return FilterChip(
      selected: isSelected,
      label: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
        ],
      ),
      onSelected: (selected) {
        setState(() {
          _selectedAlphabet = alphabet;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: AppColors.primary,
      checkmarkColor: Colors.white,
    );
  }

  Widget _buildStyleChip(
    WritingStyle style,
    String title,
    IconData icon,
  ) {
    bool isSelected = _selectedStyle == style;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(title),
        ],
      ),
      onSelected: (selected) {
        setState(() {
          _selectedStyle = style;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: AppColors.secondary,
      checkmarkColor: Colors.white,
    );
  }

  Widget _buildLetterCard(String letter) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WritingScreen(
              letter: letter,
              alphabetType: _selectedAlphabet,
              writingStyle: _selectedStyle,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
          ),
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
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