import 'package:flutter/material.dart';
import '../services/advanced_ml_service.dart';
import '../utils/constants.dart';

/// Widget za prikaz real-time feedback-a
class RealTimeFeedbackWidget extends StatefulWidget {
  final RealTimeLetterAnalysis? analysis;
  final StrokeAnalysis? strokeAnalysis;
  final bool isVisible;
  final VoidCallback? onDismiss;

  const RealTimeFeedbackWidget({
    super.key,
    this.analysis,
    this.strokeAnalysis,
    this.isVisible = false,
    this.onDismiss,
  });

  @override
  State<RealTimeFeedbackWidget> createState() => _RealTimeFeedbackWidgetState();
}

class _RealTimeFeedbackWidgetState extends State<RealTimeFeedbackWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: AppAnimations.mediumDuration,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RealTimeFeedbackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isVisible && !oldWidget.isVisible) {
      _animationController.forward();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildFeedbackContent(),
          ),
        );
      },
    );
  }

  Widget _buildFeedbackContent() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Glavni feedback card
          _buildMainFeedbackCard(),
          
          const SizedBox(height: 8),
          
          // Stroke analysis card (ako postoji)
          if (widget.strokeAnalysis != null) _buildStrokeAnalysisCard(),
          
          const SizedBox(height: 8),
          
          // Progress indicators
          if (widget.analysis != null) _buildProgressIndicators(),
        ],
      ),
    );
  }

  Widget _buildMainFeedbackCard() {
    if (widget.analysis == null) return const SizedBox.shrink();

    final feedback = widget.analysis!.feedback;
    if (feedback.isEmpty) return const SizedBox.shrink();

    // Sortiraj feedback po prioritetu
    feedback.sort((a, b) => a.priority.compareTo(b.priority));
    final primaryFeedback = feedback.first;

    return Card(
      elevation: 8,
      color: _getFeedbackColor(primaryFeedback.type),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  _getFeedbackIcon(primaryFeedback.type),
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    primaryFeedback.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (widget.onDismiss != null)
                  IconButton(
                    onPressed: widget.onDismiss,
                    icon: const Icon(Icons.close, color: Colors.white),
                    iconSize: 20,
                  ),
              ],
            ),
            
            // Dodatni feedback items
            if (feedback.length > 1) ...[
              const SizedBox(height: 8),
              ...feedback.skip(1).map((item) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(
                      _getFeedbackIcon(item.type),
                      color: Colors.white.withOpacity(0.8),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.message,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStrokeAnalysisCard() {
    final strokeAnalysis = widget.strokeAnalysis!;
    
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  _getStrokeQualityIcon(strokeAnalysis.quality),
                  color: _getStrokeQualityColor(strokeAnalysis.quality),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Kvalitet poteza',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: _getStrokeQualityColor(strokeAnalysis.quality),
                  ),
                ),
                const Spacer(),
                Text(
                  '${(strokeAnalysis.confidence * 100).toInt()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: _getStrokeQualityColor(strokeAnalysis.quality),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Progress bar
            LinearProgressIndicator(
              value: strokeAnalysis.confidence,
              backgroundColor: AppColors.neutral200,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getStrokeQualityColor(strokeAnalysis.quality),
              ),
            ),
            
            // Suggestions
            if (strokeAnalysis.suggestions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                strokeAnalysis.suggestions.first,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.neutral600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicators() {
    final analysis = widget.analysis!;
    
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Napredak pisanja',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.neutral800,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Accuracy indicator
            _buildProgressRow(
              'Tačnost',
              analysis.accuracy,
              Icons.check_circle,
              AppColors.successGreen,
            ),
            
            const SizedBox(height: 8),
            
            // Characteristics indicators
            _buildProgressRow(
              'Proporcije',
              analysis.characteristics.proportion,
              Icons.aspect_ratio,
              AppColors.primary,
            ),
            
            const SizedBox(height: 8),
            
            _buildProgressRow(
              'Simetrija',
              analysis.characteristics.symmetry,
              Icons.balance,
              AppColors.warningOrange,
            ),
            
            const SizedBox(height: 8),
            
            _buildProgressRow(
              'Tok pisanja',
              analysis.characteristics.flow,
              Icons.trending_up,
              AppColors.secondary,
            ),
            
            const SizedBox(height: 12),
            
            // Overall score
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ukupan skor',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.neutral800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getOverallScoreColor(analysis.confidence),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(analysis.confidence * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow(String label, double value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.neutral600,
            ),
          ),
        ),
        SizedBox(
          width: 60,
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: AppColors.neutral200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(value * 100).toInt()}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getFeedbackColor(FeedbackType type) {
    switch (type) {
      case FeedbackType.success:
        return AppColors.successGreen;
      case FeedbackType.warning:
        return AppColors.warningOrange;
      case FeedbackType.error:
        return AppColors.error;
      case FeedbackType.info:
        return AppColors.primary;
    }
  }

  IconData _getFeedbackIcon(FeedbackType type) {
    switch (type) {
      case FeedbackType.success:
        return Icons.check_circle;
      case FeedbackType.warning:
        return Icons.warning;
      case FeedbackType.error:
        return Icons.error;
      case FeedbackType.info:
        return Icons.info;
    }
  }

  Color _getStrokeQualityColor(StrokeQuality quality) {
    switch (quality) {
      case StrokeQuality.excellent:
        return AppColors.successGreen;
      case StrokeQuality.good:
        return AppColors.primary;
      case StrokeQuality.fair:
        return AppColors.warningOrange;
      case StrokeQuality.poor:
        return AppColors.error;
    }
  }

  IconData _getStrokeQualityIcon(StrokeQuality quality) {
    switch (quality) {
      case StrokeQuality.excellent:
        return Icons.star;
      case StrokeQuality.good:
        return Icons.check_circle;
      case StrokeQuality.fair:
        return Icons.warning;
      case StrokeQuality.poor:
        return Icons.error;
    }
  }

  Color _getOverallScoreColor(double score) {
    if (score >= 0.9) return AppColors.successGreen;
    if (score >= 0.8) return AppColors.primary;
    if (score >= 0.7) return AppColors.warningOrange;
    return AppColors.error;
  }
}

/// Widget za prikaz real-time stroke analysis
class RealTimeStrokeAnalysisWidget extends StatelessWidget {
  final StrokeAnalysis analysis;
  final bool isVisible;

  const RealTimeStrokeAnalysisWidget({
    super.key,
    required this.analysis,
    this.isVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: AppAnimations.shortDuration,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _getStrokeQualityColor(analysis.quality).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getStrokeQualityColor(analysis.quality).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStrokeQualityIcon(analysis.quality),
            color: _getStrokeQualityColor(analysis.quality),
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            analysis.suggestions.isNotEmpty ? analysis.suggestions.first : '',
            style: TextStyle(
              fontSize: 12,
              color: _getStrokeQualityColor(analysis.quality),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStrokeQualityColor(StrokeQuality quality) {
    switch (quality) {
      case StrokeQuality.excellent:
        return AppColors.successGreen;
      case StrokeQuality.good:
        return AppColors.primary;
      case StrokeQuality.fair:
        return AppColors.warningOrange;
      case StrokeQuality.poor:
        return AppColors.error;
    }
  }

  IconData _getStrokeQualityIcon(StrokeQuality quality) {
    switch (quality) {
      case StrokeQuality.excellent:
        return Icons.star;
      case StrokeQuality.good:
        return Icons.check_circle;
      case StrokeQuality.fair:
        return Icons.warning;
      case StrokeQuality.poor:
        return Icons.error;
    }
  }
} 