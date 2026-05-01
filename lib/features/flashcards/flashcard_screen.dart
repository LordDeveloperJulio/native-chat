import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/theme/app_theme.dart';
import 'flashcard_providers.dart';

import 'package:study_english/l10n/app_localizations.dart';

class FlashcardScreen extends ConsumerStatefulWidget {
  const FlashcardScreen({super.key});

  @override
  ConsumerState<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends ConsumerState<FlashcardScreen>
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

  void _flipCard() {
    if (_isFlipped) return; // só permite virar uma vez por card
    setState(() => _isFlipped = true);
    _flipCtrl.forward();
    ref.read(flashcardProvider.notifier).fetchDefinitionIfNeeded();
  }

  void _answer(bool knew) {
    _flipCtrl.reverse();
    setState(() => _isFlipped = false);
    ref.read(flashcardProvider.notifier).answer(knew);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flashcardProvider);

    if (state.isDone) {
      return _DoneScreen(
        knewCount: state.knewCount,
        didntKnowCount: state.didntKnowCount,
        total: state.totalOriginal,
        onRestart: () {
          ref.read(flashcardProvider.notifier).restart();
          _flipCtrl.reset();
          setState(() => _isFlipped = false);
        },
      );
    }

    if (state.isEmpty) {
      return _EmptyScreen();
    }

    final word = state.current!;
    final progress = state.totalOriginal > 0
        ? state.knewCount / state.totalOriginal
        : 0.0;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              knewCount: state.knewCount,
              remaining: state.deck.length,
              progress: progress,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _FlipCard(
                    controller: _flipCtrl,
                    isFlipped: _isFlipped,
                    onTap: _flipCard,
                    front: _CardFront(word: word.word, seenCount: word.seenCount),
                    back: _CardBack(
                      word: word.word,
                      definition: word.definition,
                      isLoading: state.isLoadingDefinition,
                      error: state.error,
                      onKnew: () => _answer(true),
                      onDidntKnow: () => _answer(false),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─── Top bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final int knewCount;
  final int remaining;
  final double progress;

  const _TopBar({
    required this.knewCount,
    required this.remaining,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.flashcardsTitle,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                l10n.flashcardsProgress(knewCount, remaining),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
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

// ─── Card front ───────────────────────────────────────────────────────────────

class _CardFront extends StatelessWidget {
  final String word;
  final int seenCount;

  const _CardFront({required this.word, required this.seenCount});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
              l10n.flashcardsVocabLabel,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryDark,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            word,
            style: GoogleFonts.nunito(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.flashcardsSeenInChat(seenCount),
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.touch_app_outlined,
                  size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 4),
              Text(
                l10n.flashcardsTapToReveal,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─── Card back ────────────────────────────────────────────────────────────────

class _CardBack extends StatelessWidget {
  final String word;
  final String? definition;
  final bool isLoading;
  final String? error;
  final VoidCallback onKnew;
  final VoidCallback onDidntKnow;

  const _CardBack({
    required this.word,
    required this.definition,
    required this.isLoading,
    required this.error,
    required this.onKnew,
    required this.onDidntKnow,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            word,
            style: GoogleFonts.nunito(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.primary,
            ),
          ),
          const Divider(height: 24),
          Expanded(
            child: _buildDefinitionBody(context),
          ),
          const SizedBox(height: 16),
          _buildAnswerButtons(context),
        ],
      ),
    );
  }

  Widget _buildDefinitionBody(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.flashcardsLoadingDef,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Text(
          error!,
          style: const TextStyle(fontSize: 13, color: AppTheme.error),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (definition == null) {
      return Center(
        child: Text(
          l10n.flashcardsNoDefinition,
          style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
      );
    }

    // Separa definição do exemplo (formato: "Def. Example: sentence.")
    final parts = definition!.split('Example:');
    final defText = parts[0].trim();
    final exampleText =
        parts.length > 1 ? parts[1].trim() : null;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            defText,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.textPrimary,
              height: 1.5,
            ),
          ),
          if (exampleText != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.correctionBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppTheme.correctionBorder, width: 0.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💬 ',
                      style: TextStyle(fontSize: 14)),
                  Expanded(
                    child: Text(
                      exampleText,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.correctionText,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnswerButtons(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onDidntKnow,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color(0xFFFCA5A5), width: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('↩', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    l10n.flashcardsReviewLater,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB91C1C),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: onKnew,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.4),
                    width: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('✓', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    l10n.flashcardsKnew,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
      height: MediaQuery.of(context).size.height * 0.55,
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

// ─── Done screen ──────────────────────────────────────────────────────────────

class _DoneScreen extends StatelessWidget {
  final int knewCount;
  final int didntKnowCount;
  final int total;
  final VoidCallback onRestart;

  const _DoneScreen({
    required this.knewCount,
    required this.didntKnowCount,
    required this.total,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pct = total > 0 ? (knewCount * 100 ~/ total) : 0;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
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
                    pct >= 80 ? '🏆' : pct >= 50 ? '👍' : '📚',
                    style: const TextStyle(fontSize: 38),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.flashcardsDone,
                style: GoogleFonts.nunito(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.flashcardsScore(pct),
                style: const TextStyle(
                  fontSize: 15,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StatPill(
                    emoji: '✓',
                    label: l10n.flashcardsKnewLabel,
                    value: knewCount,
                    color: AppTheme.primaryLight,
                    textColor: AppTheme.primaryDark,
                  ),
                  const SizedBox(width: 12),
                  _StatPill(
                    emoji: '↩',
                    label: l10n.flashcardsReviewLabel,
                    value: didntKnowCount,
                    color: const Color(0xFFFEE2E2),
                    textColor: const Color(0xFFB91C1C),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: onRestart,
                child: Text(l10n.flashcardsPlayAgain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String emoji;
  final String label;
  final int value;
  final Color color;
  final Color textColor;

  const _StatPill({
    required this.emoji,
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('📚', style: TextStyle(fontSize: 34)),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.flashcardsEmpty,
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderColor, width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.flashcardsHowItWorks,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _StepRow(
                        emoji: '💬',
                        color: const Color(0xFFE0F2FE),
                        text: l10n.flashcardsStep1,
                      ),
                      _StepDivider(),
                      _StepRow(
                        emoji: '✨',
                        color: AppTheme.primaryLight,
                        text: l10n.flashcardsStep2,
                      ),
                      _StepDivider(),
                      _StepRow(
                        emoji: '📖',
                        color: const Color(0xFFF0FDF4),
                        text: l10n.flashcardsStep3,
                      ),
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
}

class _StepRow extends StatelessWidget {
  final String emoji;
  final Color color;
  final String text;

  const _StepRow({
    required this.emoji,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 17)),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _StepDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 17, top: 4, bottom: 4),
      child: SizedBox(
        height: 14,
        child: VerticalDivider(
          color: AppTheme.borderColor,
          thickness: 1.5,
          width: 2,
        ),
      ),
    );
  }
}
