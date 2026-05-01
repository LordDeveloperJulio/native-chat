import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/db/database.dart';
import 'core/purchases/purchase_service.dart';
import 'features/main/main_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'shared/theme/app_theme.dart';

import 'package:study_english/l10n/app_localizations.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp();
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

  FlutterNativeSplash.remove();

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
      title: 'NativeChat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return const Locale('en');
        for (final supported in supportedLocales) {
          if (supported.languageCode == locale.languageCode) {
            return supported;
          }
        }
        return const Locale('en');
      },
      home: showOnboarding ? const OnboardingScreen() : const MainScreen(),
    );
  }
}
