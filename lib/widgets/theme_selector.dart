import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AppTheme {
  final String name;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color textColor;
  final String iconPath;

  AppTheme({
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.textColor,
    required this.iconPath,
  });
}

class ThemeSelector extends StatefulWidget {
  final AppTheme currentTheme;
  final Function(AppTheme) onThemeChanged;

  const ThemeSelector({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  late AppTheme _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Odabir teme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Odaberite temu aplikacije:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.padding),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSizes.padding,
                  mainAxisSpacing: AppSizes.padding,
                  childAspectRatio: 0.8,
                ),
                itemCount: _availableThemes.length,
                itemBuilder: (context, index) {
                  return _buildThemeCard(_availableThemes[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard(AppTheme theme) {
    bool isSelected = _selectedTheme.name == theme.name;
    
    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        side: isSelected 
            ? BorderSide(color: theme.primaryColor, width: 3)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTheme = theme;
          });
          widget.onThemeChanged(theme);
        },
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.primaryColor,
                theme.secondaryColor,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Theme preview
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: theme.surfaceColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: theme.textColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    _getThemeIcon(theme.name),
                    color: theme.primaryColor,
                    size: 30,
                  ),
                ),
                
                const SizedBox(height: AppSizes.padding),
                
                // Theme name
                Text(
                  theme.name,
                  style: TextStyle(
                    color: theme.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppSizes.smallPadding),
                
                // Theme description
                Text(
                  theme.description,
                  style: TextStyle(
                    color: theme.textColor.withOpacity(0.8),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: AppSizes.smallPadding),
                
                // Selected indicator
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.textColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Odabrano',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getThemeIcon(String themeName) {
    switch (themeName.toLowerCase()) {
      case 'klasična':
        return Icons.school;
      case 'moderna':
        return Icons.trending_up;
      case 'dečja':
        return Icons.child_care;
      case 'tamna':
        return Icons.dark_mode;
      case 'prirodna':
        return Icons.eco;
      case 'sport':
        return Icons.sports_soccer;
      default:
        return Icons.palette;
    }
  }

  static List<AppTheme> get _availableThemes => [
    AppTheme(
      name: 'Klasična',
      description: 'Tradicionalna tema sa plavim tonovima',
      primaryColor: const Color(0xFF2196F3),
      secondaryColor: const Color(0xFF1976D2),
      backgroundColor: const Color(0xFFF5F5F5),
      surfaceColor: Colors.white,
      textColor: Colors.white,
      iconPath: 'assets/images/themes/classic.png',
    ),
    AppTheme(
      name: 'Moderna',
      description: 'Sleek dizajn sa gradijentima',
      primaryColor: const Color(0xFF9C27B0),
      secondaryColor: const Color(0xFF7B1FA2),
      backgroundColor: const Color(0xFFFAFAFA),
      surfaceColor: Colors.white,
      textColor: Colors.white,
      iconPath: 'assets/images/themes/modern.png',
    ),
    AppTheme(
      name: 'Dečja',
      description: 'Vesela tema sa živim bojama',
      primaryColor: const Color(0xFFFF9800),
      secondaryColor: const Color(0xFFF57C00),
      backgroundColor: const Color(0xFFFFF8E1),
      surfaceColor: Colors.white,
      textColor: Colors.white,
      iconPath: 'assets/images/themes/kids.png',
    ),
    AppTheme(
      name: 'Tamna',
      description: 'Elegantna tamna tema',
      primaryColor: const Color(0xFF424242),
      secondaryColor: const Color(0xFF212121),
      backgroundColor: const Color(0xFF121212),
      surfaceColor: const Color(0xFF1E1E1E),
      textColor: Colors.white,
      iconPath: 'assets/images/themes/dark.png',
    ),
    AppTheme(
      name: 'Prirodna',
      description: 'Tema inspirisana prirodom',
      primaryColor: const Color(0xFF4CAF50),
      secondaryColor: const Color(0xFF388E3C),
      backgroundColor: const Color(0xFFF1F8E9),
      surfaceColor: Colors.white,
      textColor: Colors.white,
      iconPath: 'assets/images/themes/nature.png',
    ),
    AppTheme(
      name: 'Sport',
      description: 'Dinamična sportska tema',
      primaryColor: const Color(0xFFE91E63),
      secondaryColor: const Color(0xFFC2185B),
      backgroundColor: const Color(0xFFFCE4EC),
      surfaceColor: Colors.white,
      textColor: Colors.white,
      iconPath: 'assets/images/themes/sport.png',
    ),
  ];
} 