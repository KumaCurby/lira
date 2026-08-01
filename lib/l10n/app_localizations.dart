import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
  ];

  /// No description provided for @tabTraining.
  ///
  /// In fr, this message translates to:
  /// **'Entraînement'**
  String get tabTraining;

  /// No description provided for @tabTexts.
  ///
  /// In fr, this message translates to:
  /// **'Textes'**
  String get tabTexts;

  /// No description provided for @tabProgress.
  ///
  /// In fr, this message translates to:
  /// **'Progrès'**
  String get tabProgress;

  /// No description provided for @tabSettings.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get tabSettings;

  /// No description provided for @homeGreetingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prêt à lire plus vite ?'**
  String get homeGreetingTitle;

  /// No description provided for @homeGreetingSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisis un exercice et progresse chaque jour.'**
  String get homeGreetingSubtitle;

  /// No description provided for @continueSection.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get continueSection;

  /// No description provided for @resume.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre'**
  String get resume;

  /// No description provided for @dailyGoalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Objectif du jour'**
  String get dailyGoalTitle;

  /// No description provided for @dailyGoalDone.
  ///
  /// In fr, this message translates to:
  /// **'Séance faite aujourd\'hui, bravo !'**
  String get dailyGoalDone;

  /// No description provided for @dailyGoalTodo.
  ///
  /// In fr, this message translates to:
  /// **'Fais une séance pour continuer.'**
  String get dailyGoalTodo;

  /// No description provided for @streakDays.
  ///
  /// In fr, this message translates to:
  /// **'{count} j'**
  String streakDays(int count);

  /// No description provided for @onbTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue dans Lira'**
  String get onbTitle;

  /// No description provided for @onbSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Mesurons d\'abord ta vitesse de lecture actuelle, pour te fixer un objectif sur mesure.'**
  String get onbSubtitle;

  /// No description provided for @onbMeasure.
  ///
  /// In fr, this message translates to:
  /// **'Mesurer ma vitesse'**
  String get onbMeasure;

  /// No description provided for @onbReadHint.
  ///
  /// In fr, this message translates to:
  /// **'Lis ce texte à ton rythme, puis appuie sur « J\'ai fini ».'**
  String get onbReadHint;

  /// No description provided for @onbFinishReading.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai fini de lire'**
  String get onbFinishReading;

  /// No description provided for @onbYourSpeed.
  ///
  /// In fr, this message translates to:
  /// **'Ta vitesse'**
  String get onbYourSpeed;

  /// No description provided for @onbGoalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ton objectif : {count} mpm'**
  String onbGoalLabel(int count);

  /// No description provided for @onbStart.
  ///
  /// In fr, this message translates to:
  /// **'C\'est parti ! 🚀'**
  String get onbStart;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get settingsTitle;

  /// No description provided for @darkTheme.
  ///
  /// In fr, this message translates to:
  /// **'Thème sombre'**
  String get darkTheme;

  /// No description provided for @defaultSpeed.
  ///
  /// In fr, this message translates to:
  /// **'Vitesse par défaut'**
  String get defaultSpeed;

  /// No description provided for @wpmValue.
  ///
  /// In fr, this message translates to:
  /// **'{count} mots/min'**
  String wpmValue(int count);

  /// No description provided for @groupSize.
  ///
  /// In fr, this message translates to:
  /// **'Taille des groupes (guidage)'**
  String get groupSize;

  /// No description provided for @wordsValue.
  ///
  /// In fr, this message translates to:
  /// **'{count} mots'**
  String wordsValue(int count);

  /// No description provided for @slowLongWords.
  ///
  /// In fr, this message translates to:
  /// **'Ralentir les mots longs (RSVP)'**
  String get slowLongWords;

  /// No description provided for @pauseOnPunctuation.
  ///
  /// In fr, this message translates to:
  /// **'Pause sur la ponctuation (RSVP)'**
  String get pauseOnPunctuation;

  /// No description provided for @dailyReminder.
  ///
  /// In fr, this message translates to:
  /// **'Rappel quotidien'**
  String get dailyReminder;

  /// No description provided for @reminderTime.
  ///
  /// In fr, this message translates to:
  /// **'Heure du rappel'**
  String get reminderTime;

  /// No description provided for @clearHistory.
  ///
  /// In fr, this message translates to:
  /// **'Effacer l\'historique'**
  String get clearHistory;

  /// No description provided for @clearHistorySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprime toutes les sessions enregistrées'**
  String get clearHistorySubtitle;

  /// No description provided for @historyCleared.
  ///
  /// In fr, this message translates to:
  /// **'Historique effacé'**
  String get historyCleared;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système (appareil)'**
  String get languageSystem;

  /// No description provided for @aboutDescription.
  ///
  /// In fr, this message translates to:
  /// **'Entraîneur de lecture rapide. Développé en TDD.'**
  String get aboutDescription;

  /// No description provided for @exRsvpTitle.
  ///
  /// In fr, this message translates to:
  /// **'Lecteur RSVP'**
  String get exRsvpTitle;

  /// No description provided for @exRsvpSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Présentation visuelle sérielle rapide'**
  String get exRsvpSubtitle;

  /// No description provided for @exPacerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Guidage'**
  String get exPacerTitle;

  /// No description provided for @exPacerSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Lecture par groupes, rythmée'**
  String get exPacerSubtitle;

  /// No description provided for @exSpeedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Test de vitesse'**
  String get exSpeedTitle;

  /// No description provided for @exSpeedSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Mots/min + compréhension'**
  String get exSpeedSubtitle;

  /// No description provided for @exSkimTitle.
  ///
  /// In fr, this message translates to:
  /// **'Écrémage'**
  String get exSkimTitle;

  /// No description provided for @exSkimSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Saisir l\'idée générale'**
  String get exSkimSubtitle;

  /// No description provided for @exScanTitle.
  ///
  /// In fr, this message translates to:
  /// **'Balayage'**
  String get exScanTitle;

  /// No description provided for @exScanSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Repérer une info précise'**
  String get exScanSubtitle;

  /// No description provided for @exSchulteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Table de Schulte'**
  String get exSchulteTitle;

  /// No description provided for @exSchulteSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vision périphérique'**
  String get exSchulteSubtitle;

  /// No description provided for @exScrambleTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mots mélangés'**
  String get exScrambleTitle;

  /// No description provided for @exScrambleSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Lire malgré le désordre'**
  String get exScrambleSubtitle;

  /// No description provided for @scrambleHint.
  ///
  /// In fr, this message translates to:
  /// **'Seules la 1re et la dernière lettre sont à leur place. Lis normalement : ton cerveau rétablit les mots.'**
  String get scrambleHint;

  /// No description provided for @scrambleDone.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai lu'**
  String get scrambleDone;

  /// No description provided for @scrambleShowOriginal.
  ///
  /// In fr, this message translates to:
  /// **'Voir l\'original'**
  String get scrambleShowOriginal;

  /// No description provided for @scrambleHighlight.
  ///
  /// In fr, this message translates to:
  /// **'Surligner les repères'**
  String get scrambleHighlight;

  /// No description provided for @scrambleMarkers.
  ///
  /// In fr, this message translates to:
  /// **'Repères (mots mélangés)'**
  String get scrambleMarkers;

  /// No description provided for @markColorEnds.
  ///
  /// In fr, this message translates to:
  /// **'En couleur'**
  String get markColorEnds;

  /// No description provided for @markDimMiddle.
  ///
  /// In fr, this message translates to:
  /// **'Milieu estompé'**
  String get markDimMiddle;

  /// No description provided for @markUnderline.
  ///
  /// In fr, this message translates to:
  /// **'Soulignés'**
  String get markUnderline;

  /// No description provided for @markNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucun'**
  String get markNone;

  /// No description provided for @scrambleSpeedTitle.
  ///
  /// In fr, this message translates to:
  /// **'En lecture mélangée'**
  String get scrambleSpeedTitle;

  /// No description provided for @scrambleSpeedCompare.
  ///
  /// In fr, this message translates to:
  /// **'{percent} % de ta vitesse de lecture habituelle (~{ref} mots/min).'**
  String scrambleSpeedCompare(int percent, int ref);

  /// No description provided for @scrambleIntensity.
  ///
  /// In fr, this message translates to:
  /// **'Intensité (mots mélangés)'**
  String get scrambleIntensity;

  /// No description provided for @intensityEasy.
  ///
  /// In fr, this message translates to:
  /// **'Facile'**
  String get intensityEasy;

  /// No description provided for @intensityMedium.
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get intensityMedium;

  /// No description provided for @intensityHard.
  ///
  /// In fr, this message translates to:
  /// **'Difficile'**
  String get intensityHard;

  /// No description provided for @scrambleTapHint.
  ///
  /// In fr, this message translates to:
  /// **'Touche un mot pour l\'entrevoir.'**
  String get scrambleTapHint;

  /// No description provided for @scrambleHints.
  ///
  /// In fr, this message translates to:
  /// **'{count} coups de pouce'**
  String scrambleHints(int count);

  /// No description provided for @introTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le secret des mots mélangés'**
  String get introTitle;

  /// No description provided for @introBody.
  ///
  /// In fr, this message translates to:
  /// **'En gardant la première et la dernière lettre de chaque mot, ton cerveau reconstitue le texte par la forme des mots — pas lettre par lettre. Entraîne-toi à lire vite malgré le désordre.'**
  String get introBody;

  /// No description provided for @introGotIt.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai compris'**
  String get introGotIt;

  /// No description provided for @scrambleTimed.
  ///
  /// In fr, this message translates to:
  /// **'Chrono'**
  String get scrambleTimed;

  /// No description provided for @scrambleComfort.
  ///
  /// In fr, this message translates to:
  /// **'Confort de lecture'**
  String get scrambleComfort;

  /// No description provided for @scrambleComfortSub.
  ///
  /// In fr, this message translates to:
  /// **'Interligne et espacement agrandis'**
  String get scrambleComfortSub;

  /// No description provided for @scrambleStable.
  ///
  /// In fr, this message translates to:
  /// **'Même mélange à chaque fois'**
  String get scrambleStable;

  /// No description provided for @scrambleStableSub.
  ///
  /// In fr, this message translates to:
  /// **'Rejoue le même mélange pour un texte donné'**
  String get scrambleStableSub;

  /// No description provided for @exWordsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Phrases mélangées'**
  String get exWordsTitle;

  /// No description provided for @exWordsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Remettre les mots dans l\'ordre'**
  String get exWordsSubtitle;

  /// No description provided for @exKeywordsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Lecture mots-clés'**
  String get exKeywordsTitle;

  /// No description provided for @exKeywordsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Glisser sur les mots-outils'**
  String get exKeywordsSubtitle;

  /// No description provided for @keywordsHint.
  ///
  /// In fr, this message translates to:
  /// **'Les petits mots grammaticaux sont estompés : laisse ton regard glisser dessus et pose-le sur les mots importants.'**
  String get keywordsHint;

  /// No description provided for @kwNormal.
  ///
  /// In fr, this message translates to:
  /// **'Normal'**
  String get kwNormal;

  /// No description provided for @kwDim.
  ///
  /// In fr, this message translates to:
  /// **'Estompé'**
  String get kwDim;

  /// No description provided for @kwContent.
  ///
  /// In fr, this message translates to:
  /// **'Contenu seul'**
  String get kwContent;

  /// No description provided for @pacerProgressive.
  ///
  /// In fr, this message translates to:
  /// **'Empan progressif'**
  String get pacerProgressive;

  /// No description provided for @keywordsSpeedTitle.
  ///
  /// In fr, this message translates to:
  /// **'En lecture mots-clés'**
  String get keywordsSpeedTitle;

  /// No description provided for @reviewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Révisions'**
  String get reviewTitle;

  /// No description provided for @reviewEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune révision aujourd\'hui. Reviens plus tard !'**
  String get reviewEmpty;

  /// No description provided for @reviewDone.
  ///
  /// In fr, this message translates to:
  /// **'Bien joué : {count} carte(s) révisée(s) !'**
  String reviewDone(int count);

  /// No description provided for @reviewProgress.
  ///
  /// In fr, this message translates to:
  /// **'Carte {current} sur {total}'**
  String reviewProgress(int current, int total);

  /// No description provided for @reviewMissing.
  ///
  /// In fr, this message translates to:
  /// **'Question introuvable (texte supprimé ?)'**
  String get reviewMissing;

  /// No description provided for @reviewShowAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Voir la réponse'**
  String get reviewShowAnswer;

  /// No description provided for @srsAgain.
  ///
  /// In fr, this message translates to:
  /// **'À revoir'**
  String get srsAgain;

  /// No description provided for @srsHard.
  ///
  /// In fr, this message translates to:
  /// **'Difficile'**
  String get srsHard;

  /// No description provided for @srsGood.
  ///
  /// In fr, this message translates to:
  /// **'Bien'**
  String get srsGood;

  /// No description provided for @srsEasy.
  ///
  /// In fr, this message translates to:
  /// **'Facile'**
  String get srsEasy;

  /// No description provided for @homeReviewDue.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 carte à réviser} other{{count} cartes à réviser}}'**
  String homeReviewDue(int count);

  /// No description provided for @homeReviewCta.
  ///
  /// In fr, this message translates to:
  /// **'Réviser maintenant'**
  String get homeReviewCta;

  /// No description provided for @exColumnsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Lecture en colonnes'**
  String get exColumnsTitle;

  /// No description provided for @exColumnsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Moins de fixations par ligne'**
  String get exColumnsSubtitle;

  /// No description provided for @columnsHint.
  ///
  /// In fr, this message translates to:
  /// **'Le texte est en colonnes fines : force ton regard à sauter plus souvent, tu couvriras plus de mots à chaque fixation.'**
  String get columnsHint;

  /// No description provided for @columnsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} colonnes'**
  String columnsCount(int count);

  /// No description provided for @exNoSubvocalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sans voix intérieure'**
  String get exNoSubvocalTitle;

  /// No description provided for @exNoSubvocalSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Compter mentalement en lisant'**
  String get exNoSubvocalSubtitle;

  /// No description provided for @noSubvocalHint.
  ///
  /// In fr, this message translates to:
  /// **'Suis des yeux les chiffres 1‑2‑3‑4 pendant que tu lis : ta voix intérieure est occupée, tu reconnais les mots par leur forme.'**
  String get noSubvocalHint;

  /// No description provided for @noSubvocalTempo.
  ///
  /// In fr, this message translates to:
  /// **'Tempo : {count} bpm'**
  String noSubvocalTempo(int count);

  /// No description provided for @wordsHint.
  ///
  /// In fr, this message translates to:
  /// **'Les mots sont dans le désordre ; le premier et le dernier restent à leur place. Reconstruis le sens.'**
  String get wordsHint;

  /// No description provided for @scrambleBest.
  ///
  /// In fr, this message translates to:
  /// **'Mélangé (record)'**
  String get scrambleBest;

  /// No description provided for @scrambleSessionsStat.
  ///
  /// In fr, this message translates to:
  /// **'Séances mélangées'**
  String get scrambleSessionsStat;

  /// No description provided for @progressTitle.
  ///
  /// In fr, this message translates to:
  /// **'Progrès'**
  String get progressTitle;

  /// No description provided for @progressEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Fais un exercice pour voir tes progrès apparaître ici ! 🚀'**
  String get progressEmpty;

  /// No description provided for @statBestSpeed.
  ///
  /// In fr, this message translates to:
  /// **'Meilleure vitesse'**
  String get statBestSpeed;

  /// No description provided for @statAvgSpeed.
  ///
  /// In fr, this message translates to:
  /// **'Vitesse moyenne'**
  String get statAvgSpeed;

  /// No description provided for @statStreak.
  ///
  /// In fr, this message translates to:
  /// **'Série'**
  String get statStreak;

  /// No description provided for @statSessions.
  ///
  /// In fr, this message translates to:
  /// **'Séances'**
  String get statSessions;

  /// No description provided for @unitWpm.
  ///
  /// In fr, this message translates to:
  /// **'mpm'**
  String get unitWpm;

  /// No description provided for @unitDays.
  ///
  /// In fr, this message translates to:
  /// **'jour(s)'**
  String get unitDays;

  /// No description provided for @unitTotal.
  ///
  /// In fr, this message translates to:
  /// **'total'**
  String get unitTotal;

  /// No description provided for @speedEvolution.
  ///
  /// In fr, this message translates to:
  /// **'Évolution de la vitesse'**
  String get speedEvolution;

  /// No description provided for @chartMorePoints.
  ///
  /// In fr, this message translates to:
  /// **'Encore un exercice ou deux pour tracer la courbe.'**
  String get chartMorePoints;

  /// No description provided for @badgesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Badges'**
  String get badgesTitle;

  /// No description provided for @badgeFirst.
  ///
  /// In fr, this message translates to:
  /// **'Première séance'**
  String get badgeFirst;

  /// No description provided for @badgeRegular.
  ///
  /// In fr, this message translates to:
  /// **'Assidu · 3 jours'**
  String get badgeRegular;

  /// No description provided for @badgeQuick.
  ///
  /// In fr, this message translates to:
  /// **'Vif · 300 mpm'**
  String get badgeQuick;

  /// No description provided for @badgeFlash.
  ///
  /// In fr, this message translates to:
  /// **'Éclair · 500 mpm'**
  String get badgeFlash;

  /// No description provided for @badgeExplorer.
  ///
  /// In fr, this message translates to:
  /// **'Explorateur'**
  String get badgeExplorer;

  /// No description provided for @goalReached.
  ///
  /// In fr, this message translates to:
  /// **'Objectif atteint : {count} mpm 🎉'**
  String goalReached(int count);

  /// No description provided for @goalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Objectif : {count} mpm'**
  String goalLabel(int count);

  /// No description provided for @libraryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Textes'**
  String get libraryTitle;

  /// No description provided for @add.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get add;

  /// No description provided for @pasteText.
  ///
  /// In fr, this message translates to:
  /// **'Coller du texte'**
  String get pasteText;

  /// No description provided for @importFile.
  ///
  /// In fr, this message translates to:
  /// **'Importer un fichier (EPUB / PDF)'**
  String get importFile;

  /// No description provided for @importFileSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Découpé en extraits de ~500 mots'**
  String get importFileSubtitle;

  /// No description provided for @pasteDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Coller un texte'**
  String get pasteDialogTitle;

  /// No description provided for @titleOptional.
  ///
  /// In fr, this message translates to:
  /// **'Titre (optionnel)'**
  String get titleOptional;

  /// No description provided for @pasteHint.
  ///
  /// In fr, this message translates to:
  /// **'Colle ton texte ici'**
  String get pasteHint;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @cannotReadFile.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de lire le fichier.'**
  String get cannotReadFile;

  /// No description provided for @importedCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 extrait importé} other{{count} extraits importés}} depuis « {name} ».'**
  String importedCount(int count, String name);

  /// No description provided for @importFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de l\'import : {error}'**
  String importFailed(String error);

  /// No description provided for @errorGeneric.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : {error}'**
  String errorGeneric(String error);

  /// No description provided for @noTextForExercise.
  ///
  /// In fr, this message translates to:
  /// **'Aucun texte disponible pour cet exercice.\nAjoute un texte dans l\'onglet « Textes ».'**
  String get noTextForExercise;

  /// No description provided for @sourceUser.
  ///
  /// In fr, this message translates to:
  /// **'perso'**
  String get sourceUser;

  /// No description provided for @sourceCorpus.
  ///
  /// In fr, this message translates to:
  /// **'corpus'**
  String get sourceCorpus;

  /// No description provided for @textMeta.
  ///
  /// In fr, this message translates to:
  /// **'{count} mots · {source}'**
  String textMeta(int count, String source);

  /// No description provided for @textPickerMeta.
  ///
  /// In fr, this message translates to:
  /// **'{count} mots · niveau {level}/5'**
  String textPickerMeta(int count, String level);

  /// No description provided for @bookExcerpts.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 extrait} other{{count} extraits}} · {words} mots'**
  String bookExcerpts(int count, int words);

  /// No description provided for @excerptN.
  ///
  /// In fr, this message translates to:
  /// **'Extrait {count}'**
  String excerptN(int count);

  /// No description provided for @excerptDone.
  ///
  /// In fr, this message translates to:
  /// **'Terminé · {count} mots'**
  String excerptDone(int count);

  /// No description provided for @excerptReadPct.
  ///
  /// In fr, this message translates to:
  /// **'Lu à {pct} % · {count} mots'**
  String excerptReadPct(int pct, int count);

  /// No description provided for @resumeExcerpt.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre (extrait {count})'**
  String resumeExcerpt(int count);

  /// No description provided for @startReading.
  ///
  /// In fr, this message translates to:
  /// **'Commencer la lecture'**
  String get startReading;

  /// No description provided for @importedBook.
  ///
  /// In fr, this message translates to:
  /// **'Livre importé'**
  String get importedBook;

  /// No description provided for @deleteBook.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le livre'**
  String get deleteBook;

  /// No description provided for @launchExercise.
  ///
  /// In fr, this message translates to:
  /// **'Lancer un exercice'**
  String get launchExercise;

  /// No description provided for @rsvpTapPlay.
  ///
  /// In fr, this message translates to:
  /// **'Appuie sur Lecture'**
  String get rsvpTapPlay;

  /// No description provided for @speedLabel.
  ///
  /// In fr, this message translates to:
  /// **'Vitesse : {count} mots/min'**
  String speedLabel(int count);

  /// No description provided for @rsvpDone.
  ///
  /// In fr, this message translates to:
  /// **'Lecture terminée ! 🎉'**
  String get rsvpDone;

  /// No description provided for @rsvpSummary.
  ///
  /// In fr, this message translates to:
  /// **'{count} mots · {wpm} mpm'**
  String rsvpSummary(int count, int wpm);

  /// No description provided for @groupLabel.
  ///
  /// In fr, this message translates to:
  /// **'Groupe : {count} mots'**
  String groupLabel(int count);

  /// No description provided for @pacerDone.
  ///
  /// In fr, this message translates to:
  /// **'Guidage terminé ! 🎉'**
  String get pacerDone;

  /// No description provided for @doneReading.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai fini de lire'**
  String get doneReading;

  /// No description provided for @validate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get validate;

  /// No description provided for @finish.
  ///
  /// In fr, this message translates to:
  /// **'Terminer'**
  String get finish;

  /// No description provided for @wpmCaption.
  ///
  /// In fr, this message translates to:
  /// **'mots / minute'**
  String get wpmCaption;

  /// No description provided for @comprehension.
  ///
  /// In fr, this message translates to:
  /// **'Compréhension'**
  String get comprehension;

  /// No description provided for @effectiveSpeed.
  ///
  /// In fr, this message translates to:
  /// **'Vitesse effective'**
  String get effectiveSpeed;

  /// No description provided for @skimHint.
  ///
  /// In fr, this message translates to:
  /// **'Survole les idées principales, puis réponds aux questions.'**
  String get skimHint;

  /// No description provided for @skimDone.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai survolé'**
  String get skimDone;

  /// No description provided for @scanTargetLabel.
  ///
  /// In fr, this message translates to:
  /// **'Repère dans le texte : « {target} »'**
  String scanTargetLabel(String target);

  /// No description provided for @yourAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Ta réponse'**
  String get yourAnswer;

  /// No description provided for @scanFound.
  ///
  /// In fr, this message translates to:
  /// **'Trouvé en {seconds}s !'**
  String scanFound(int seconds);

  /// No description provided for @scanKeepLooking.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore… continue à chercher 🔎'**
  String get scanKeepLooking;

  /// No description provided for @schulteLooking.
  ///
  /// In fr, this message translates to:
  /// **'Cherche : {count}'**
  String schulteLooking(int count);

  /// No description provided for @schulteDone.
  ///
  /// In fr, this message translates to:
  /// **'Terminé en {seconds}s · {errors, plural, =1{1 erreur} other{{errors} erreurs}}'**
  String schulteDone(int seconds, int errors);

  /// No description provided for @replay.
  ///
  /// In fr, this message translates to:
  /// **'Rejouer'**
  String get replay;

  /// No description provided for @start.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get start;

  /// No description provided for @inProgress.
  ///
  /// In fr, this message translates to:
  /// **'En cours…'**
  String get inProgress;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
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
