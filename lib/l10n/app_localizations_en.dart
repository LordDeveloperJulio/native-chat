// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'NativeChat';

  @override
  String get onboardingPage1Title => 'Hi! What\'s your name?';

  @override
  String get onboardingPage1Subtitle =>
      'I\'ll use your name to personalize your experience';

  @override
  String get onboardingPage1FieldLabel => 'Your name';

  @override
  String get onboardingPage1Button => 'Continue';

  @override
  String get onboardingPage2Title => 'What\'s your English level?';

  @override
  String get onboardingPage2Subtitle =>
      'I\'ll adapt the conversations to your level';

  @override
  String get onboardingPage2Button => 'Continue';

  @override
  String get levelBeginner => 'Beginner';

  @override
  String get levelBeginnerSubtitle => 'I\'m just starting out';

  @override
  String get levelIntermediate => 'Intermediate';

  @override
  String get levelIntermediateSubtitle => 'I know the basics';

  @override
  String get levelAdvanced => 'Advanced';

  @override
  String get levelAdvancedSubtitle => 'I want to perfect my English';

  @override
  String get onboardingPage3Title => 'How do you want to practice?';

  @override
  String get onboardingPage3Subtitle => 'You can change this anytime';

  @override
  String get onboardingPage3Button => 'Let\'s go!';

  @override
  String get modeCasual => 'Casual';

  @override
  String get modeCasualSubtitle => 'Everyday conversations';

  @override
  String get modeBusiness => 'Business';

  @override
  String get modeBusinessSubtitle => 'Emails and meetings';

  @override
  String get modeTravel => 'Travel';

  @override
  String get modeTravelSubtitle => 'Airport, hotel, directions';

  @override
  String get modeInterview => 'Interview';

  @override
  String get modeInterviewSubtitle => 'Job interview practice';

  @override
  String homeGreeting(String name) {
    return 'Good morning, $name';
  }

  @override
  String homeGreetingAfternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String homeGreetingEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String get homeTitle => 'Ready to practice today?';

  @override
  String get homeStreakLabel => 'day streak';

  @override
  String get homeSectionLanguages => 'YOUR LANGUAGES';

  @override
  String get homeSectionModes => 'CONVERSATION MODES';

  @override
  String get homeLevelBeginner => 'Beginner';

  @override
  String get homeLevelIntermediate => 'Intermediate';

  @override
  String get homeLevelAdvanced => 'Advanced';

  @override
  String get homeLanguageEnglish => 'English';

  @override
  String get homeLanguageSpanish => 'Spanish';

  @override
  String get homeComingSoon => 'Coming soon';

  @override
  String homeStartButton(String mode) {
    return 'Start conversation · $mode';
  }

  @override
  String get chatHeaderSubtitle => 'Aria — AI Tutor';

  @override
  String get chatInputHint => 'Reply in English...';

  @override
  String chatFreeMessages(int used, int total) {
    return '$used of $total free messages used today';
  }

  @override
  String get chatLimitReached => 'Daily limit reached. Upgrade to continue!';

  @override
  String get chatLimitButton => 'See plans';

  @override
  String get chatCorrectionLabel => 'Quick correction';

  @override
  String get chatNewWordsLabel => 'New words';

  @override
  String get chatErrorTimeout => 'Connection timed out. Please try again.';

  @override
  String get chatErrorNetwork => 'No internet connection. Check your network.';

  @override
  String get chatErrorGeneric => 'Something went wrong. Please try again.';

  @override
  String get chatEmptyTitle => 'Hi! I\'m Aria, your English tutor.';

  @override
  String get chatEmptySubtitle => 'Write anything in English to get started!';

  @override
  String get progressTitle => 'Your progress';

  @override
  String get progressMessages => 'messages sent';

  @override
  String get progressWords => 'new words';

  @override
  String get progressStreak => 'day streak';

  @override
  String get progressAccuracy => 'grammar accuracy';

  @override
  String get progressWeeklyChart => 'Activity this week';

  @override
  String get progressFrequentErrors => 'FREQUENT ERRORS';

  @override
  String get progressDayMon => 'Mon';

  @override
  String get progressDayTue => 'Tue';

  @override
  String get progressDayWed => 'Wed';

  @override
  String get progressDayThu => 'Thu';

  @override
  String get progressDayFri => 'Fri';

  @override
  String get progressDaySat => 'Sat';

  @override
  String get progressDaySun => 'Sun';

  @override
  String get progressNoErrors => 'No errors recorded yet.';

  @override
  String get progressKeepPracticing => 'Keep practicing!';

  @override
  String progressOccurrences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count occurrences',
      one: '1 occurrence',
    );
    return '$_temp0';
  }

  @override
  String get paywallBadge => 'NativeChat Premium';

  @override
  String get paywallTitle => 'Speak fluently\nwithout limits';

  @override
  String get paywallSubtitle =>
      'Unlimited conversations, all modes and advanced AI feedback';

  @override
  String get paywallPlanMonthly => 'Monthly';

  @override
  String get paywallPlanAnnual => 'Annual';

  @override
  String get paywallPlanPopular => 'Most popular';

  @override
  String get paywallPlanMonthlyPrice => 'R\$ 19.90';

  @override
  String get paywallPlanMonthlyPeriod => '/ month';

  @override
  String get paywallPlanAnnualPrice => 'R\$ 149';

  @override
  String get paywallPlanAnnualPeriod => '/ year';

  @override
  String get paywallPlanAnnualSavings => 'Equals R\$ 12.40/month · Save 38%';

  @override
  String get paywallCancelAnytime => 'Cancel anytime';

  @override
  String get paywallFeature1 => 'Unlimited conversations with AI';

  @override
  String get paywallFeature2 => 'All conversation modes';

  @override
  String get paywallFeature3 => 'Advanced post-conversation feedback';

  @override
  String get paywallFeature4 => 'Weekly progress report';

  @override
  String get paywallFeature5 => 'Pronunciation practice';

  @override
  String get paywallCTA => 'Start now';

  @override
  String get paywallTrial => '7 days free · No charge until then';

  @override
  String get paywallRestore => 'Already a subscriber? Restore purchases';

  @override
  String get paywallSuccessMessage => 'Welcome to Premium! 🎉';

  @override
  String get paywallRestoredMessage => 'Subscription restored successfully!';

  @override
  String get paywallCancelledMessage => 'Purchase cancelled.';

  @override
  String get navHome => 'Home';

  @override
  String get navChat => 'Chat';

  @override
  String get navFlashcards => 'Flashcards';

  @override
  String get navProgress => 'Progress';

  @override
  String get navPremium => 'Premium';

  @override
  String get flashcardsTitle => 'Flashcards';

  @override
  String flashcardsProgress(int knew, int remaining) {
    return '$knew known · $remaining remaining';
  }

  @override
  String get flashcardsVocabLabel => 'VOCABULARY';

  @override
  String flashcardsSeenInChat(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Seen $count times in chat',
      one: 'Seen $count time in chat',
    );
    return '$_temp0';
  }

  @override
  String get flashcardsTapToReveal => 'Tap to see the definition';

  @override
  String get flashcardsLoadingDef => 'Loading definition…';

  @override
  String get flashcardsNoDefinition => 'Definition not available.';

  @override
  String get flashcardsReviewLater => 'Review later';

  @override
  String get flashcardsKnew => 'I knew it!';

  @override
  String get flashcardsDone => 'Session complete!';

  @override
  String flashcardsScore(int pct) {
    return 'You got $pct% of the words';
  }

  @override
  String get flashcardsKnewLabel => 'Knew';

  @override
  String get flashcardsReviewLabel => 'To review';

  @override
  String get flashcardsPlayAgain => 'Practice again';

  @override
  String get flashcardsEmpty => 'No words yet';

  @override
  String get flashcardsEmptySubtitle =>
      'Practice in the chat and Aria will highlight words for you to review here.';

  @override
  String get flashcardsHowItWorks => 'How it works';

  @override
  String get flashcardsStep1 => 'Chat with Aria';

  @override
  String get flashcardsStep2 => 'Aria highlights new vocabulary';

  @override
  String get flashcardsStep3 => 'Review words here as flashcards';

  @override
  String deckStudyRemaining(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining cards left',
      one: '1 card left',
    );
    return '$_temp0';
  }

  @override
  String get deckStudyQuestion => 'QUESTION';

  @override
  String get deckStudyHowWasIt => 'How was it?';

  @override
  String get deckStudyAgain => 'Again';

  @override
  String get deckStudyHard => 'Hard';

  @override
  String get deckStudyGood => 'Good';

  @override
  String get deckStudyEasy => 'Easy';

  @override
  String get deckStudyAgainSub => '< 1 min';

  @override
  String get deckStudyHardSub => '6 min';

  @override
  String get deckStudyGoodSub => '10 min';

  @override
  String get deckStudyEasySub => '4 days';

  @override
  String get deckStudyTapToReveal => 'Tap to reveal';

  @override
  String get deckStudyDoneTitle => 'Session complete!';

  @override
  String get deckStudyUpToDateTitle => 'All caught up!';

  @override
  String deckStudyDoneBody(int count) {
    return 'You reviewed $count cards in this session.';
  }

  @override
  String get deckStudyNoDueCards =>
      'No cards due for review right now. Come back later!';

  @override
  String get deckStudyBackButton => 'Back to deck';

  @override
  String get decksTitle => 'My Decks';

  @override
  String get decksSubtitle => 'Review and study your flashcard decks';

  @override
  String decksCardCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards',
      one: '1 card',
    );
    return '$_temp0';
  }

  @override
  String decksDueCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count due',
      one: '1 due',
    );
    return '$_temp0';
  }

  @override
  String get decksUpToDate => 'Up to date';

  @override
  String get decksDeleteTitle => 'Delete deck?';

  @override
  String decksDeleteBody(int count, String title) {
    return 'Delete \"$title\" with $count cards? This can\'t be undone.';
  }

  @override
  String get decksDeleteCancel => 'Cancel';

  @override
  String get decksDeleteConfirm => 'Delete';

  @override
  String get decksEmptyTitle => 'No decks yet';

  @override
  String get decksEmptyBody =>
      'Create a deck and I\'ll generate flashcards on any English topic for you.';

  @override
  String get decksEmptyButton => 'Create first deck';

  @override
  String get decksGenerateError => 'Failed to generate deck. Please try again.';

  @override
  String get decksNewDeckTitle => 'New deck';

  @override
  String get decksNewDeckSubtitle =>
      'Choose a topic and I\'ll create flashcards for you';

  @override
  String get decksTopicHint => 'e.g. Past Simple, Phrasal Verbs…';

  @override
  String get decksHowManyCards => 'HOW MANY CARDS?';

  @override
  String get decksCardsUnit => 'cards';

  @override
  String get decksGenerateButton => 'Generate deck';

  @override
  String get premiumExclusive => 'Premium exclusive';

  @override
  String get premiumViewPlans => 'View Premium plans';

  @override
  String get errorUnknown => 'Unexpected error. Please try again.';

  @override
  String get errorNoConnection => 'No internet connection.';

  @override
  String get errorTimeout => 'Request timed out.';
}
