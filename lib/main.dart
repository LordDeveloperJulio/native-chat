import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/db/database.dart';
import 'core/purchases/purchase_service.dart';
import 'features/main/main_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final prefs = await SharedPreferences.getInstance();
  final onboardingDone = prefs.getBool('onboarding_done') ?? false;

  // Inicializa RevenueCat sem bloquear o app em caso de falha
  try {
    final db = AppDatabase();
    final dbUser = await db.getUser();
    await db.close();
    final userId = dbUser?.id.toString() ?? 'anonymous';
    await PurchaseService().initialize(userId);
  } catch (e) {
    debugPrint('[RevenueCat] Falha na inicialização: $e');
  }

  runApp(ProviderScope(
    child: LinguaAIApp(showOnboarding: !onboardingDone),
  ));
}

class LinguaAIApp extends StatelessWidget {
  final bool showOnboarding;

  const LinguaAIApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinguaAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: showOnboarding ? const OnboardingScreen() : const MainScreen(),
    );
  }
}
