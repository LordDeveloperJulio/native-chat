import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/purchases/purchase_provider.dart';
import '../../features/paywall/paywall_screen.dart';
import '../theme/app_theme.dart';

import 'package:study_english/l10n/app_localizations.dart';

class PremiumGuard extends ConsumerWidget {
  final Widget child;
  final Widget? fallback;

  const PremiumGuard({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumAsync = ref.watch(isPremiumProvider);
    return isPremiumAsync.when(
      loading: () => fallback ?? const SizedBox.shrink(),
      // Em caso de erro de rede não bloqueamos o usuário
      error: (e, _) => child,
      data: (isPremium) =>
          isPremium ? child : (fallback ?? _PremiumLock(child: child)),
    );
  }
}

class _PremiumLock extends StatelessWidget {
  final Widget child;

  const _PremiumLock({required this.child});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.93),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 20,
                    color: AppTheme.primaryDark,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.premiumExclusive,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PaywallScreen(),
                    ),
                  ),
                  child: Text(
                    l10n.premiumViewPlans,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
