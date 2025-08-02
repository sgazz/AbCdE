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

void main() {
  runApp(const WritingLearningApp());
}

class WritingLearningApp extends StatelessWidget {
  const WritingLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsService.instance),
      ],
      child: Consumer<SettingsService>(
        builder: (context, settingsService, child) {
          return MaterialApp(
            title: AppStrings.appTitle,
            theme: settingsService.getTheme(),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: AppStrings.lessons,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: AppStrings.progress,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: AppStrings.settings,
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.edit,
              size: 100,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSizes.largePadding),
            const Text(
              'Dobrodošli u aplikaciju za učenje pisanja!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.padding),
            const Text(
              'Naučite da pišete slova kroz zabavne lekcije i vežbe.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.largePadding),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WritingScreen(
                      letter: 'A',
                      alphabetType: AlphabetType.latin,
                      writingStyle: WritingStyle.cursive,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Započni učenje'),
            ),
            const SizedBox(height: AppSizes.padding),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DemoScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.animation),
              label: const Text('Demonstracija animacija'),
            ),
            const SizedBox(height: AppSizes.padding),
            OutlinedButton.icon(
              onPressed: () {
                // Navigacija na napredak
              },
              icon: const Icon(Icons.assessment),
              label: const Text('Pogledaj napredak'),
            ),
          ],
        ),
      ),
    );
  }
}

// LessonsScreen je sada u zasebnom fajlu

// ProgressScreen i SettingsScreen su sada u zasebnim fajlovima
