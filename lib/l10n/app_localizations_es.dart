// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'NativeChat';

  @override
  String get onboardingPage1Title => '¡Hola! ¿Cómo te llamas?';

  @override
  String get onboardingPage1Subtitle =>
      'Usaré tu nombre para personalizar tu experiencia';

  @override
  String get onboardingPage1FieldLabel => 'Tu nombre';

  @override
  String get onboardingPage1Button => 'Continuar';

  @override
  String get onboardingPage2Title => '¿Cuál es tu nivel de inglés?';

  @override
  String get onboardingPage2Subtitle =>
      'Adaptaré las conversaciones a tu nivel';

  @override
  String get onboardingPage2Button => 'Continuar';

  @override
  String get levelBeginner => 'Principiante';

  @override
  String get levelBeginnerSubtitle => 'Estoy empezando';

  @override
  String get levelIntermediate => 'Intermedio';

  @override
  String get levelIntermediateSubtitle => 'Ya conozco lo básico';

  @override
  String get levelAdvanced => 'Avanzado';

  @override
  String get levelAdvancedSubtitle => 'Quiero perfeccionar mi inglés';

  @override
  String get onboardingPage3Title => '¿Cómo quieres practicar?';

  @override
  String get onboardingPage3Subtitle =>
      'Puedes cambiar esto en cualquier momento';

  @override
  String get onboardingPage3Button => '¡Vamos!';

  @override
  String get modeCasual => 'Casual';

  @override
  String get modeCasualSubtitle => 'Conversaciones cotidianas';

  @override
  String get modeBusiness => 'Negocios';

  @override
  String get modeBusinessSubtitle => 'Correos y reuniones';

  @override
  String get modeTravel => 'Viaje';

  @override
  String get modeTravelSubtitle => 'Aeropuerto, hotel, direcciones';

  @override
  String get modeInterview => 'Entrevista';

  @override
  String get modeInterviewSubtitle => 'Preparación para empleo';

  @override
  String homeGreeting(String name) {
    return 'Buenos días, $name';
  }

  @override
  String homeGreetingAfternoon(String name) {
    return 'Buenas tardes, $name';
  }

  @override
  String homeGreetingEvening(String name) {
    return 'Buenas noches, $name';
  }

  @override
  String get homeTitle => '¿Listo para practicar hoy?';

  @override
  String get homeStreakLabel => 'días seguidos';

  @override
  String get homeSectionLanguages => 'TUS IDIOMAS';

  @override
  String get homeSectionModes => 'MODOS DE CONVERSACIÓN';

  @override
  String get homeLevelBeginner => 'Principiante';

  @override
  String get homeLevelIntermediate => 'Intermedio';

  @override
  String get homeLevelAdvanced => 'Avanzado';

  @override
  String get homeLanguageEnglish => 'Inglés';

  @override
  String get homeLanguageSpanish => 'Español';

  @override
  String get homeComingSoon => 'Próximamente';

  @override
  String homeStartButton(String mode) {
    return 'Iniciar conversación · $mode';
  }

  @override
  String get chatHeaderSubtitle => 'Aria — Tutora IA';

  @override
  String get chatInputHint => 'Responde en inglés...';

  @override
  String chatFreeMessages(int used, int total) {
    return '$used de $total mensajes gratuitos usados hoy';
  }

  @override
  String get chatLimitReached =>
      'Límite diario alcanzado. ¡Actualiza para continuar!';

  @override
  String get chatLimitButton => 'Ver planes';

  @override
  String get chatCorrectionLabel => 'Pequeña corrección';

  @override
  String get chatNewWordsLabel => 'Palabras nuevas';

  @override
  String get chatErrorTimeout =>
      'Tiempo de conexión agotado. Inténtalo de nuevo.';

  @override
  String get chatErrorNetwork => 'Sin conexión. Verifica tu internet.';

  @override
  String get chatErrorGeneric => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get chatEmptyTitle => '¡Hola! Soy Aria, tu tutora de inglés.';

  @override
  String get chatEmptySubtitle => '¡Escribe algo en inglés para empezar!';

  @override
  String get progressTitle => 'Tu progreso';

  @override
  String get progressMessages => 'mensajes enviados';

  @override
  String get progressWords => 'palabras nuevas';

  @override
  String get progressStreak => 'días seguidos';

  @override
  String get progressAccuracy => 'gramática correcta';

  @override
  String get progressWeeklyChart => 'Actividad esta semana';

  @override
  String get progressFrequentErrors => 'ERRORES FRECUENTES';

  @override
  String get progressDayMon => 'Lun';

  @override
  String get progressDayTue => 'Mar';

  @override
  String get progressDayWed => 'Mié';

  @override
  String get progressDayThu => 'Jue';

  @override
  String get progressDayFri => 'Vie';

  @override
  String get progressDaySat => 'Sáb';

  @override
  String get progressDaySun => 'Dom';

  @override
  String get progressNoErrors => 'Sin errores registrados aún.';

  @override
  String get progressKeepPracticing => '¡Sigue practicando!';

  @override
  String progressOccurrences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ocurrencias',
      one: '1 ocurrencia',
    );
    return '$_temp0';
  }

  @override
  String get paywallBadge => 'NativeChat Premium';

  @override
  String get paywallTitle => 'Habla con fluidez\nsin límites';

  @override
  String get paywallSubtitle =>
      'Conversaciones ilimitadas, todos los modos y feedback avanzado de IA';

  @override
  String get paywallPlanMonthly => 'Mensual';

  @override
  String get paywallPlanAnnual => 'Anual';

  @override
  String get paywallPlanPopular => 'Más popular';

  @override
  String get paywallPlanMonthlyPrice => 'R\$ 19,90';

  @override
  String get paywallPlanMonthlyPeriod => '/ mes';

  @override
  String get paywallPlanAnnualPrice => 'R\$ 149';

  @override
  String get paywallPlanAnnualPeriod => '/ año';

  @override
  String get paywallPlanAnnualSavings =>
      'Equivale a R\$ 12,40/mes · Ahorra 38%';

  @override
  String get paywallCancelAnytime => 'Cancela cuando quieras';

  @override
  String get paywallFeature1 => 'Conversaciones ilimitadas con IA';

  @override
  String get paywallFeature2 => 'Todos los modos de conversación';

  @override
  String get paywallFeature3 => 'Feedback avanzado post-conversación';

  @override
  String get paywallFeature4 => 'Informe semanal de evolución';

  @override
  String get paywallFeature5 => 'Práctica de pronunciación';

  @override
  String get paywallCTA => 'Empezar ahora';

  @override
  String get paywallTrial => '7 días gratis · Sin cobro hasta entonces';

  @override
  String get paywallRestore => '¿Ya eres suscriptor? Restaurar compras';

  @override
  String get paywallSuccessMessage => '¡Bienvenido a Premium! 🎉';

  @override
  String get paywallRestoredMessage => '¡Suscripción restaurada con éxito!';

  @override
  String get paywallCancelledMessage => 'Compra cancelada.';

  @override
  String get navHome => 'Inicio';

  @override
  String get navChat => 'Chat';

  @override
  String get navFlashcards => 'Flashcards';

  @override
  String get navProgress => 'Progreso';

  @override
  String get navPremium => 'Premium';

  @override
  String get flashcardsTitle => 'Flashcards';

  @override
  String flashcardsProgress(int knew, int remaining) {
    return '$knew conocidas · $remaining restantes';
  }

  @override
  String get flashcardsVocabLabel => 'VOCABULARIO';

  @override
  String flashcardsSeenInChat(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Apareció $count veces en el chat',
      one: 'Apareció $count vez en el chat',
    );
    return '$_temp0';
  }

  @override
  String get flashcardsTapToReveal => 'Toca para ver la definición';

  @override
  String get flashcardsLoadingDef => 'Cargando definición…';

  @override
  String get flashcardsNoDefinition => 'Definición no disponible.';

  @override
  String get flashcardsReviewLater => 'Revisar después';

  @override
  String get flashcardsKnew => '¡Lo sabía!';

  @override
  String get flashcardsDone => '¡Sesión completada!';

  @override
  String flashcardsScore(int pct) {
    return 'Acertaste el $pct% de las palabras';
  }

  @override
  String get flashcardsKnewLabel => 'Sabía';

  @override
  String get flashcardsReviewLabel => 'A revisar';

  @override
  String get flashcardsPlayAgain => 'Practicar de nuevo';

  @override
  String get flashcardsEmpty => 'Sin palabras aún';

  @override
  String get flashcardsEmptySubtitle =>
      'Practica en el chat y Aria destacará palabras para que revises aquí.';

  @override
  String get flashcardsHowItWorks => 'Cómo funciona';

  @override
  String get flashcardsStep1 => 'Chatea con Aria';

  @override
  String get flashcardsStep2 => 'Aria detecta vocabulario nuevo';

  @override
  String get flashcardsStep3 => 'Repasa las palabras aquí en flashcards';

  @override
  String deckStudyRemaining(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining cartas restantes',
      one: '1 carta restante',
    );
    return '$_temp0';
  }

  @override
  String get deckStudyQuestion => 'PREGUNTA';

  @override
  String get deckStudyHowWasIt => '¿Cómo te fue?';

  @override
  String get deckStudyAgain => 'De nuevo';

  @override
  String get deckStudyHard => 'Difícil';

  @override
  String get deckStudyGood => 'Bien';

  @override
  String get deckStudyEasy => 'Fácil';

  @override
  String get deckStudyAgainSub => '< 1 min';

  @override
  String get deckStudyHardSub => '6 min';

  @override
  String get deckStudyGoodSub => '10 min';

  @override
  String get deckStudyEasySub => '4 días';

  @override
  String get deckStudyTapToReveal => 'Toca para revelar';

  @override
  String get deckStudyDoneTitle => '¡Sesión completada!';

  @override
  String get deckStudyUpToDateTitle => '¡Todo al día!';

  @override
  String deckStudyDoneBody(int count) {
    return 'Repasaste $count tarjetas en esta sesión.';
  }

  @override
  String get deckStudyNoDueCards =>
      'No hay tarjetas para repasar ahora. ¡Vuelve más tarde!';

  @override
  String get deckStudyBackButton => 'Volver al mazo';

  @override
  String get decksTitle => 'Mis Mazos';

  @override
  String get decksSubtitle => 'Repasa y estudia tus mazos de flashcards';

  @override
  String decksCardCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tarjetas',
      one: '1 tarjeta',
    );
    return '$_temp0';
  }

  @override
  String decksDueCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pendientes',
      one: '1 pendiente',
    );
    return '$_temp0';
  }

  @override
  String get decksUpToDate => 'Al día';

  @override
  String get decksDeleteTitle => '¿Eliminar mazo?';

  @override
  String decksDeleteBody(int count, String title) {
    return '¿Eliminar \"$title\" con $count tarjetas? Esta acción no se puede deshacer.';
  }

  @override
  String get decksDeleteCancel => 'Cancelar';

  @override
  String get decksDeleteConfirm => 'Eliminar';

  @override
  String get decksEmptyTitle => 'Sin mazos aún';

  @override
  String get decksEmptyBody =>
      'Crea un mazo y generaré flashcards sobre cualquier tema de inglés para ti.';

  @override
  String get decksEmptyButton => 'Crear primer mazo';

  @override
  String get decksGenerateError =>
      'Error al generar el mazo. Inténtalo de nuevo.';

  @override
  String get decksNewDeckTitle => 'Nuevo mazo';

  @override
  String get decksNewDeckSubtitle =>
      'Elige un tema y crearé las tarjetas para ti';

  @override
  String get decksTopicHint => 'ej: Pasado Simple, Verbos Frasales…';

  @override
  String get decksHowManyCards => '¿CUÁNTAS TARJETAS?';

  @override
  String get decksCardsUnit => 'tarjetas';

  @override
  String get decksGenerateButton => 'Generar mazo';

  @override
  String get premiumExclusive => 'Exclusivo Premium';

  @override
  String get premiumViewPlans => 'Ver planes Premium';

  @override
  String get errorUnknown => 'Error inesperado. Inténtalo de nuevo.';

  @override
  String get errorNoConnection => 'Sin conexión a internet.';

  @override
  String get errorTimeout => 'Tiempo de solicitud agotado.';
}
