import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/db/database.dart';
import 'core/purchases/purchase_service.dart';
import 'firebase_options.dart';
import 'features/main/main_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'l10n/app_localizations.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  bool onboardingDone = false;

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await dotenv.load(fileName: '.env');
    final prefs = await SharedPreferences.getInstance();
    onboardingDone = prefs.getBool('onboarding_done') ?? false;
  } catch (e) {
    debugPrint('[App] Falha na inicialização: $e');
  }

  String userId = 'anonymous';
  try {
    final db = AppDatabase();
    final dbUser = await db.getUser();
    await db.close();
    userId = dbUser?.id.toString() ?? 'anonymous';
  } catch (e) {
    debugPrint('[DB] Falha ao buscar userId para RevenueCat: $e');
  }

  try {
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
