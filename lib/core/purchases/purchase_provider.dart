import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'purchase_service.dart';

final purchaseServiceProvider = Provider<PurchaseService>(
  (_) => PurchaseService(),
);

final isPremiumProvider = FutureProvider<bool>((ref) {
  return ref.read(purchaseServiceProvider).isPremium();
});

final availablePackagesProvider = FutureProvider<List<Package>>((ref) {
  return ref.read(purchaseServiceProvider).getAvailablePackages();
});
