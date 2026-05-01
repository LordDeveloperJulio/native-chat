import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/theme/app_theme.dart';
import 'deck_providers.dart';

class DeckStudyScreen extends ConsumerStatefulWidget {
  final DbFlashcardDeck deck;

  const DeckStudyScreen({super.key, required this.deck});

  @override
  ConsumerState<DeckStudyScreen> createState() => _DeckStudyScreenState();
}

class _DeckStudyScreenState extends ConsumerState<DeckStudyScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipCtrl;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _flipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    super.dispose();
  }

  void _flip() {
    if (_isFlipped) return;
    setState(() => _isFlipped = true);
    _flipCtrl.forward();
  }

  Future<void> _rate(int quality) async {
    await ref.read(deckStudyProvider(widget.deck.id).notifier).rate(quality);
    _flipCtrl.reverse();
    setState(() => _isFlipped = false);
    ref.read(decksProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(deckStudyProvider(widget.deck.id));

    if (state.isDone || (state.totalSession == 0 && !state.isDone)) {
      return _buildDoneOrEmpty(context, l10n, state);
    }

    final card = state.current!;
    final remaining = state.queue.length;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              title: widget.deck.title,
              remaining: remaining,
              total: state.totalSession,
              progress: 1.0 - (remaining / state.totalSession),
              remainingLabel: l10n.deckStudyRemaining(remaining),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _FlipCard(
                    controller: _flipCtrl,
                    isFlipped: _isFlipped,
                    onTap: _flip,
                    front: _CardFront(
                      front: card.front,
                      questionLabel: l10n.deckStudyQuestion,
                    ),
                    back: _CardBack(
                      front: card.front,
                      back: card.back,
                      howWasIt: l10n.deckStudyHowWasIt,
                      ratingLabels: (
                        again: l10n.deckStudyAgain,
                        hard: l10n.deckStudyHard,
                        good: l10n.deckStudyGood,
                        easy: l10n.deckStudyEasy,
                      ),
                      ratingSubLabels: (
                        again: l10n.deckStudyAgainSub,
                        hard: l10n.deckStudyHardSub,
                        good: l10n.deckStudyGoodSub,
                        easy: l10n.deckStudyEasySub,
                      ),
                      onRate: _isFlipped ? _rate : null,
                    ),
                  ),
                ),
              ),
            ),
            if (!_isFlipped)
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.touch_app_outlined,
                        size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      l10n.deckStudyTapToReveal,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            else
              const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneOrEmpty(
      BuildContext context, AppLocalizations l10n, StudyState state) {
    final isDone = state.isDone;
    final hasCards = state.totalSession > 0;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back,
                      color: AppTheme.textPrimary),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          isDone && hasCards ? '🏆' : '✅',
                          style: const TextStyle(fontSize: 38),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      isDone && hasCards
                          ? l10n.deckStudyDoneTitle
                          : l10n.deckStudyUpToDateTitle,
                      style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isDone && hasCards
                          ? l10n.deckStudyDoneBody(state.totalSession)
                          : l10n.deckStudyNoDueCards,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (isDone && hasCards) ...[
                      const SizedBox(height: 28),
                      _StatsRow(
                        again: state.againCount,
                        hard: state.hardCount,
                        good: state.goodCount,
                        easy: state.easyCount,
                        labels: (
                          again: l10n.deckStudyAgain,
                          hard: l10n.deckStudyHard,
                          good: l10n.deckStudyGood,
                          easy: l10n.deckStudyEasy,
                        ),
                      ),
                    ],
                    const SizedBox(height: 36),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.deckStudyBackButton),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Top bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String title;
  final int remaining;
  final int total;
  final double progress;
  final String remainingLabel;
  final VoidCallback onBack;

  const _TopBar({
    required this.title,
    required this.remaining,
    required this.total,
    required this.progress,
    required this.remainingLabel,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: const Icon(Icons.arrow_back,
                    color: AppTheme.textPrimary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                remainingLabel,
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: AppTheme.borderColor,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Flip card ────────────────────────────────────────────────────────────────

class _FlipCard extends StatelessWidget {
  final AnimationController controller;
  final bool isFlipped;
  final VoidCallback onTap;
  final Widget front;
  final Widget back;

  const _FlipCard({
    required this.controller,
    required this.isFlipped,
    required this.onTap,
    required this.front,
    required this.back,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final angle = controller.value * pi;
        final showFront = controller.value <= 0.5;

        return GestureDetector(
          onTap: onTap,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: showFront
                ? front
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: back,
                  ),
          ),
        );
      },
    );
  }
}

