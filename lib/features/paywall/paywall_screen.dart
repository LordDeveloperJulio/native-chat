import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../core/purchases/purchase_provider.dart';
import '../../core/purchases/purchase_service.dart';
import '../../core/purchases/revenue_cat_config.dart';
import '../../shared/theme/app_theme.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  // 0 = mensal, 1 = anual (padrão)
  int _selectedPlanIndex = 1;
  bool _isLoading = false;

  Package? _monthlyPackage(List<Package> packages) => packages
      .where((p) => p.storeProduct.identifier == monthlyProductId)
      .firstOrNull;

  Package? _annualPackage(List<Package> packages) => packages
      .where((p) => p.storeProduct.identifier == annualProductId)
      .firstOrNull;

  Package? _selectedPackage(List<Package> packages) =>
      _selectedPlanIndex == 0
          ? _monthlyPackage(packages)
          : _annualPackage(packages);

  Future<void> _purchase(List<Package> packages) async {
    final package = _selectedPackage(packages);
    if (package == null) return;

    setState(() => _isLoading = true);
    final result =
        await ref.read(purchaseServiceProvider).purchasePackage(package);
    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (result.result) {
      case PurchaseResult.success:
        ref.invalidate(isPremiumProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Bem-vindo ao Premium! 🎉'),
            backgroundColor: AppTheme.primary,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.of(context).pop();
      case PurchaseResult.cancelled:
        break;
      case PurchaseResult.error:
      case PurchaseResult.alreadyPremium:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message ?? 'Erro ao processar pagamento.'),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
    }
  }

  Future<void> _restore() async {
    setState(() => _isLoading = true);
    final result = await ref.read(purchaseServiceProvider).restorePurchases();
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.result == PurchaseResult.success) {
      ref.invalidate(isPremiumProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Assinatura restaurada com sucesso!'),
          backgroundColor: AppTheme.primary,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Nenhuma assinatura encontrada.'),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(availablePackagesProvider);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _HeroSection(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: packagesAsync.when(
              loading: () => _buildContent(packages: [], loading: true),
              error: (e, _) => _buildContent(packages: [], loading: false),
              data: (packages) =>
                  _buildContent(packages: packages, loading: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent({
    required List<Package> packages,
    required bool loading,
  }) {
    final monthlyPrice = loading
        ? null
        : (_monthlyPackage(packages)?.storeProduct.priceString ?? 'R\$ 19,90');
    final annualPrice = loading
        ? null
        : (_annualPackage(packages)?.storeProduct.priceString ?? 'R\$ 149');
    final hasPackages = packages.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PlanCard(
          label: 'Mensal',
          price: monthlyPrice ?? 'R\$ 19,90',
          period: '/mês',
          isPriceLoading: loading,
          isHighlighted: false,
          isSelected: _selectedPlanIndex == 0,
          onTap: () => setState(() => _selectedPlanIndex = 0),
        ),
        const SizedBox(height: 10),
        _PlanCard(
          label: 'Anual',
          price: annualPrice ?? 'R\$ 149',
          period: '/ano',
          badge: 'Mais popular',
          savings: 'Economia de 38%',
          isPriceLoading: loading,
          isHighlighted: true,
          isSelected: _selectedPlanIndex == 1,
          onTap: () => setState(() => _selectedPlanIndex = 1),
        ),
        const SizedBox(height: 24),
        _BenefitsList(),
        const SizedBox(height: 24),
        _CtaButton(
          isLoading: _isLoading,
          enabled: !_isLoading && (hasPackages || !loading),
          onTap: hasPackages
              ? () => _purchase(packages)
              : null,
        ),
        const SizedBox(height: 10),
        const Center(
          child: Text(
            '7 dias grátis · Sem cobrança até lá',
            style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'Cancele a qualquer momento.',
            style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: _isLoading ? null : _restore,
            child: const Text(
              'Já é assinante? Restaurar compras',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                decoration: TextDecoration.underline,
                decorationColor: AppTheme.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ─── Hero ─────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.primary,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 28),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'LinguaAI Premium',
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Fale com fluência\nsem limites',
              style: GoogleFonts.nunito(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Conversas ilimitadas com a Aria,\nseu desenvolvimento acelerado.',
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.88),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Plan card ────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final String label;
  final String price;
  final String period;
  final String? badge;
  final String? savings;
  final bool isPriceLoading;
  final bool isHighlighted;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.label,
    required this.price,
    required this.period,
    this.badge,
    this.savings,
    required this.isPriceLoading,
    required this.isHighlighted,
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
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.borderColor,
            width: isSelected ? 2 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (badge != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                    ),
                  Text(
                    label,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  if (savings != null)
                    Text(
                      savings!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            isPriceLoading
                ? Container(
                    width: 64,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppTheme.borderColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price,
                        style: GoogleFonts.nunito(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          period,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
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
}

// ─── Benefits list ────────────────────────────────────────────────────────────

class _BenefitsList extends StatelessWidget {
  static const _benefits = [
    'Mensagens ilimitadas por dia',
    'Histórico completo de conversas',
    'Análises detalhadas de progresso',
    'Prática de pronúncia (em breve)',
    'Acesso offline (em breve)',
    'Suporte prioritário',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor, width: 0.5),
      ),
      child: Column(
        children: List.generate(_benefits.length * 2 - 1, (index) {
          if (index.isOdd) {
            return const Divider(height: 0, indent: 16, endIndent: 16);
          }
          final i = index ~/ 2;
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check,
                      size: 13, color: AppTheme.primaryDark),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _benefits[i],
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ─── CTA button ───────────────────────────────────────────────────────────────

class _CtaButton extends StatelessWidget {
  final bool isLoading;
  final bool enabled;
  final VoidCallback? onTap;

  const _CtaButton({
    required this.isLoading,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: enabled ? AppTheme.primary : AppTheme.borderColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
            : Text(
                'Começar agora',
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
