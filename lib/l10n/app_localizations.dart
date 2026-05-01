import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
    Locale('es'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'NativeChat'**
  String get appName;

  /// No description provided for @onboardingPage1Title.
  ///
  /// In en, this message translates to:
  /// **'Hi! What\'s your name?'**
  String get onboardingPage1Title;

  /// No description provided for @onboardingPage1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'I\'ll use your name to personalize your experience'**
  String get onboardingPage1Subtitle;

  /// No description provided for @onboardingPage1FieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get onboardingPage1FieldLabel;

  /// No description provided for @onboardingPage1Button.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingPage1Button;

  /// No description provided for @onboardingPage2Title.
  ///
  /// In en, this message translates to:
  /// **'What\'s your English level?'**
  String get onboardingPage2Title;

  /// No description provided for @onboardingPage2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'I\'ll adapt the conversations to your level'**
  String get onboardingPage2Subtitle;

  /// No description provided for @onboardingPage2Button.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingPage2Button;

  /// No description provided for @levelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get levelBeginner;

  /// No description provided for @levelBeginnerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I\'m just starting out'**
  String get levelBeginnerSubtitle;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get levelIntermediate;

  /// No description provided for @levelIntermediateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I know the basics'**
  String get levelIntermediateSubtitle;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelAdvanced;

  /// No description provided for @levelAdvancedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I want to perfect my English'**
  String get levelAdvancedSubtitle;

  /// No description provided for @onboardingPage3Title.
  ///
  /// In en, this message translates to:
  /// **'How do you want to practice?'**
  String get onboardingPage3Title;

  /// No description provided for @onboardingPage3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change this anytime'**
  String get onboardingPage3Subtitle;

  /// No description provided for @onboardingPage3Button.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go!'**
  String get onboardingPage3Button;

  /// No description provided for @modeCasual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get modeCasual;

  /// No description provided for @modeCasualSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everyday conversations'**
  String get modeCasualSubtitle;

  /// No description provided for @modeBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get modeBusiness;

  /// No description provided for @modeBusinessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Emails and meetings'**
  String get modeBusinessSubtitle;

  /// No description provided for @modeTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get modeTravel;

  /// No description provided for @modeTravelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Airport, hotel, directions'**
  String get modeTravelSubtitle;

  /// No description provided for @modeInterview.
  ///
  /// In en, this message translates to:
  /// **'Interview'**
  String get modeInterview;

  /// No description provided for @modeInterviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Job interview practice'**
  String get modeInterviewSubtitle;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String homeGreetingAfternoon(String name);

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String homeGreetingEvening(String name);

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to practice today?'**
  String get homeTitle;

  /// No description provided for @homeStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'day streak'**
  String get homeStreakLabel;

  /// No description provided for @homeSectionLanguages.
  ///
  /// In en, this message translates to:
  /// **'YOUR LANGUAGES'**
  String get homeSectionLanguages;

  /// No description provided for @homeSectionModes.
  ///
  /// In en, this message translates to:
  /// **'CONVERSATION MODES'**
  String get homeSectionModes;

  /// No description provided for @homeLevelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get homeLevelBeginner;

  /// No description provided for @homeLevelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get homeLevelIntermediate;

  /// No description provided for @homeLevelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get homeLevelAdvanced;

  /// No description provided for @homeLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get homeLanguageEnglish;

  /// No description provided for @homeLanguageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get homeLanguageSpanish;

  /// No description provided for @homeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get homeComingSoon;

  /// No description provided for @homeStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start conversation · {mode}'**
  String homeStartButton(String mode);

  /// No description provided for @chatHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Aria — AI Tutor'**
  String get chatHeaderSubtitle;

  /// No description provided for @chatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Reply in English...'**
  String get chatInputHint;

  /// No description provided for @chatFreeMessages.
  ///
  /// In en, this message translates to:
  /// **'{used} of {total} free messages used today'**
  String chatFreeMessages(int used, int total);

  /// No description provided for @chatLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Daily limit reached. Upgrade to continue!'**
  String get chatLimitReached;

  /// No description provided for @chatLimitButton.
  ///
  /// In en, this message translates to:
  /// **'See plans'**
  String get chatLimitButton;

  /// No description provided for @chatCorrectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Quick correction'**
  String get chatCorrectionLabel;

  /// No description provided for @chatNewWordsLabel.
  ///
  /// In en, this message translates to:
  /// **'New words'**
  String get chatNewWordsLabel;

  /// No description provided for @chatErrorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. Please try again.'**
  String get chatErrorTimeout;

  /// No description provided for @chatErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network.'**
  String get chatErrorNetwork;

  /// No description provided for @chatErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get chatErrorGeneric;

  /// No description provided for @chatEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m Aria, your English tutor.'**
  String get chatEmptyTitle;

  /// No description provided for @chatEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write anything in English to get started!'**
  String get chatEmptySubtitle;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get progressTitle;

  /// No description provided for @progressMessages.
  ///
  /// In en, this message translates to:
  /// **'messages sent'**
  String get progressMessages;

  /// No description provided for @progressWords.
  ///
  /// In en, this message translates to:
  /// **'new words'**
  String get progressWords;

  /// No description provided for @progressStreak.
  ///
  /// In en, this message translates to:
  /// **'day streak'**
  String get progressStreak;

  /// No description provided for @progressAccuracy.
  ///
  /// In en, this message translates to:
  /// **'grammar accuracy'**
  String get progressAccuracy;

  /// No description provided for @progressWeeklyChart.
  ///
  /// In en, this message translates to:
  /// **'Activity this week'**
  String get progressWeeklyChart;

  /// No description provided for @progressFrequentErrors.
  ///
  /// In en, this message translates to:
  /// **'FREQUENT ERRORS'**
  String get progressFrequentErrors;

  /// No description provided for @progressDayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get progressDayMon;

  /// No description provided for @progressDayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get progressDayTue;

  /// No description provided for @progressDayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get progressDayWed;

  /// No description provided for @progressDayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get progressDayThu;

  /// No description provided for @progressDayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get progressDayFri;

  /// No description provided for @progressDaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get progressDaySat;

  /// No description provided for @progressDaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get progressDaySun;

  /// No description provided for @progressNoErrors.
  ///
  /// In en, this message translates to:
  /// **'No errors recorded yet.'**
  String get progressNoErrors;

  /// No description provided for @progressKeepPracticing.
  ///
  /// In en, this message translates to:
  /// **'Keep practicing!'**
  String get progressKeepPracticing;

  /// No description provided for @progressOccurrences.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 occurrence} other{{count} occurrences}}'**
  String progressOccurrences(int count);

  /// No description provided for @paywallBadge.
  ///
  /// In en, this message translates to:
  /// **'NativeChat Premium'**
  String get paywallBadge;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Speak fluently\nwithout limits'**
  String get paywallTitle;

  /// No description provided for @paywallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlimited conversations, all modes and advanced AI feedback'**
  String get paywallSubtitle;

  /// No description provided for @paywallPlanMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get paywallPlanMonthly;

  /// No description provided for @paywallPlanAnnual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get paywallPlanAnnual;

  /// No description provided for @paywallPlanPopular.
  ///
  /// In en, this message translates to:
  /// **'Most popular'**
  String get paywallPlanPopular;

  /// No description provided for @paywallPlanMonthlyPrice.
  ///
  /// In en, this message translates to:
  /// **'R\$ 19.90'**
  String get paywallPlanMonthlyPrice;

  /// No description provided for @paywallPlanMonthlyPeriod.
  ///
  /// In en, this message translates to:
  /// **'/ month'**
  String get paywallPlanMonthlyPeriod;

  /// No description provided for @paywallPlanAnnualPrice.
  ///
  /// In en, this message translates to:
  /// **'R\$ 149'**
  String get paywallPlanAnnualPrice;

  /// No description provided for @paywallPlanAnnualPeriod.
  ///
  /// In en, this message translates to:
  /// **'/ year'**
  String get paywallPlanAnnualPeriod;

  /// No description provided for @paywallPlanAnnualSavings.
  ///
  /// In en, this message translates to:
  /// **'Equals R\$ 12.40/month · Save 38%'**
  String get paywallPlanAnnualSavings;

  /// No description provided for @paywallCancelAnytime.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime'**
  String get paywallCancelAnytime;

  /// No description provided for @paywallFeature1.
  ///
  /// In en, this message translates to:
  /// **'Unlimited conversations with AI'**
  String get paywallFeature1;

  /// No description provided for @paywallFeature2.
  ///
  /// In en, this message translates to:
  /// **'All conversation modes'**
  String get paywallFeature2;

  /// No description provided for @paywallFeature3.
  ///
  /// In en, this message translates to:
  /// **'Advanced post-conversation feedback'**
  String get paywallFeature3;

  /// No description provided for @paywallFeature4.
  ///
  /// In en, this message translates to:
  /// **'Weekly progress report'**
  String get paywallFeature4;

  /// No description provided for @paywallFeature5.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation practice'**
  String get paywallFeature5;

  /// No description provided for @paywallCTA.
  ///
  /// In en, this message translates to:
  /// **'Start now'**
  String get paywallCTA;

  /// No description provided for @paywallTrial.
  ///
  /// In en, this message translates to:
  /// **'7 days free · No charge until then'**
  String get paywallTrial;

  /// No description provided for @paywallRestore.
  ///
  /// In en, this message translates to:
  /// **'Already a subscriber? Restore purchases'**
  String get paywallRestore;

  /// No description provided for @paywallSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Premium! 🎉'**
  String get paywallSuccessMessage;

  /// No description provided for @paywallRestoredMessage.
  ///
  /// In en, this message translates to:
  /// **'Subscription restored successfully!'**
  String get paywallRestoredMessage;

  /// No description provided for @paywallCancelledMessage.
  ///
  /// In en, this message translates to:
  /// **'Purchase cancelled.'**
  String get paywallCancelledMessage;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navFlashcards.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get navFlashcards;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get navPremium;

  /// No description provided for @flashcardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get flashcardsTitle;

  /// No description provided for @flashcardsProgress.
  ///
  /// In en, this message translates to:
  /// **'{knew} known · {remaining} remaining'**
  String flashcardsProgress(int knew, int remaining);

  /// No description provided for @flashcardsVocabLabel.
  ///
  /// In en, this message translates to:
  /// **'VOCABULARY'**
  String get flashcardsVocabLabel;

  /// No description provided for @flashcardsSeenInChat.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Seen {count} time in chat} other{Seen {count} times in chat}}'**
  String flashcardsSeenInChat(int count);

  /// No description provided for @flashcardsTapToReveal.
  ///
  /// In en, this message translates to:
  /// **'Tap to see the definition'**
  String get flashcardsTapToReveal;

  /// No description provided for @flashcardsLoadingDef.
  ///
  /// In en, this message translates to:
  /// **'Loading definition…'**
  String get flashcardsLoadingDef;

  /// No description provided for @flashcardsNoDefinition.
  ///
  /// In en, this message translates to:
  /// **'Definition not available.'**
  String get flashcardsNoDefinition;

  /// No description provided for @flashcardsReviewLater.
  ///
  /// In en, this message translates to:
  /// **'Review later'**
  String get flashcardsReviewLater;

  /// No description provided for @flashcardsKnew.
  ///
  /// In en, this message translates to:
  /// **'I knew it!'**
  String get flashcardsKnew;

  /// No description provided for @flashcardsDone.
  ///
  /// In en, this message translates to:
  /// **'Session complete!'**
  String get flashcardsDone;

  /// No description provided for @flashcardsScore.
  ///
  /// In en, this message translates to:
  /// **'You got {pct}% of the words'**
  String flashcardsScore(int pct);

  /// No description provided for @flashcardsKnewLabel.
  ///
  /// In en, this message translates to:
  /// **'Knew'**
  String get flashcardsKnewLabel;

  /// No description provided for @flashcardsReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'To review'**
  String get flashcardsReviewLabel;

  /// No description provided for @flashcardsPlayAgain.
  ///
  /// In en, this message translates to:
  /// **'Practice again'**
  String get flashcardsPlayAgain;

  /// No description provided for @flashcardsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No words yet'**
  String get flashcardsEmpty;

  /// No description provided for @flashcardsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Practice in the chat and Aria will highlight words for you to review here.'**
  String get flashcardsEmptySubtitle;

  /// No description provided for @flashcardsHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get flashcardsHowItWorks;

  /// No description provided for @flashcardsStep1.
  ///
  /// In en, this message translates to:
  /// **'Chat with Aria'**
  String get flashcardsStep1;

  /// No description provided for @flashcardsStep2.
  ///
  /// In en, this message translates to:
  /// **'Aria highlights new vocabulary'**
  String get flashcardsStep2;

  /// No description provided for @flashcardsStep3.
  ///
  /// In en, this message translates to:
  /// **'Review words here as flashcards'**
  String get flashcardsStep3;

  /// No description provided for @deckStudyRemaining.
  ///
  /// In en, this message translates to:
  /// **'{remaining, plural, =1{1 card left} other{{remaining} cards left}}'**
  String deckStudyRemaining(int remaining);

  /// No description provided for @deckStudyQuestion.
  ///
  /// In en, this message translates to:
  /// **'QUESTION'**
  String get deckStudyQuestion;

  /// No description provided for @deckStudyHowWasIt.
  ///
  /// In en, this message translates to:
  /// **'How was it?'**
  String get deckStudyHowWasIt;

  /// No description provided for @deckStudyAgain.
  ///
  /// In en, this message translates to:
  /// **'Again'**
  String get deckStudyAgain;

  /// No description provided for @deckStudyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get deckStudyHard;

  /// No description provided for @deckStudyGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get deckStudyGood;

  /// No description provided for @deckStudyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get deckStudyEasy;

  /// No description provided for @deckStudyAgainSub.
  ///
  /// In en, this message translates to:
  /// **'< 1 min'**
  String get deckStudyAgainSub;

  /// No description provided for @deckStudyHardSub.
  ///
  /// In en, this message translates to:
  /// **'6 min'**
  String get deckStudyHardSub;

  /// No description provided for @deckStudyGoodSub.
  ///
  /// In en, this message translates to:
  /// **'10 min'**
  String get deckStudyGoodSub;

  /// No description provided for @deckStudyEasySub.
  ///
  /// In en, this message translates to:
  /// **'4 days'**
  String get deckStudyEasySub;

  /// No description provided for @deckStudyTapToReveal.
  ///
  /// In en, this message translates to:
  /// **'Tap to reveal'**
  String get deckStudyTapToReveal;

  /// No description provided for @deckStudyDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Session complete!'**
  String get deckStudyDoneTitle;

  /// No description provided for @deckStudyUpToDateTitle.
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get deckStudyUpToDateTitle;

  /// No description provided for @deckStudyDoneBody.
  ///
  /// In en, this message translates to:
  /// **'You reviewed {count} cards in this session.'**
  String deckStudyDoneBody(int count);

  /// No description provided for @deckStudyNoDueCards.
  ///
  /// In en, this message translates to:
  /// **'No cards due for review right now. Come back later!'**
  String get deckStudyNoDueCards;

  /// No description provided for @deckStudyBackButton.
  ///
  /// In en, this message translates to:
  /// **'Back to deck'**
  String get deckStudyBackButton;

  /// No description provided for @decksTitle.
  ///
  /// In en, this message translates to:
  /// **'My Decks'**
  String get decksTitle;

  /// No description provided for @decksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review and study your flashcard decks'**
  String get decksSubtitle;

  /// No description provided for @decksCardCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 card} other{{count} cards}}'**
  String decksCardCount(int count);

  /// No description provided for @decksDueCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 due} other{{count} due}}'**
  String decksDueCount(int count);

  /// No description provided for @decksUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Up to date'**
  String get decksUpToDate;

  /// No description provided for @decksDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete deck?'**
  String get decksDeleteTitle;

  /// No description provided for @decksDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\" with {count} cards? This can\'t be undone.'**
  String decksDeleteBody(int count, String title);

  /// No description provided for @decksDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get decksDeleteCancel;

  /// No description provided for @decksDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get decksDeleteConfirm;

  /// No description provided for @decksEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No decks yet'**
  String get decksEmptyTitle;

  /// No description provided for @decksEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Create a deck and I\'ll generate flashcards on any English topic for you.'**
  String get decksEmptyBody;

  /// No description provided for @decksEmptyButton.
  ///
  /// In en, this message translates to:
  /// **'Create first deck'**
  String get decksEmptyButton;

  /// No description provided for @decksGenerateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate deck. Please try again.'**
  String get decksGenerateError;

  /// No description provided for @decksNewDeckTitle.
  ///
  /// In en, this message translates to:
  /// **'New deck'**
  String get decksNewDeckTitle;

  /// No description provided for @decksNewDeckSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a topic and I\'ll create flashcards for you'**
  String get decksNewDeckSubtitle;

  /// No description provided for @decksTopicHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Past Simple, Phrasal Verbs…'**
  String get decksTopicHint;

  /// No description provided for @decksHowManyCards.
  ///
  /// In en, this message translates to:
  /// **'HOW MANY CARDS?'**
  String get decksHowManyCards;

  /// No description provided for @decksCardsUnit.
  ///
  /// In en, this message translates to:
  /// **'cards'**
  String get decksCardsUnit;

  /// No description provided for @decksGenerateButton.
  ///
  /// In en, this message translates to:
  /// **'Generate deck'**
  String get decksGenerateButton;

  /// No description provided for @premiumExclusive.
  ///
  /// In en, this message translates to:
  /// **'Premium exclusive'**
  String get premiumExclusive;

  /// No description provided for @premiumViewPlans.
  ///
  /// In en, this message translates to:
  /// **'View Premium plans'**
  String get premiumViewPlans;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error. Please try again.'**
  String get errorUnknown;

  /// No description provided for @errorNoConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get errorNoConnection;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out.'**
  String get errorTimeout;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