// ─── Card shell ───────────────────────────────────────────────────────────────

class _CardShell extends StatelessWidget {
  final Widget child;

  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.58,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: AppTheme.borderColor, width: 0.5),
      ),
      child: child,
    );
  }
}

// ─── Card front ───────────────────────────────────────────────────────────────

class _CardFront extends StatelessWidget {
  final String front;
  final String questionLabel;

  const _CardFront({required this.front, required this.questionLabel});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              questionLabel,
              style: GoogleFonts.nunito(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryDark,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            front,
            style: GoogleFonts.nunito(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Card back ────────────────────────────────────────────────────────────────

typedef _RatingLabels = ({
  String again,
  String hard,
  String good,
  String easy
});

class _CardBack extends StatelessWidget {
  final String front;
  final String back;
  final String howWasIt;
  final _RatingLabels ratingLabels;
  final _RatingLabels ratingSubLabels;
  final void Function(int quality)? onRate;

  const _CardBack({
    required this.front,
    required this.back,
    required this.howWasIt,
    required this.ratingLabels,
    required this.ratingSubLabels,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            front,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
          const Divider(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                back,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  color: AppTheme.textPrimary,
                  height: 1.6,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            howWasIt,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          _RatingButtons(
            labels: ratingLabels,
            subLabels: ratingSubLabels,
            onRate: onRate,
          ),
        ],
      ),
    );
  }
}

// ─── Rating buttons (SM-2) ────────────────────────────────────────────────────

class _RatingButtons extends StatelessWidget {
  final _RatingLabels labels;
  final _RatingLabels subLabels;
  final void Function(int quality)? onRate;

  const _RatingButtons({
    required this.labels,
    required this.subLabels,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RatingBtn(
          label: labels.again,
          sublabel: subLabels.again,
          color: const Color(0xFFFEE2E2),
          textColor: const Color(0xFFB91C1C),
          borderColor: const Color(0xFFFCA5A5),
          onTap: onRate != null ? () => onRate!(0) : null,
        ),
        const SizedBox(width: 6),
        _RatingBtn(
          label: labels.hard,
          sublabel: subLabels.hard,
          color: const Color(0xFFFFF7ED),
          textColor: const Color(0xFF9A3412),
          borderColor: const Color(0xFFFDBA74),
          onTap: onRate != null ? () => onRate!(1) : null,
        ),
        const SizedBox(width: 6),
        _RatingBtn(
          label: labels.good,
          sublabel: subLabels.good,
          color: AppTheme.primaryLight,
          textColor: AppTheme.primaryDark,
          borderColor: AppTheme.primary.withValues(alpha: 0.3),
          onTap: onRate != null ? () => onRate!(2) : null,
        ),
        const SizedBox(width: 6),
        _RatingBtn(
          label: labels.easy,
          sublabel: subLabels.easy,
          color: const Color(0xFFF0FDF4),
          textColor: const Color(0xFF166534),
          borderColor: const Color(0xFF86EFAC),
          onTap: onRate != null ? () => onRate!(3) : null,
        ),
      ],
    );
  }
}

class _RatingBtn extends StatelessWidget {
  final String label;
  final String sublabel;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final VoidCallback? onTap;

  const _RatingBtn({
    required this.label,
    required this.sublabel,
    required this.color,
    required this.textColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 0.5),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              Text(
                sublabel,
                style: TextStyle(
                    fontSize: 9, color: textColor.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Stats row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final int again;
  final int hard;
  final int good;
  final int easy;
  final _RatingLabels labels;

  const _StatsRow({
    required this.again,
    required this.hard,
    required this.good,
    required this.easy,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatChip(
            label: labels.again,
            value: again,
            color: const Color(0xFFFEE2E2),
            textColor: const Color(0xFFB91C1C)),
        const SizedBox(width: 8),
        _StatChip(
            label: labels.hard,
            value: hard,
            color: const Color(0xFFFFF7ED),
            textColor: const Color(0xFF9A3412)),
        const SizedBox(width: 8),
        _StatChip(
            label: labels.good,
            value: good,
            color: AppTheme.primaryLight,
            textColor: AppTheme.primaryDark),
        const SizedBox(width: 8),
        _StatChip(
            label: labels.easy,
            value: easy,
            color: const Color(0xFFF0FDF4),
            textColor: const Color(0xFF166534)),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final Color textColor;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: textColor),
          ),
        ],
      ),
    );
  }
}
