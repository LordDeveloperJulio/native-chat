import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/db/database.dart';
import '../../shared/theme/app_theme.dart';
import '../home/home_providers.dart';
import '../main/main_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _nameController = TextEditingController();
  String? _selectedLevel;
  String? _selectedMode;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  bool get _canProceed {
    switch (_currentPage) {
      case 0:
        return _nameController.text.trim().isNotEmpty;
      case 1:
        return _selectedLevel != null;
      case 2:
        return _selectedMode != null;
      default:
        return false;
    }
  }

  void _goNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final db = ref.read(databaseProvider);
      await db.createUser(UsersCompanion(
        name: Value(_nameController.text.trim()),
        level: Value(_selectedLevel!),
        currentMode: Value(_selectedMode!),
      ));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_done', true);
      await prefs.setString('user_name', _nameController.text.trim());
      await prefs.setString('user_level', _selectedLevel!);
      await prefs.setString('user_mode', _selectedMode!);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar seus dados. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            _OnboardingDots(current: _currentPage),
            const SizedBox(height: 8),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _NamePage(
                    controller: _nameController,
                    onChanged: () => setState(() {}),
                  ),
                  _LevelPage(
                    selected: _selectedLevel,
                    onSelect: (v) => setState(() => _selectedLevel = v),
                  ),
                  _ModePage(
                    selected: _selectedMode,
                    onSelect: (v) => setState(() => _selectedMode = v),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: ElevatedButton(
                onPressed: _canProceed && !_isLoading ? _goNext : null,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _currentPage == 2 ? 'Começar agora!' : 'Continuar',
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Progress dots ────────────────────────────────────────────────────────────

class _OnboardingDots extends StatelessWidget {
  final int current;
  const _OnboardingDots({required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? AppTheme.primary : Colors.transparent,
            border: Border.all(
              color: active ? AppTheme.primary : AppTheme.borderColor,
              width: 1.5,
            ),
          ),
        );
      }),
    );
  }
}

// ─── Page 1: Name ─────────────────────────────────────────────────────────────

class _NamePage extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _NamePage({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          const Center(child: Text('🌍', style: TextStyle(fontSize: 64))),
          const SizedBox(height: 32),
          Text(
            'Olá! Como você se chama?',
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Vou usar seu nome para personalizar\nsua experiência',
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          TextField(
            controller: controller,
            onChanged: (_) => onChanged(),
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Seu nome',
              filled: true,
              fillColor: AppTheme.cardSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppTheme.primary, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Page 2: Level ────────────────────────────────────────────────────────────

class _LevelPage extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;

  const _LevelPage({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          const Center(child: Text('📊', style: TextStyle(fontSize: 64))),
          const SizedBox(height: 32),
          Text(
            'Qual é seu nível de inglês?',
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _SelectableCard(
            emoji: '🌱',
            label: 'Iniciante',
            description: 'Estou começando agora',
            isSelected: selected == 'beginner',
            onTap: () => onSelect('beginner'),
          ),
          const SizedBox(height: 10),
          _SelectableCard(
            emoji: '📈',
            label: 'Intermediário',
            description: 'Já conheço o básico',
            isSelected: selected == 'intermediate',
            onTap: () => onSelect('intermediate'),
          ),
          const SizedBox(height: 10),
          _SelectableCard(
            emoji: '🚀',
            label: 'Avançado',
            description: 'Quero me aperfeiçoar',
            isSelected: selected == 'advanced',
            onTap: () => onSelect('advanced'),
          ),
        ],
      ),
    );
  }
}

// ─── Page 3: Mode ─────────────────────────────────────────────────────────────

class _ModePage extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;

  const _ModePage({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          const Center(child: Text('🎯', style: TextStyle(fontSize: 64))),
          const SizedBox(height: 32),
          Text(
            'Como quer praticar?',
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _ModeGridCard(
                  emoji: '💬',
                  label: 'Casual',
                  isSelected: selected == 'casual',
                  onTap: () => onSelect('casual'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ModeGridCard(
                  emoji: '💼',
                  label: 'Negócios',
                  isSelected: selected == 'business',
                  onTap: () => onSelect('business'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ModeGridCard(
                  emoji: '✈️',
                  label: 'Viagem',
                  isSelected: selected == 'travel',
                  onTap: () => onSelect('travel'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ModeGridCard(
                  emoji: '🎯',
                  label: 'Entrevista',
                  isSelected: selected == 'interview',
                  onTap: () => onSelect('interview'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Shared components ────────────────────────────────────────────────────────

class _SelectableCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableCard({
    required this.emoji,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.borderColor,
            width: isSelected ? 2 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeGridCard extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeGridCard({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.borderColor,
            width: isSelected ? 2 : 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color:
                    isSelected ? AppTheme.primary : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
