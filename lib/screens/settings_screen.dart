import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../models/user_preferences.dart';
import '../utils/constants.dart';
import '../widgets/animated_card.dart';
import '../widgets/gradient_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = SettingsService.instance;
  late UserPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _preferences = _settingsService.preferences;
    _settingsService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _settingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    setState(() {
      _preferences = _settingsService.preferences;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Podešavanja'),
        actions: [
          IconButton(
            onPressed: _showResetDialog,
            icon: const Icon(Icons.restore),
            tooltip: 'Vrati na podrazumevano',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThemeSection(),
            const SizedBox(height: AppSizes.largePadding),
            _buildLanguageSection(),
            const SizedBox(height: AppSizes.largePadding),
            _buildAccessibilitySection(),
            const SizedBox(height: AppSizes.largePadding),
            _buildGameplaySection(),
            const SizedBox(height: AppSizes.largePadding),
            _buildAudioSection(),
            const SizedBox(height: AppSizes.largePadding),
            _buildAdvancedSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSection() {
    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tema',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.padding),
          
          // Theme options
          Wrap(
            spacing: AppSizes.smallPadding,
            runSpacing: AppSizes.smallPadding,
            children: SettingsService.themeOptions.map((theme) {
              final isSelected = _preferences.theme == theme.name;
              return GestureDetector(
                onTap: () => _settingsService.updatePreference('theme', theme.name),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.primaryColor : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected 
                        ? Border.all(color: theme.primaryColor, width: 2)
                        : null,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        theme.icon,
                        color: isSelected ? Colors.white : theme.primaryColor,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        theme.displayName,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: AppSizes.padding),
          
          // Dark mode toggle
          SwitchListTile(
            title: const Text('Tamna tema'),
            subtitle: const Text('Koristi tamnu temu aplikacije'),
            value: _preferences.isDarkMode,
            onChanged: (value) => _settingsService.updatePreference('isDarkMode', value),
            secondary: const Icon(Icons.dark_mode),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection() {
    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jezik',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.padding),
          
          // Language options
          ...SettingsService.languageOptions.map((language) {
            final isSelected = _preferences.language == language.code;
            return ListTile(
              leading: Text(language.flag, style: const TextStyle(fontSize: 24)),
              title: Text(language.nativeName),
              subtitle: Text(language.name),
              trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () => _settingsService.updatePreference('language', language.code),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAccessibilitySection() {
    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pristupačnost',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.padding),
          
          // Accessibility options
          ...SettingsService.accessibilityOptions.map((option) {
            return SwitchListTile(
              title: Text(option.displayName),
              subtitle: Text(option.description),
              value: _getAccessibilityValue(option.name),
              onChanged: (value) => _updateAccessibilityOption(option.name, value),
              secondary: Icon(option.icon),
            );
          }),
          
          const SizedBox(height: AppSizes.padding),
          
          // Font size slider
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Veličina teksta: ${(_preferences.fontSize * 100).round()}%',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _preferences.fontSize,
                min: 0.8,
                max: 1.4,
                divisions: 6,
                onChanged: (value) => _settingsService.updatePreference('fontSize', value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameplaySection() {
    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Igra',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.padding),
          
          // Difficulty level
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Nivo težine',
              border: OutlineInputBorder(),
            ),
            value: _preferences.difficultyLevel,
            items: SettingsService.difficultyLevels.map((level) {
              return DropdownMenuItem(
                value: level.name,
                child: Text(level.displayName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                _settingsService.updatePreference('difficultyLevel', value);
              }
            },
          ),
          
          const SizedBox(height: AppSizes.padding),
          
          // Gameplay options
          SwitchListTile(
            title: const Text('Prikaži savete'),
            subtitle: const Text('Prikazuje savete tokom vežbanja'),
            value: _preferences.showHints,
            onChanged: (value) => _settingsService.updatePreference('showHints', value),
            secondary: const Icon(Icons.lightbulb),
          ),
          
          SwitchListTile(
            title: const Text('Automatsko čuvanje'),
            subtitle: const Text('Automatski čuva napredak'),
            value: _preferences.autoSave,
            onChanged: (value) => _settingsService.updatePreference('autoSave', value),
            secondary: const Icon(Icons.save),
          ),
          
          const SizedBox(height: AppSizes.padding),
          
          // Animation speed
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Brzina animacije: ${(_preferences.animationSpeed * 100).round()}%',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _preferences.animationSpeed,
                min: 0.5,
                max: 2.0,
                divisions: 15,
                onChanged: (value) => _settingsService.updatePreference('animationSpeed', value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudioSection() {
    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Zvuk',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.padding),
          
          SwitchListTile(
            title: const Text('Zvuk'),
            subtitle: const Text('Omogućava zvukove u aplikaciji'),
            value: _preferences.soundEnabled,
            onChanged: (value) => _settingsService.updatePreference('soundEnabled', value),
            secondary: const Icon(Icons.volume_up),
          ),
          
          SwitchListTile(
            title: const Text('Vibracije'),
            subtitle: const Text('Omogućava vibracije na mobilnim uređajima'),
            value: _preferences.vibrationEnabled,
            onChanged: (value) => _settingsService.updatePreference('vibrationEnabled', value),
            secondary: const Icon(Icons.vibration),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSection() {
    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Napredno',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.padding),
          
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Izvezi podešavanja'),
            subtitle: const Text('Sačuvaj podešavanja u fajl'),
            onTap: _exportSettings,
          ),
          
          ListTile(
            leading: const Icon(Icons.upload),
            title: const Text('Uvezi podešavanja'),
            subtitle: const Text('Učitaj podešavanja iz fajla'),
            onTap: _importSettings,
          ),
          
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('O aplikaciji'),
            subtitle: const Text('Informacije o verziji i razvoju'),
            onTap: _showAboutDialog,
          ),
        ],
      ),
    );
  }

  bool _getAccessibilityValue(String optionName) {
    switch (optionName) {
      case 'highContrast':
        return _preferences.highContrast;
      case 'largeText':
        return _preferences.fontSize > 1.0;
      case 'reducedMotion':
        return _preferences.animationSpeed < 1.0;
      case 'screenReader':
        return _preferences.accessibilityMode;
      default:
        return false;
    }
  }

  void _updateAccessibilityOption(String optionName, bool value) {
    switch (optionName) {
      case 'highContrast':
        _settingsService.updatePreference('highContrast', value);
        break;
      case 'largeText':
        _settingsService.updatePreference('fontSize', value ? 1.2 : 1.0);
        break;
      case 'reducedMotion':
        _settingsService.updatePreference('animationSpeed', value ? 0.5 : 1.0);
        break;
      case 'screenReader':
        _settingsService.updatePreference('accessibilityMode', value);
        break;
    }
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vrati na podrazumevano'),
        content: const Text('Da li ste sigurni da želite da vratite sva podešavanja na podrazumevane vrednosti?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Otkaži'),
          ),
          ElevatedButton(
            onPressed: () {
              _settingsService.resetToDefaults();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Podešavanja su vraćena na podrazumevano')),
              );
            },
            child: const Text('Vrati'),
          ),
        ],
      ),
    );
  }

  void _exportSettings() {
    final settingsJson = _settingsService.exportPreferences();
    // Here you would typically save to file or share
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Podešavanja izvezena: ${settingsJson.substring(0, 50)}...'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _importSettings() {
    // Here you would typically load from file
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funkcija uvoza će biti implementirana')),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('O aplikaciji'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Writing Learning App'),
            SizedBox(height: 8),
            Text('Verzija: 1.0.0'),
            SizedBox(height: 8),
            Text('Aplikacija za učenje pisanja slova'),
            SizedBox(height: 8),
            Text('© 2024 - Sva prava zadržana'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Zatvori'),
          ),
        ],
      ),
    );
  }
} 