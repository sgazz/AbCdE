import 'package:flutter/material.dart';
import '../services/progress_service.dart';
import '../services/audio_service.dart';
import '../widgets/theme_selector.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ProgressService _progressService = ProgressService.instance;
  final AudioService _audioService = AudioService.instance;
  
  Map<String, dynamic> _settings = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> settings = await _progressService.loadSettings();
      setState(() {
        _settings = settings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    try {
      await _progressService.saveSettings(_settings);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Podešavanja sačuvana'),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Greška pri čuvanju: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _updateSetting(String key, dynamic value) {
    setState(() {
      _settings[key] = value;
    });
    _saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppSizes.padding),
              children: [
                _buildAudioSettings(),
                const SizedBox(height: AppSizes.largePadding),
                _buildDisplaySettings(),
                const SizedBox(height: AppSizes.largePadding),
                _buildLearningSettings(),
                const SizedBox(height: AppSizes.largePadding),
                _buildDataSettings(),
              ],
            ),
    );
  }

  Widget _buildAudioSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.volume_up,
                  color: AppColors.primary,
                  size: AppSizes.iconSize,
                ),
                const SizedBox(width: AppSizes.smallPadding),
                const Text(
                  'Zvuk',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.padding),
            SwitchListTile(
              title: const Text('Uključi zvuk'),
              subtitle: const Text('Reprodukuj zvukove i uputstva'),
              value: _settings['audioEnabled'] ?? true,
              onChanged: (value) {
                _updateSetting('audioEnabled', value);
                if (value) {
                  _audioService.setVolume(_settings['audioVolume'] ?? 0.8);
                } else {
                  _audioService.setVolume(0.0);
                }
              },
            ),
            if (_settings['audioEnabled'] ?? true) ...[
              const SizedBox(height: AppSizes.smallPadding),
              ListTile(
                title: const Text('Glasnoća'),
                subtitle: Slider(
                  value: (_settings['audioVolume'] ?? 0.8).toDouble(),
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: '${((_settings['audioVolume'] ?? 0.8) * 100).round()}%',
                  onChanged: (value) {
                    _updateSetting('audioVolume', value);
                    _audioService.setVolume(value);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDisplaySettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.display_settings,
                  color: AppColors.primary,
                  size: AppSizes.iconSize,
                ),
                const SizedBox(width: AppSizes.smallPadding),
                const Text(
                  'Prikaz',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.padding),
            SwitchListTile(
              title: const Text('Animacije'),
              subtitle: const Text('Prikaži animacije i efekte'),
              value: _settings['animationsEnabled'] ?? true,
              onChanged: (value) => _updateSetting('animationsEnabled', value),
            ),
            ListTile(
              title: const Text('Grid pozadina'),
              subtitle: const Text('Prikaži mrežu na canvas-u'),
              trailing: Switch(
                value: _settings['showGrid'] ?? true,
                onChanged: (value) => _updateSetting('showGrid', value),
              ),
            ),
            ListTile(
              title: const Text('Target slovo'),
              subtitle: const Text('Prikaži slovo kao pozadinu'),
              trailing: Switch(
                value: _settings['showTargetLetter'] ?? true,
                onChanged: (value) => _updateSetting('showTargetLetter', value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.school,
                  color: AppColors.primary,
                  size: AppSizes.iconSize,
                ),
                const SizedBox(width: AppSizes.smallPadding),
                const Text(
                  'Učenje',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.padding),
            ListTile(
              title: const Text('Podrazumevani alfabet'),
              subtitle: Text(_getAlphabetName(_settings['selectedAlphabet'] ?? 'latin')),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showAlphabetDialog(),
            ),
            ListTile(
              title: const Text('Podrazumevani stil'),
              subtitle: Text(_getStyleName(_settings['selectedWritingStyle'] ?? 'cursive')),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showStyleDialog(),
            ),
            ListTile(
              title: const Text('Nivo težine'),
              subtitle: Text(_getDifficultyName(_settings['difficultyLevel'] ?? 'beginner')),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showDifficultyDialog(),
            ),
            ListTile(
              title: const Text('Tema aplikacije'),
              subtitle: Text(_settings['selectedTheme'] ?? 'Klasična'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showThemeSelector(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.data_usage,
                  color: AppColors.primary,
                  size: AppSizes.iconSize,
                ),
                const SizedBox(width: AppSizes.smallPadding),
                const Text(
                  'Podaci',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.padding),
            ListTile(
              title: const Text('Resetuj napredak'),
              subtitle: const Text('Obriši sve podatke o napretku'),
              leading: const Icon(Icons.delete_forever, color: AppColors.error),
              onTap: () => _showResetDialog(),
            ),
            ListTile(
              title: const Text('Eksportuj podatke'),
              subtitle: const Text('Sačuvaj napredak u fajl'),
              leading: const Icon(Icons.download),
              onTap: () {
                // TODO: Implement export functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funkcionalnost u izradi'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getAlphabetName(String alphabet) {
    switch (alphabet) {
      case 'latin':
        return AppStrings.latinAlphabet;
      case 'cyrillic':
        return AppStrings.cyrillicAlphabet;
      case 'numbers':
        return AppStrings.numbers;
      default:
        return AppStrings.latinAlphabet;
    }
  }

  String _getStyleName(String style) {
    switch (style) {
      case 'cursive':
        return AppStrings.cursive;
      case 'print':
        return AppStrings.print;
      default:
        return AppStrings.cursive;
    }
  }

  String _getDifficultyName(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return 'Početnik';
      case 'intermediate':
        return 'Srednji';
      case 'advanced':
        return 'Napredni';
      default:
        return 'Početnik';
    }
  }

  void _showAlphabetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Odaberite alfabet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(AppStrings.latinAlphabet),
              value: 'latin',
              groupValue: _settings['selectedAlphabet'] ?? 'latin',
              onChanged: (value) {
                _updateSetting('selectedAlphabet', value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(AppStrings.cyrillicAlphabet),
              value: 'cyrillic',
              groupValue: _settings['selectedAlphabet'] ?? 'latin',
              onChanged: (value) {
                _updateSetting('selectedAlphabet', value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(AppStrings.numbers),
              value: 'numbers',
              groupValue: _settings['selectedAlphabet'] ?? 'latin',
              onChanged: (value) {
                _updateSetting('selectedAlphabet', value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showStyleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Odaberite stil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(AppStrings.cursive),
              value: 'cursive',
              groupValue: _settings['selectedWritingStyle'] ?? 'cursive',
              onChanged: (value) {
                _updateSetting('selectedWritingStyle', value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(AppStrings.print),
              value: 'print',
              groupValue: _settings['selectedWritingStyle'] ?? 'cursive',
              onChanged: (value) {
                _updateSetting('selectedWritingStyle', value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDifficultyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Odaberite nivo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Početnik'),
              value: 'beginner',
              groupValue: _settings['difficultyLevel'] ?? 'beginner',
              onChanged: (value) {
                _updateSetting('difficultyLevel', value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Srednji'),
              value: 'intermediate',
              groupValue: _settings['difficultyLevel'] ?? 'beginner',
              onChanged: (value) {
                _updateSetting('difficultyLevel', value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Napredni'),
              value: 'advanced',
              groupValue: _settings['difficultyLevel'] ?? 'beginner',
              onChanged: (value) {
                _updateSetting('difficultyLevel', value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeSelector() {
    AppTheme currentTheme = _getCurrentTheme();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThemeSelector(
          currentTheme: currentTheme,
          onThemeChanged: (theme) {
            _updateSetting('selectedTheme', theme.name);
            _updateSetting('themePrimaryColor', theme.primaryColor.value);
            _updateSetting('themeSecondaryColor', theme.secondaryColor.value);
            _updateSetting('themeBackgroundColor', theme.backgroundColor.value);
            _updateSetting('themeSurfaceColor', theme.surfaceColor.value);
            _updateSetting('themeTextColor', theme.textColor.value);
          },
        ),
      ),
    );
  }

  AppTheme _getCurrentTheme() {
    String themeName = _settings['selectedTheme'] ?? 'Klasična';
    
    switch (themeName) {
      case 'Klasična':
        return AppTheme(
          name: 'Klasična',
          description: 'Tradicionalna tema sa plavim tonovima',
          primaryColor: const Color(0xFF2196F3),
          secondaryColor: const Color(0xFF1976D2),
          backgroundColor: const Color(0xFFF5F5F5),
          surfaceColor: Colors.white,
          textColor: Colors.white,
          iconPath: 'assets/images/themes/classic.png',
        );
      case 'Moderna':
        return AppTheme(
          name: 'Moderna',
          description: 'Sleek dizajn sa gradijentima',
          primaryColor: const Color(0xFF9C27B0),
          secondaryColor: const Color(0xFF7B1FA2),
          backgroundColor: const Color(0xFFFAFAFA),
          surfaceColor: Colors.white,
          textColor: Colors.white,
          iconPath: 'assets/images/themes/modern.png',
        );
      case 'Dečja':
        return AppTheme(
          name: 'Dečja',
          description: 'Vesela tema sa živim bojama',
          primaryColor: const Color(0xFFFF9800),
          secondaryColor: const Color(0xFFF57C00),
          backgroundColor: const Color(0xFFFFF8E1),
          surfaceColor: Colors.white,
          textColor: Colors.white,
          iconPath: 'assets/images/themes/kids.png',
        );
      case 'Tamna':
        return AppTheme(
          name: 'Tamna',
          description: 'Elegantna tamna tema',
          primaryColor: const Color(0xFF424242),
          secondaryColor: const Color(0xFF212121),
          backgroundColor: const Color(0xFF121212),
          surfaceColor: const Color(0xFF1E1E1E),
          textColor: Colors.white,
          iconPath: 'assets/images/themes/dark.png',
        );
      case 'Prirodna':
        return AppTheme(
          name: 'Prirodna',
          description: 'Tema inspirisana prirodom',
          primaryColor: const Color(0xFF4CAF50),
          secondaryColor: const Color(0xFF388E3C),
          backgroundColor: const Color(0xFFF1F8E9),
          surfaceColor: Colors.white,
          textColor: Colors.white,
          iconPath: 'assets/images/themes/nature.png',
        );
      case 'Sport':
        return AppTheme(
          name: 'Sport',
          description: 'Dinamična sportska tema',
          primaryColor: const Color(0xFFE91E63),
          secondaryColor: const Color(0xFFC2185B),
          backgroundColor: const Color(0xFFFCE4EC),
          surfaceColor: Colors.white,
          textColor: Colors.white,
          iconPath: 'assets/images/themes/sport.png',
        );
      default:
        return AppTheme(
          name: 'Klasična',
          description: 'Tradicionalna tema sa plavim tonovima',
          primaryColor: const Color(0xFF2196F3),
          secondaryColor: const Color(0xFF1976D2),
          backgroundColor: const Color(0xFFF5F5F5),
          surfaceColor: Colors.white,
          textColor: Colors.white,
          iconPath: 'assets/images/themes/classic.png',
        );
    }
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resetuj napredak'),
        content: const Text(
          'Da li ste sigurni da želite da obrišete sve podatke o napretku? Ova akcija se ne može poništiti.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Otkaži'),
          ),
          TextButton(
            onPressed: () async {
              await _progressService.resetProgress();
              Navigator.pop(context);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Napredak je resetovan'),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Resetuj'),
          ),
        ],
      ),
    );
  }
} 