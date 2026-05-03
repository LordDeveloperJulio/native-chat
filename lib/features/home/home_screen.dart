import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/theme/app_theme.dart';
import '../chat/chat_screen.dart';
import 'home_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static List<_ModeOption> _getModes(AppLocalizations l10n) => [
    _ModeOption(
      'casual',
      l10n.modeCasual,
      '💬',
      l10n.modeCasualSubtitle,
      const Color(0xFFEDEBFF),
    ),
    _ModeOption(
      'business',
      l10n.modeBusiness,
      '💼',
      l10n.modeBusinessSubtitle,
      const Color(0xFFE8EEFF),
    ),
    _ModeOption(
      'travel',
      l10n.modeTravel,
      '✈️',
      l10n.modeTravelSubtitle,
      const Color(0xFFFFF8E0),
    ),
    _ModeOption(
      'interview',
      l10n.modeInterview,
      '🎯',
      l10n.modeInterviewSubtitle,
      const Color(0xFFF3EEFF),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final userAsync = ref.watch(userProfileProvider);

    return userAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Erro: $e'))),
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        return _HomeContent(user: user, modes: _getModes(l10n));
      },
    );
  }
}

class _HomeContent extends ConsumerWidget {
  final dynamic user;
  final List<_ModeOption> modes;

  const _HomeContent({required this.user, required this.modes});

  String _localizedLevelLabel(AppLocalizations l10n, String level) {
    switch (level) {
      case 'beginner':
        return l10n.homeLevelBeginner;
      case 'intermediate':
        return l10n.homeLevelIntermediate;
      case 'advanced':
        return l10n.homeLevelAdvanced;
      default:
        return level;
    }
  }

  String _localizedModeLabel(AppLocalizations l10n, String mode) {
    switch (mode) {
      case 'casual':
        return l10n.modeCasual;
      case 'business':
        return l10n.modeBusiness;
      case 'travel':
        return l10n.modeTravel;
      case 'interview':
        return l10n.modeInterview;
      default:
        return mode;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedMode = user.currentMode as String;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(context, l10n),
              const SizedBox(height: 20),
              _buildStreakCard(l10n),
              const SizedBox(height: 24),
              _buildSectionLabel(l10n.homeSectionLanguages),
              const SizedBox(height: 10),
              _buildLanguageGrid(context, l10n),
              const SizedBox(height: 24),
              _buildSectionLabel(l10n.homeSectionModes),
              const SizedBox(height: 10),
              _buildModeList(context, ref, selectedMode),
              const SizedBox(height: 24),
              _buildStartButton(context, ref, l10n),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? l10n.homeGreeting(user.name as String)
        : hour < 18
        ? l10n.homeGreetingAfternoon(user.name as String)
        : l10n.homeGreetingEvening(user.name as String);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: GoogleFonts.nunito(
            fontSize: 13,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          l10n.homeTitle,
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStreakCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.streak}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.homeStreakLabel,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('🔥', style: TextStyle(fontSize: 22)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.nunito(
        fontSize: 13,
        color: AppTheme.textSecondary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.06 * 13,
      ),
    );
  }

  double _levelProgress() {
    switch (user.level as String) {
      case 'beginner':
        return 0.2;
      case 'intermediate':
        return 0.6;
      case 'advanced':
        return 0.9;
      default:
        return 0.2;
    }
  }

  Widget _buildLanguageGrid(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _LanguageCard(
            flag: '🇺🇸',
            language: l10n.homeLanguageEnglish,
            level: _localizedLevelLabel(l10n, user.level as String),
            progress: _levelProgress(),
          ),
        ),
      ],
    );
  }

  Widget _buildModeList(
    BuildContext context,
    WidgetRef ref,
    String selectedMode,
  ) {
    return Column(
      children: modes
          .map(
            (m) => _ModeCard(
              option: m,
              isSelected: selectedMode == m.key,
              onTap: () =>
                  ref.read(userProfileProvider.notifier).updateMode(m.key),
            ),
          )
          .toList(),
    );
  }

  Widget _buildStartButton(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final modeLabel = _localizedModeLabel(l10n, user.currentMode as String);
    return ElevatedButton(
      onPressed: () async {
        await ref.read(userProfileProvider.notifier).recordSession();
        if (context.mounted) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const ChatScreen()));
        }
      },
      child: Text(l10n.homeStartButton(modeLabel)),
    );
  }
}

// ─── Language card ─────────────────────────────────────────────────────────────

class _LanguageCard extends StatelessWidget {
  final String flag;
  final String language;
  final String level;
  final double progress;
  final bool disabled;

  const _LanguageCard({
    required this.flag,
    required this.language,
    required this.level,
    required this.progress,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(flag, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(
            language,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: disabled ? AppTheme.textSecondary : AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            level,
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 3,
              backgroundColor: AppTheme.borderColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                disabled ? AppTheme.borderColor : AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mode card ────────────────────────────────────────────────────────────────

class _ModeCard extends StatelessWidget {
  final _ModeOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.borderColor,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryLight : option.bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(option.emoji, style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    option.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeOption {
  final String key;
  final String label;
  final String emoji;
  final String description;
  final Color bgColor;

  const _ModeOption(
    this.key,
    this.label,
    this.emoji,
    this.description,
    this.bgColor,
  );
}
