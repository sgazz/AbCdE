import 'package:flutter/material.dart';
import '../models/user_progress.dart';
import '../models/letter.dart';
import '../services/progress_service.dart';
import '../widgets/star_rating.dart';
import '../utils/constants.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final ProgressService _progressService = ProgressService.instance;
  UserProgress? _userProgress;
  Map<String, dynamic>? _statistics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserProgress progress = await _progressService.loadProgress();
      Map<String, dynamic> stats = await _progressService.getStatistics();
      
      setState(() {
        _userProgress = progress;
        _statistics = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Greška pri učitavanju napretka: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.progress),
        actions: [
          IconButton(
            onPressed: _loadProgress,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProgress,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatisticsCards(),
                    const SizedBox(height: AppSizes.largePadding),
                    _buildProgressOverview(),
                    const SizedBox(height: AppSizes.largePadding),
                    _buildAchievements(),
                    const SizedBox(height: AppSizes.largePadding),
                    _buildRecentActivity(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatisticsCards() {
    if (_statistics == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistike',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.padding),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: AppSizes.padding,
          mainAxisSpacing: AppSizes.padding,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              'Ukupno slova',
              '${_statistics!['totalLettersPracticed']}',
              Icons.abc,
              AppColors.primary,
            ),
            _buildStatCard(
              'Ukupno zvezdica',
              '${_statistics!['totalStars']}',
              Icons.star,
              AppColors.starColor,
            ),
            _buildStatCard(
              'Sesije',
              '${_statistics!['totalSessions']}',
              Icons.school,
              AppColors.secondary,
            ),
            _buildStatCard(
              'Tačnost',
              '${(_statistics!['overallAccuracy'] * 100).toStringAsFixed(1)}%',
              Icons.trending_up,
              AppColors.successGreen,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: AppSizes.smallPadding),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: AppSizes.smallPadding),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressOverview() {
    if (_userProgress == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pregled napretka',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.padding),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Savladana slova:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${_userProgress!.masteredLetters}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.smallPadding),
                LinearProgressIndicator(
                  value: _userProgress!.letterProgress.length > 0
                      ? _userProgress!.masteredLetters / _userProgress!.letterProgress.length
                      : 0,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                const SizedBox(height: AppSizes.smallPadding),
                Text(
                  'Ukupno tačnost: ${(_userProgress!.overallAccuracy * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievements() {
    if (_userProgress == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dostignuća',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.padding),
        if (_userProgress!.achievements.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.padding),
              child: Column(
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: AppSizes.smallPadding),
                  const Text(
                    'Još nema dostignuća',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: AppSizes.smallPadding),
                  const Text(
                    'Nastavite da vežbate da otključate dostignuća!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _userProgress!.achievements.length,
            itemBuilder: (context, index) {
              Achievement achievement = _userProgress!.achievements[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppSizes.smallPadding),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(achievement.title),
                  subtitle: Text(achievement.description),
                  trailing: achievement.isUnlocked
                      ? Icon(
                          Icons.check_circle,
                          color: AppColors.successGreen,
                        )
                      : Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    if (_userProgress == null) return const SizedBox.shrink();

    var recentLetters = _userProgress!.letterProgress.values
        .where((progress) => progress.practiceCount > 0)
        .toList()
      ..sort((a, b) => b.lastPracticed.compareTo(a.lastPracticed));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nedavna aktivnost',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.padding),
        if (recentLetters.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.padding),
              child: Column(
                children: [
                  Icon(
                    Icons.history,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: AppSizes.smallPadding),
                  const Text(
                    'Još nema aktivnosti',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentLetters.take(5).length,
            itemBuilder: (context, index) {
              LetterProgress progress = recentLetters[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppSizes.smallPadding),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text(
                      progress.character,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text('Slovo ${progress.character}'),
                  subtitle: Text(
                    'Vežbano ${progress.practiceCount} puta • ${progress.lastPracticed.day}.${progress.lastPracticed.month}.',
                  ),
                  trailing: StarRating(
                    stars: progress.stars,
                    size: 20,
                    showNumber: false,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
} 