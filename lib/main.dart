import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/writing_screen.dart';
import 'screens/lessons_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/demo_screen.dart';

import 'models/letter.dart';
import 'models/lesson.dart';
import 'utils/constants.dart';
import 'theme/app_theme.dart';
import 'services/settings_service.dart';
import 'services/haptic_service.dart';
import 'services/performance_service.dart';
import 'services/optimized_asset_service.dart';
import 'utils/optimized_memory_manager.dart';
import 'widgets/micro_animations.dart';
import 'widgets/page_transitions.dart';
import 'widgets/advanced_animations.dart';
import 'widgets/interactive_feedback.dart';
import 'widgets/accessibility_widgets.dart';
import 'widgets/keyboard_navigation.dart';
import 'theme/accessibility_theme.dart';

void main() {
  // Initialize performance monitoring
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize optimized services (background monitoring)
  OptimizedMemoryManager().startMonitoring();
  OptimizedAssetService().initialize();
  
  runApp(const WritingLearningApp());
}

class WritingLearningApp extends StatelessWidget {
  const WritingLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsService.instance),
        ChangeNotifierProvider(create: (_) => AccessibilityThemeProvider()),
      ],
      child: Consumer2<SettingsService, AccessibilityThemeProvider>(
        builder: (context, settingsService, accessibilityProvider, child) {
          final baseTheme = settingsService.getTheme();
          final accessibilityTheme = accessibilityProvider.getTheme(baseTheme);
          
          return MaterialApp(
            title: AppStrings.appTitle,
            theme: accessibilityTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsService.themeProvider.themeMode,
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const LessonsScreen(),
    const ProgressScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.neutral200.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.padding,
              vertical: AppSizes.smallPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home, AppStrings.home),
                _buildNavItem(1, Icons.school, AppStrings.lessons),
                _buildNavItem(2, Icons.assessment, AppStrings.progress),
                _buildNavItem(3, Icons.settings, AppStrings.settings),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        // Haptic feedback
        HapticService().selection();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.padding,
          vertical: AppSizes.smallPadding,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.neutral500,
                size: isSelected ? AppSizes.iconSize : AppSizes.smallIconSize,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                height: 2,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.neutral500,
                fontSize: isSelected ? 12 : 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.neutral50,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Column(
              children: [
                // Header section
                _buildHeader(),
                const SizedBox(height: AppSizes.largeSpacing),
                
                // Welcome section
                _buildWelcomeSection(),
                const SizedBox(height: AppSizes.largeSpacing),
                
                // Action buttons
                Expanded(
                  child: _buildActionButtons(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.padding),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.smallPadding),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            ),
            child: const Icon(
              Icons.edit,
              color: Colors.white,
              size: AppSizes.largeIconSize,
            ),
          ),
          const SizedBox(width: AppSizes.padding),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.appTitle,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: AppSizes.smallSpacing),
                Text(
                  'Naučite da pišete slova',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.largePadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral200.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.waving_hand,
            size: AppSizes.extraLargeIconSize,
            color: AppColors.secondary,
          ),
          const SizedBox(height: AppSizes.padding),
          const Text(
            'Dobrodošli!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.smallPadding),
          const Text(
            'Spremni ste da započnete svoju avanturu u učenju pisanja?',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.neutral600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Start learning button
        AccessibilityWidgets.accessibleButton(
          label: 'Započni učenje',
          hint: 'Dugme za započinjanje učenja pisanja slova',
          onPressed: () {
            Navigator.push(
              context,
              PageTransitions.slideTransition(
                page: const WritingScreen(
                  letter: 'A',
                  alphabetType: AlphabetType.latin,
                  writingStyle: WritingStyle.cursive,
                ),
              ),
            );
          },
          child: InteractiveFeedback.success(
            message: 'Započni učenje!',
            child: MicroAnimations.pulse(
              enableHaptic: true,
              hapticType: AppHaptics.selection,
              child: Container(
                width: double.infinity,
                height: AppSizes.largeButtonHeight,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransitions.slideTransition(
                          page: const WritingScreen(
                            letter: 'A',
                            alphabetType: AlphabetType.latin,
                            writingStyle: WritingStyle.cursive,
                          ),
                        ),
                      );
                    },
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: AppSizes.iconSize,
                          ),
                          SizedBox(width: AppSizes.smallPadding),
                          Text(
                            'Započni učenje',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: AppSizes.padding),
        
        // Demo button
        AccessibilityWidgets.accessibleButton(
          label: 'Demonstracija animacija',
          hint: 'Dugme za prikaz demonstracije animacija',
          onPressed: () {
            Navigator.push(
              context,
              PageTransitions.fadeTransition(
                page: const DemoScreen(),
              ),
            );
          },
          child: AdvancedAnimations.elastic(
            enableHaptic: true,
            hapticType: AppHaptics.light,
            child: Container(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                border: Border.all(color: AppColors.neutral200),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neutral200.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransitions.fadeTransition(
                        page: const DemoScreen(),
                      ),
                    );
                  },
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.animation,
                          color: AppColors.primary,
                          size: AppSizes.iconSize,
                        ),
                        SizedBox(width: AppSizes.smallPadding),
                        Text(
                          'Demonstracija animacija',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: AppSizes.padding),
        
        // Progress button
        AccessibilityWidgets.accessibleButton(
          label: 'Pogledaj napredak',
          hint: 'Dugme za prikaz napretka u učenju',
          onPressed: () {
            // Navigacija na napredak
            HapticService().success();
          },
          child: AdvancedAnimations.wave(
            enableHaptic: true,
            hapticType: AppHaptics.light,
            child: InteractiveFeedback.info(
              message: 'Pogledaj napredak',
              child: Container(
                width: double.infinity,
                height: AppSizes.buttonHeight,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                  border: Border.all(color: AppColors.neutral200),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neutral200.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSizes.largeBorderRadius),
                    onTap: () {
                      // Navigacija na napredak
                      HapticService().success();
                    },
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assessment,
                            color: AppColors.secondary,
                            size: AppSizes.iconSize,
                          ),
                          SizedBox(width: AppSizes.smallPadding),
                          Text(
                            'Pogledaj napredak',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// LessonsScreen je sada u zasebnom fajlu

// ProgressScreen i SettingsScreen su sada u zasebnim fajlovima
