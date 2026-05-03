import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/db/database.dart';
import '../../core/purchases/purchase_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/premium_guard.dart';
import 'progress_providers.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider);
    final isPremium = ref.watch(isPremiumProvider).valueOrNull ?? false;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: progressAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erro ao carregar: $e')),
          data: (data) =>
              _ProgressContent(data: data, isPremium: isPremium),
        ),
      ),
    );
  }
}

class _ProgressContent extends StatelessWidget {
  final ProgressData data;
  final bool isPremium;

  const _ProgressContent({required this.data, required this.isPremium});

  int _grammarPercent() {
    if (data.totalMessages == 0) return 100;
    final totalErrors = data.topCorrections
        .fold(0, (sum, c) => sum + c.count);
    final pct = 100 - (totalErrors * 100 ~/ data.totalMessages);
    return pct.clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 20),
          Text(
            l10n.progressTitle,
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          _StatsGrid(data: data, grammarPercent: _grammarPercent()),
          const SizedBox(height: 20),
          _WeeklyChart(weeklyMessages: data.weeklyMessages),
          const SizedBox(height: 20),
          _CorrectionsList(
            corrections: data.topCorrections,
            isPremium: isPremium,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Grid de estatísticas ─────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  final ProgressData data;
  final int grammarPercent;

  const _StatsGrid({required this.data, required this.grammarPercent});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stats = [
      _StatItem('${data.totalMessages}', l10n.progressMessages),
      _StatItem('${data.totalNewWords}', l10n.progressWords),
      _StatItem('${data.streak}', l10n.progressStreak),
      _StatItem('$grammarPercent%', l10n.progressAccuracy),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: stats.map((s) => _StatCard(item: s)).toList(),
    );
  }
}

class _StatItem {
  final String value;
  final String label;
  const _StatItem(this.value, this.label);
}

class _StatCard extends StatelessWidget {
  final _StatItem item;

  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.value,
            style: GoogleFonts.nunito(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Gráfico semanal ──────────────────────────────────────────────────────────

class _WeeklyChart extends StatelessWidget {
  final Map<DateTime, int> weeklyMessages;

  const _WeeklyChart({required this.weeklyMessages});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final days = [
      l10n.progressDaySun,
      l10n.progressDayMon,
      l10n.progressDayTue,
      l10n.progressDayWed,
      l10n.progressDayThu,
      l10n.progressDayFri,
      l10n.progressDaySat,
    ];

    final entries = weeklyMessages.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final dayLabels = entries.map((e) => days[e.key.weekday % 7]).toList();
    final maxY = entries
            .map((e) => e.value)
            .fold(0, (prev, v) => v > prev ? v : prev)
            .toDouble()
            .clamp(4.0, double.infinity);

    final barGroups = entries.asMap().entries.map((e) {
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: e.value.value.toDouble(),
            color: e.value.value > 0
                ? AppTheme.primary
                : AppTheme.borderColor,
            width: 18,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ],
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.progressWeeklyChart,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barGroups: barGroups,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= dayLabels.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            dayLabels[i],
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()} msgs',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Lista de erros frequentes ────────────────────────────────────────────────

class _CorrectionsList extends StatelessWidget {
  final List<DbCorrection> corrections;
  final bool isPremium;

  static const int _freeLimit = 3;

  const _CorrectionsList({
    required this.corrections,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final visible =
        isPremium ? corrections : corrections.take(_freeLimit).toList();
    final hasLocked = !isPremium && corrections.length > _freeLimit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.progressFrequentErrors,
          style: GoogleFonts.nunito(
            fontSize: 13,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.06 * 13,
          ),
        ),
        const SizedBox(height: 10),
        if (corrections.isEmpty)
          _EmptyCorrections()
        else ...[
          ...visible.map((c) => _CorrectionItem(correction: c)),
          if (hasLocked)
            PremiumGuard(
              child: Column(
                children: corrections
                    .skip(_freeLimit)
                    .map((c) => _CorrectionItem(correction: c))
                    .toList(),
              ),
            ),
        ],
      ],
    );
  }
}

class _EmptyCorrections extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor, width: 0.5),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check,
                  size: 18, color: AppTheme.primaryDark),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.progressNoErrors,
              style: GoogleFonts.nunito(
                  fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 2),
            Text(
              l10n.progressKeepPracticing,
              style: GoogleFonts.nunito(
                  fontSize: 13, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _CorrectionItem extends StatelessWidget {
  final DbCorrection correction;

  const _CorrectionItem({required this.correction});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isFrequent = correction.count >= 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isFrequent
              ? AppTheme.error.withValues(alpha: 0.3)
              : AppTheme.borderColor,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            correction.wrong,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.error,
              decoration: TextDecoration.lineThrough,
              decorationColor: AppTheme.error,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            correction.correct,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.progressOccurrences(correction.count),
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
