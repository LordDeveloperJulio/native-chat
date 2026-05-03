import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'revenue_cat_config.dart';

enum PurchaseResult { success, cancelled, error, alreadyPremium }

class PurchaseError {
  final PurchaseResult result;
  final String? message;

  const PurchaseError({required this.result, this.message});
}

class PurchaseService {
  Future<void> initialize(String userId) async {
    if (Platform.isIOS) return;
    try {
      if (kDebugMode) {
        await Purchases.setLogLevel(LogLevel.debug);
      }
      final configuration = PurchasesConfiguration(googleApiKey)
        ..appUserID = userId;
      await Purchases.configure(configuration);
    } catch (e) {
      debugPrint('[RevenueCat] Erro ao inicializar: $e');
    }
  }

  Future<bool> isPremium() async {
    if (Platform.isIOS) return false;
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey(entitlementId);
    } catch (_) {
      return false;
    }
  }

  Future<List<Package>> getAvailablePackages() async {
    if (Platform.isIOS) return [];
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current?.availablePackages ?? [];
    } on PlatformException {
      return [];
    }
  }

  Future<PurchaseError> purchasePackage(Package package) async {
    if (Platform.isIOS) {
      return const PurchaseError(
        result: PurchaseResult.error,
        message: 'Compras não disponíveis no iOS no momento.',
      );
    }
    try {
      final customerInfo = await Purchases.purchasePackage(package);
      final active =
          customerInfo.entitlements.active.containsKey(entitlementId);
      return PurchaseError(
        result: active ? PurchaseResult.success : PurchaseResult.error,
        message:
            active ? null : 'Erro ao ativar assinatura. Tente novamente.',
      );
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return const PurchaseError(result: PurchaseResult.cancelled);
      }
      return PurchaseError(
        result: PurchaseResult.error,
        message: _mapError(code),
      );
    }
  }

  Future<PurchaseError> restorePurchases() async {
    if (Platform.isIOS) {
      return const PurchaseError(
        result: PurchaseResult.error,
        message: 'Restauração não disponível no iOS no momento.',
      );
    }
    try {
      final customerInfo = await Purchases.restorePurchases();
      final active =
          customerInfo.entitlements.active.containsKey(entitlementId);
      if (active) return const PurchaseError(result: PurchaseResult.success);
      return const PurchaseError(
        result: PurchaseResult.error,
        message: 'Nenhuma assinatura ativa encontrada.',
      );
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      return PurchaseError(
        result: PurchaseResult.error,
        message: _mapError(code),
      );
    }
  }

  String _mapError(PurchasesErrorCode code) {
    switch (code) {
      case PurchasesErrorCode.networkError:
        return 'Sem conexão. Verifique sua internet e tente novamente.';
      case PurchasesErrorCode.productNotAvailableForPurchaseError:
        return 'Produto não disponível no momento.';
      case PurchasesErrorCode.purchaseNotAllowedError:
        return 'Compras não permitidas neste dispositivo.';
      case PurchasesErrorCode.receiptAlreadyInUseError:
        return 'Esta conta já possui uma assinatura ativa.';
      case PurchasesErrorCode.invalidCredentialsError:
        return 'Erro de configuração. Contate o suporte.';
      case PurchasesErrorCode.storeProblemError:
        return 'Problema com a loja. Tente novamente mais tarde.';
      default:
        return 'Erro ao processar pagamento. Tente novamente.';
    }
  }
}
