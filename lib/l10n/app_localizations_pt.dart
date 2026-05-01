// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'NativeChat';

  @override
  String get onboardingPage1Title => 'Olá! Como você se chama?';

  @override
  String get onboardingPage1Subtitle =>
      'Vou usar seu nome para personalizar sua experiência';

  @override
  String get onboardingPage1FieldLabel => 'Seu nome';

  @override
  String get onboardingPage1Button => 'Continuar';

  @override
  String get onboardingPage2Title => 'Qual é seu nível de inglês?';

  @override
  String get onboardingPage2Subtitle => 'Vou adaptar as conversas ao seu nível';

  @override
  String get onboardingPage2Button => 'Continuar';

  @override
  String get levelBeginner => 'Iniciante';

  @override
  String get levelBeginnerSubtitle => 'Estou começando agora';

  @override
  String get levelIntermediate => 'Intermediário';

  @override
  String get levelIntermediateSubtitle => 'Já conheço o básico';

  @override
  String get levelAdvanced => 'Avançado';

  @override
  String get levelAdvancedSubtitle => 'Quero me aperfeiçoar';

  @override
  String get onboardingPage3Title => 'Como quer praticar?';

  @override
  String get onboardingPage3Subtitle =>
      'Você pode mudar isso a qualquer momento';

  @override
  String get onboardingPage3Button => 'Vamos lá!';

  @override
  String get modeCasual => 'Casual';

  @override
  String get modeCasualSubtitle => 'Conversas do cotidiano';

  @override
  String get modeBusiness => 'Negócios';

  @override
  String get modeBusinessSubtitle => 'E-mails e reuniões';

  @override
  String get modeTravel => 'Viagem';

  @override
  String get modeTravelSubtitle => 'Aeroporto, hotel, direções';

  @override
  String get modeInterview => 'Entrevista';

  @override
  String get modeInterviewSubtitle => 'Preparação para emprego';

  @override
  String homeGreeting(String name) {
    return 'Bom dia, $name';
  }

  @override
  String homeGreetingAfternoon(String name) {
    return 'Boa tarde, $name';
  }

  @override
  String homeGreetingEvening(String name) {
    return 'Boa noite, $name';
  }

  @override
  String get homeTitle => 'Vamos praticar hoje?';

  @override
  String get homeStreakLabel => 'dias seguidos';

  @override
  String get homeSectionLanguages => 'SEUS IDIOMAS';

  @override
  String get homeSectionModes => 'MODOS DE CONVERSA';

  @override
  String get homeLevelBeginner => 'Iniciante';

  @override
  String get homeLevelIntermediate => 'Intermediário';

  @override
  String get homeLevelAdvanced => 'Avançado';

  @override
  String get homeLanguageEnglish => 'Inglês';

  @override
  String get homeLanguageSpanish => 'Espanhol';

  @override
  String get homeComingSoon => 'Em breve';

  @override
  String homeStartButton(String mode) {
    return 'Iniciar conversa · $mode';
  }

  @override
  String get chatHeaderSubtitle => 'Aria — Tutora IA';

  @override
  String get chatInputHint => 'Responda em inglês...';

  @override
  String chatFreeMessages(int used, int total) {
    return '$used de $total mensagens gratuitas usadas hoje';
  }

  @override
  String get chatLimitReached =>
      'Limite diário atingido. Faça upgrade para continuar!';

  @override
  String get chatLimitButton => 'Ver planos';

  @override
  String get chatCorrectionLabel => 'Pequena correção';

  @override
  String get chatNewWordsLabel => 'Palavras novas';

  @override
  String get chatErrorTimeout => 'Tempo de conexão esgotado. Tente novamente.';

  @override
  String get chatErrorNetwork => 'Sem conexão. Verifique sua internet.';

  @override
  String get chatErrorGeneric => 'Algo deu errado. Tente novamente.';

  @override
  String get chatEmptyTitle => 'Olá! Sou a Aria, sua tutora de inglês.';

  @override
  String get chatEmptySubtitle =>
      'Escreva qualquer coisa em inglês para começarmos!';

  @override
  String get progressTitle => 'Seu progresso';

  @override
  String get progressMessages => 'mensagens enviadas';

  @override
  String get progressWords => 'palavras novas';

  @override
  String get progressStreak => 'dias seguidos';

  @override
  String get progressAccuracy => 'gramática correta';

  @override
  String get progressWeeklyChart => 'Conversas esta semana';

  @override
  String get progressFrequentErrors => 'ERROS FREQUENTES';

  @override
  String get progressDayMon => 'Seg';

  @override
  String get progressDayTue => 'Ter';

  @override
  String get progressDayWed => 'Qua';

  @override
  String get progressDayThu => 'Qui';

  @override
  String get progressDayFri => 'Sex';

  @override
  String get progressDaySat => 'Sáb';

  @override
  String get progressDaySun => 'Dom';

  @override
  String get progressNoErrors => 'Nenhum erro registrado ainda.';

  @override
  String get progressKeepPracticing => 'Continue praticando!';

  @override
  String progressOccurrences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ocorrências',
      one: '1 ocorrência',
    );
    return '$_temp0';
  }

  @override
  String get paywallBadge => 'NativeChat Premium';

  @override
  String get paywallTitle => 'Fale com fluência\nsem limites';

  @override
  String get paywallSubtitle =>
      'Conversas ilimitadas, todos os modos e feedback avançado da IA';

  @override
  String get paywallPlanMonthly => 'Mensal';

  @override
  String get paywallPlanAnnual => 'Anual';

  @override
  String get paywallPlanPopular => 'Mais popular';

  @override
  String get paywallPlanMonthlyPrice => 'R\$ 19,90';

  @override
  String get paywallPlanMonthlyPeriod => '/ mês';

  @override
  String get paywallPlanAnnualPrice => 'R\$ 149';

  @override
  String get paywallPlanAnnualPeriod => '/ ano';

  @override
  String get paywallPlanAnnualSavings =>
      'Equivale a R\$ 12,40/mês · Economize 38%';

  @override
  String get paywallCancelAnytime => 'Cancele quando quiser';

  @override
  String get paywallFeature1 => 'Conversas ilimitadas com IA';

  @override
  String get paywallFeature2 => 'Todos os modos de conversa';

  @override
  String get paywallFeature3 => 'Feedback avançado pós-conversa';

  @override
  String get paywallFeature4 => 'Relatório semanal de evolução';

  @override
  String get paywallFeature5 => 'Prática de pronúncia';

  @override
  String get paywallCTA => 'Começar agora';

  @override
  String get paywallTrial => '7 dias grátis · Sem cobrança até lá';

  @override
  String get paywallRestore => 'Já é assinante? Restaurar compras';

  @override
  String get paywallSuccessMessage => 'Bem-vindo ao Premium! 🎉';

  @override
  String get paywallRestoredMessage => 'Assinatura restaurada com sucesso!';

  @override
  String get paywallCancelledMessage => 'Compra cancelada.';

  @override
  String get navHome => 'Início';

  @override
  String get navChat => 'Chat';

  @override
  String get navFlashcards => 'Flashcards';

  @override
  String get navProgress => 'Progresso';

  @override
  String get navPremium => 'Premium';

  @override
  String get flashcardsTitle => 'Flashcards';

  @override
  String flashcardsProgress(int knew, int remaining) {
    return '$knew conhecidas · $remaining restantes';
  }

  @override
  String get flashcardsVocabLabel => 'VOCABULÁRIO';

  @override
  String flashcardsSeenInChat(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Apareceu $count vezes no chat',
      one: 'Apareceu $count vez no chat',
    );
    return '$_temp0';
  }

  @override
  String get flashcardsTapToReveal => 'Toque para ver a definição';

  @override
  String get flashcardsLoadingDef => 'Carregando definição…';

  @override
  String get flashcardsNoDefinition => 'Definição não disponível.';

  @override
  String get flashcardsReviewLater => 'Revisar depois';

  @override
  String get flashcardsKnew => 'Conhecia!';

  @override
  String get flashcardsDone => 'Sessão concluída!';

  @override
  String flashcardsScore(int pct) {
    return 'Você acertou $pct% das palavras';
  }

  @override
  String get flashcardsKnewLabel => 'Conhecia';

  @override
  String get flashcardsReviewLabel => 'A revisar';

  @override
  String get flashcardsPlayAgain => 'Praticar novamente';

  @override
  String get flashcardsEmpty => 'Nenhuma palavra ainda';

  @override
  String get flashcardsEmptySubtitle =>
      'Pratique no chat e a Aria vai destacar palavras para você revisar aqui.';

  @override
  String get flashcardsHowItWorks => 'Como funciona';

  @override
  String get flashcardsStep1 => 'Converse com a Aria';

  @override
  String get flashcardsStep2 => 'Aria destaca vocabulário novo';

  @override
  String get flashcardsStep3 => 'Revise as palavras aqui nos flashcards';

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
  String get deckStudyQuestion => 'QUESTÃO';

  @override
  String get deckStudyHowWasIt => 'Como foi?';

  @override
  String get deckStudyAgain => 'De novo';

  @override
  String get deckStudyHard => 'Difícil';

  @override
  String get deckStudyGood => 'Bom';

  @override
  String get deckStudyEasy => 'Fácil';

  @override
  String get deckStudyAgainSub => '< 1 min';

  @override
  String get deckStudyHardSub => '6 min';

  @override
  String get deckStudyGoodSub => '10 min';

  @override
  String get deckStudyEasySub => '4 dias';

  @override
  String get deckStudyTapToReveal => 'Toque para revelar';

  @override
  String get deckStudyDoneTitle => 'Sessão concluída!';

  @override
  String get deckStudyUpToDateTitle => 'Tudo em dia!';

  @override
  String deckStudyDoneBody(int count) {
    return 'Você revisou $count cartas nesta sessão.';
  }

  @override
  String get deckStudyNoDueCards =>
      'Nenhuma carta para revisar agora. Volte mais tarde!';

  @override
  String get deckStudyBackButton => 'Voltar ao deck';

  @override
  String get decksTitle => 'Meus Decks';

  @override
  String get decksSubtitle => 'Revise e estude seus decks de flashcards';

  @override
  String decksCardCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartas',
      one: '1 carta',
    );
    return '$_temp0';
  }

  @override
  String decksDueCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count para revisar',
      one: '1 para revisar',
    );
    return '$_temp0';
  }

  @override
  String get decksUpToDate => 'Em dia';

  @override
  String get decksDeleteTitle => 'Excluir deck?';

  @override
  String decksDeleteBody(int count, String title) {
    return 'Excluir \"$title\" com $count cartas? Essa ação não pode ser desfeita.';
  }

  @override
  String get decksDeleteCancel => 'Cancelar';

  @override
  String get decksDeleteConfirm => 'Excluir';

  @override
  String get decksEmptyTitle => 'Nenhum deck ainda';

  @override
  String get decksEmptyBody =>
      'Crie um deck e eu vou gerar flashcards sobre qualquer tema de inglês para você.';

  @override
  String get decksEmptyButton => 'Criar primeiro deck';

  @override
  String get decksGenerateError => 'Falha ao gerar o deck. Tente novamente.';

  @override
  String get decksNewDeckTitle => 'Novo deck';

  @override
  String get decksNewDeckSubtitle =>
      'Escolha um tema e eu crio os flashcards para você';

  @override
  String get decksTopicHint => 'ex: Passado Simples, Phrasal Verbs…';

  @override
  String get decksHowManyCards => 'QUANTAS CARTAS?';

  @override
  String get decksCardsUnit => 'cartas';

  @override
  String get decksGenerateButton => 'Gerar deck';

  @override
  String get premiumExclusive => 'Exclusivo Premium';

  @override
  String get premiumViewPlans => 'Ver planos Premium';

  @override
  String get errorUnknown => 'Erro inesperado. Tente novamente.';

  @override
  String get errorNoConnection => 'Sem conexão com a internet.';

  @override
  String get errorTimeout => 'Tempo de requisição esgotado.';
}
