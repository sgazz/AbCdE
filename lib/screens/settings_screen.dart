import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_preferences.dart';
import '../services/settings_service.dart';
import '../utils/constants.dart';
import '../widgets/animated_card.dart';
import '../widgets/accessibility_widgets.dart';
import '../theme/accessibility_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsService _settingsService;
  late UserPreferences _preferences;
  late AccessibilityThemeProvider _accessibilityProvider;

  @override
  void initState() {
    super.initState();
    _settingsService = SettingsService.instance;
    _preferences = _settingsService.preferences;
    _accessibilityProvider = Provider.of<AccessibilityThemeProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.background, AppColors.surface],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                AccessibilityWidgets.accessibleText(
                  text: 'Podešavanja',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  hint: 'Naslov ekrana za podešavanja',
                ),
                
                const SizedBox(height: AppSizes.largePadding),
                
                Expanded(
                  child: ListView(
                    children: [
                      // Accessibility Section
                      _buildAccessibilitySection(),
                      
                      const SizedBox(height: AppSizes.largePadding),
                      
                      // Theme Section
                      _buildThemeSection(),
                      
                      const SizedBox(height: AppSizes.largePadding),
                      
                      // Language Section
                      _buildLanguageSection(),
                      
                      const SizedBox(height: AppSizes.largePadding),
                      
                      // Gameplay Section
                      _buildGameplaySection(),
                      
                      const SizedBox(height: AppSizes.largePadding),
                      
                      // Audio Section
                      _buildAudioSection(),
                      
                      const SizedBox(height: AppSizes.largePadding),
                      
                      // Advanced Section
                      _buildAdvancedSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccessibilitySection() {
    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccessibilityWidgets.accessibleText(
            text: 'Pristupačnost',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            hint: 'Sekcija za pristupačnost',
          ),
          
          const SizedBox(height: AppSizes.padding),
          
          // High Contrast
          SwitchListTile(
            title: AccessibilityWidgets.accessibleText(
              text: 'Visok kontrast',
              style: Theme.of(context).textTheme.bodyLarge!,
              hint: 'Opcija za visok kontrast',
            ),
            subtitle: AccessibilityWidgets.accessibleText(
              text: 'Poboljšava vidljivost za korisnike sa oštećenim vidom',
              style: Theme.of(context).textTheme.bodySmall!,
              hint: 'Opis opcije za visok kontrast',
            ),
            value: _accessibilityProvider.isHighContrast,
            onChanged: (value) {
              setState(() {
                _accessibilityProvider.setHighContrast(value);
              });
            },
          ),
          
          // Large Text
          SwitchListTile(
            title: AccessibilityWidgets.accessibleText(
              text: 'Veliki tekst',
              style: Theme.of(context).textTheme.bodyLarge!,
              hint: 'Opcija za veliki tekst',
            ),
            subtitle: AccessibilityWidgets.accessibleText(
              text: 'Povećava veličinu teksta za lakše čitanje',
              style: Theme.of(context).textTheme.bodySmall!,
              hint: 'Opis opcije za veliki tekst',
            ),
            value: _accessibilityProvider.isLargeText,
            onChanged: (value) {
              setState(() {
                _accessibilityProvider.setLargeText(value);
              });
            },
          ),
          
          // Reduced Motion
          SwitchListTile(
            title: AccessibilityWidgets.accessibleText(
              text: 'Smanjene animacije',
              style: Theme.of(context).textTheme.bodyLarge!,
              hint: 'Opcija za smanjene animacije',
            ),
            subtitle: AccessibilityWidgets.accessibleText(
              text: 'Smanjuje animacije za korisnike osetljive na pokret',
              style: Theme.of(context).textTheme.bodySmall!,
              hint: 'Opis opcije za smanjene animacije',
            ),
            value: _accessibilityProvider.isReducedMotion,
            onChanged: (value) {
              setState(() {
                _accessibilityProvider.setReducedMotion(value);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSection() {
    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccessibilityWidgets.accessibleText(
            text: 'Tema',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            hint: 'Sekcija za temu',
          ),
          
          const SizedBox(height: AppSizes.padding),
          
          // Theme Selection
          DropdownButtonFormField<String>(
            value: _preferences.theme,
            decoration: const InputDecoration(
              labelText: 'Izaberi temu',
              border: OutlineInputBorder(),
            ),
            items: SettingsService.themeOptions.map((option) {
              return DropdownMenuItem(
                value: option.name,
                child: Text(option.displayName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _preferences = _preferences.copyWith(theme: value);
                  _settingsService.updatePreferences(_preferences);
                });
              }
            },
          ),
          
          const SizedBox(height: AppSizes.padding),
          
          // Dark Mode
          SwitchListTile(
            title: AccessibilityWidgets.accessibleText(
              text: 'Tamna tema',
              style: Theme.of(context).textTheme.bodyLarge!,
              hint: 'Opcija za tamnu temu',
            ),
            subtitle: AccessibilityWidgets.accessibleText(
              text: 'Uključuje tamnu temu za bolje iskustvo',
              style: Theme.of(context).textTheme.bodySmall!,
              hint: 'Opis opcije za tamnu temu',
            ),
            value: _preferences.isDarkMode,
            onChanged: (value) {
              setState(() {
                _preferences = _preferences.copyWith(isDarkMode: value);
                _settingsService.updatePreferences(_preferences);
              });
            },
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
          AccessibilityWidgets.accessibleText(
            text: 'Jezik',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            hint: 'Sekcija za jezik',
          ),
          
          const SizedBox(height: AppSizes.padding),
          
          // Language Selection
          DropdownButtonFormField<String>(
            value: _preferences.language,
            decoration: const InputDecoration(
              labelText: 'Izaberi jezik',
              border: OutlineInputBorder(),
            ),
            items: SettingsService.languageOptions.map((option) {
              return DropdownMenuItem(
                value: option.code,
                child: Text(option.displayName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _preferences = _preferences.copyWith(language: value);
                  _settingsService.updatePreferences(_preferences);
                });
              }
            },
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
          AccessibilityWidgets.accessibleText(
            text: 'Igra',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            hint: 'Sekcija za igru',
          ),
          
          const SizedBox(height: AppSizes.padding),
          
          // Difficulty Level
          DropdownButtonFormField<String>(
            value: _preferences.difficultyLevel,
            decoration: const InputDecoration(
              labelText: 'Nivo težine',
              border: OutlineInputBorder(),
            ),
            items: SettingsService.difficultyLevels.map((level) {
              return DropdownMenuItem(
                value: level.name,
                child: Text(level.displayName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _preferences = _preferences.copyWith(difficultyLevel: value);
                  _settingsService.updatePreferences(_preferences);
                });
              }
            },
          ),
          
          const SizedBox(height: AppSizes.padding),
          
          // Hints
          SwitchListTile(
            title: AccessibilityWidgets.accessibleText(
              text: 'Saveti',
              style: Theme.of(context).textTheme.bodyLarge!,
              hint: 'Opcija za savete',
            ),
            subtitle: AccessibilityWidgets.accessibleText(
              text: 'Prikazuje savete tokom učenja',
              style: Theme.of(context).textTheme.bodySmall!,
              hint: 'Opis opcije za savete',
            ),
            value: _preferences.showHints,
            onChanged: (value) {
              setState(() {
                _preferences = _preferences.copyWith(showHints: value);
                _settingsService.updatePreferences(_preferences);
              });
            },
          ),
          
          // Auto-save
          SwitchListTile(
            title: AccessibilityWidgets.accessibleText(
              text: 'Automatsko čuvanje',
              style: Theme.of(context).textTheme.bodyLarge!,
              hint: 'Opcija za automatsko čuvanje',
            ),
            subtitle: AccessibilityWidgets.accessibleText(
              text: 'Automatski čuva napredak',
              style: Theme.of(context).textTheme.bodySmall!,
              hint: 'Opis opcije za automatsko čuvanje',
            ),
            value: _preferences.autoSave,
            onChanged: (value) {
              setState(() {
                _preferences = _preferences.copyWith(autoSave: value);
                _settingsService.updatePreferences(_preferences);
              });
            },
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
          AccessibilityWidgets.accessibleText(
            text: 'Audio',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            hint: 'Sekcija za audio',
          ),
          
          const SizedBox(height: AppSizes.padding),
          
          // Sound Effects
          SwitchListTile(
            title: AccessibilityWidgets.accessibleText(
              text: 'Zvučni efekti',
              style: Theme.of(context).textTheme.bodyLarge!,
              hint: 'Opcija za zvučne efekte',
            ),
            subtitle: AccessibilityWidgets.accessibleText(
              text: 'Uključuje zvučne efekte',
              style: Theme.of(context).textTheme.bodySmall!,
              hint: 'Opis opcije za zvučne efekte',
            ),
            value: _preferences.soundEnabled,
            onChanged: (value) {
              setState(() {
                _preferences = _preferences.copyWith(soundEnabled: value);
                _settingsService.updatePreferences(_preferences);
              });
            },
          ),
          
          // Vibration
          SwitchListTile(
            title: AccessibilityWidgets.accessibleText(
              text: 'Vibracija',
              style: Theme.of(context).textTheme.bodyLarge!,
              hint: 'Opcija za vibraciju',
            ),
            subtitle: AccessibilityWidgets.accessibleText(
              text: 'Uključuje haptic feedback',
              style: Theme.of(context).textTheme.bodySmall!,
              hint: 'Opis opcije za vibraciju',
            ),
            value: _preferences.vibrationEnabled,
            onChanged: (value) {
              setState(() {
                _preferences = _preferences.copyWith(vibrationEnabled: value);
                _settingsService.updatePreferences(_preferences);
              });
            },
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
          AccessibilityWidgets.accessibleText(
            text: 'Napredno',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            hint: 'Sekcija za napredne opcije',
          ),
          
          const SizedBox(height: AppSizes.padding),
          
          // Animation Speed
          ListTile(
            title: AccessibilityWidgets.accessibleText(
              text: 'Brzina animacija',
              style: Theme.of(context).textTheme.bodyLarge!,
              hint: 'Opcija za brzinu animacija',
            ),
            subtitle: Slider(
              value: _preferences.animationSpeed,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              label: '${_preferences.animationSpeed.toStringAsFixed(1)}x',
              onChanged: (value) {
                setState(() {
                  _preferences = _preferences.copyWith(animationSpeed: value);
                  _settingsService.updatePreferences(_preferences);
                });
              },
            ),
          ),
          
          // Font Size
          ListTile(
            title: AccessibilityWidgets.accessibleText(
              text: 'Veličina fonta',
              style: Theme.of(context).textTheme.bodyLarge!,
              hint: 'Opcija za veličinu fonta',
            ),
            subtitle: Slider(
              value: _preferences.fontSize,
              min: 0.8,
              max: 1.4,
              divisions: 6,
              label: '${(_preferences.fontSize * 100).round()}%',
              onChanged: (value) {
                setState(() {
                  _preferences = _preferences.copyWith(fontSize: value);
                  _settingsService.updatePreferences(_preferences);
                });
              },
            ),
          ),
          
          // High Contrast
          SwitchListTile(
            title: AccessibilityWidgets.accessibleText(
              text: 'Visok kontrast',
              style: Theme.of(context).textTheme.bodyLarge!,
              hint: 'Opcija za visok kontrast',
            ),
            subtitle: AccessibilityWidgets.accessibleText(
              text: 'Poboljšava kontrast za bolju vidljivost',
              style: Theme.of(context).textTheme.bodySmall!,
              hint: 'Opis opcije za visok kontrast',
            ),
            value: _preferences.highContrast,
            onChanged: (value) {
              setState(() {
                _preferences = _preferences.copyWith(highContrast: value);
                _settingsService.updatePreferences(_preferences);
              });
            },
          ),
        ],
      ),
    );
  }
} 