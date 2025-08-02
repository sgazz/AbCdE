import 'dart:async';
import 'package:flutter/material.dart';
import '../services/performance_service.dart';
import '../services/optimized_asset_service.dart';
import '../utils/optimized_memory_manager.dart';
import '../utils/constants.dart';
import '../widgets/optimized_animations.dart';

class PerformanceMonitorScreen extends StatefulWidget {
  const PerformanceMonitorScreen({super.key});

  @override
  State<PerformanceMonitorScreen> createState() => _PerformanceMonitorScreenState();
}

class _PerformanceMonitorScreenState extends State<PerformanceMonitorScreen>
    with PerformanceMixin {
  final PerformanceService _performanceService = PerformanceService();
  final OptimizedMemoryManager _memoryManager = OptimizedMemoryManager();
  final OptimizedAssetService _assetService = OptimizedAssetService();
  
  Timer? _updateTimer;
  Map<String, dynamic> _performanceReport = {};
  Map<String, dynamic> _memoryReport = {};
  Map<String, dynamic> _assetStats = {};

  @override
  void initState() {
    super.initState();
    _startUpdates();
  }

  void _startUpdates() {
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _performanceReport = _performanceService.getPerformanceReport();
          _memoryReport = _memoryManager.getMemoryReport();
          _assetStats = _assetService.getAssetStats();
        });
      }
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Monitor'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _performanceReport = _performanceService.getPerformanceReport();
                _memoryReport = _memoryManager.getMemoryReport();
                _assetStats = _assetService.getAssetStats();
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPerformanceSection(),
            const SizedBox(height: AppSizes.padding),
            _buildMemorySection(),
            const SizedBox(height: AppSizes.padding),
            _buildAssetSection(),
            const SizedBox(height: AppSizes.padding),
            _buildActionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSection() {
    final metrics = _performanceReport['metrics'] as Map<String, dynamic>? ?? {};
    final summary = _performanceReport['summary'] as Map<String, dynamic>? ?? {};

    return OptimizedContainer(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Metrics',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.smallPadding),
          _buildMetricRow('FPS', '${metrics['fps']?.toStringAsFixed(1) ?? 'N/A'}'),
          _buildMetricRow('Frame Time', '${metrics['frameTime']?.inMilliseconds ?? 'N/A'}ms'),
          _buildMetricRow('Memory Usage', '${metrics['memoryUsage'] ?? 'N/A'}MB'),
          _buildMetricRow('Total Events', '${summary['totalEvents'] ?? 0}'),
          _buildMetricRow('Error Events', '${summary['errorEvents'] ?? 0}'),
          _buildMetricRow('Warning Events', '${summary['warningEvents'] ?? 0}'),
        ],
      ),
    );
  }

  Widget _buildMemorySection() {
    return OptimizedContainer(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Memory Management',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.smallPadding),
          _buildMetricRow('Cache Size', '${_memoryReport['cacheSize'] ?? 0}KB'),
          _buildMetricRow('Cache Items', '${_memoryReport['cacheItems'] ?? 0}'),
          _buildMetricRow('Total Allocations', '${_memoryReport['totalAllocations'] ?? 0}'),
          _buildMetricRow('Total Deallocations', '${_memoryReport['totalDeallocations'] ?? 0}'),
          if (_memoryReport['poolStats'] != null) ...[
            const SizedBox(height: AppSizes.smallPadding),
            Text(
              'Object Pools:',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            ...(_memoryReport['poolStats'] as List).map((pool) {
              return _buildMetricRow(
                pool['name'],
                '${pool['currentSize']}/${pool['maxSize']} (${pool['allocations']} alloc, ${pool['deallocations']} dealloc)',
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildAssetSection() {
    return OptimizedContainer(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Asset Management',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.smallPadding),
          _buildMetricRow('Total Assets Loaded', '${_assetStats['totalAssetsLoaded'] ?? 0}'),
          _buildMetricRow('Total Bytes Loaded', '${(_assetStats['totalBytesLoaded'] ?? 0) ~/ 1024}KB'),
          _buildMetricRow('Cache Hits', '${_assetStats['cacheHits'] ?? 0}'),
          _buildMetricRow('Cache Misses', '${_assetStats['cacheMisses'] ?? 0}'),
          _buildMetricRow('Cache Hit Rate', '${((_assetStats['cacheHitRate'] ?? 0) * 100).toStringAsFixed(1)}%'),
          _buildMetricRow('Cached Assets', '${_assetStats['cachedAssets'] ?? 0}'),
          _buildMetricRow('Cache Size', '${(_assetStats['cacheSize'] ?? 0) ~/ 1024}KB'),
          _buildMetricRow('Loading Assets', '${_assetStats['loadingAssets'] ?? 0}'),
          _buildMetricRow('Queue Length', '${_assetStats['queueLength'] ?? 0}'),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return OptimizedContainer(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.smallPadding),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _memoryManager.clearCache();
                    _assetService.clearAllAssets();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cache cleared')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Clear All Cache'),
                ),
              ),
              const SizedBox(width: AppSizes.smallPadding),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _assetService.clearExpiredAssets();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Expired assets cleared')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Clear Expired'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.smallPadding),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _memoryManager.handleMemoryPressure();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Memory pressure handled')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Handle Memory Pressure'),
                ),
              ),
              const SizedBox(width: AppSizes.smallPadding),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _performanceService.clearOldEvents();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Old events cleared')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.info,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Clear Old Events'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 