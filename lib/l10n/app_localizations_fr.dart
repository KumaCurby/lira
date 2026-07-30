// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get tabTraining => 'Entraînement';

  @override
  String get tabTexts => 'Textes';

  @override
  String get tabProgress => 'Progrès';

  @override
  String get tabSettings => 'Réglages';

  @override
  String get homeGreetingTitle => 'Prêt à lire plus vite ?';

  @override
  String get homeGreetingSubtitle =>
      'Choisis un exercice et progresse chaque jour.';

  @override
  String get continueSection => 'Continuer';

  @override
  String get resume => 'Reprendre';

  @override
  String get dailyGoalTitle => 'Objectif du jour';

  @override
  String get dailyGoalDone => 'Séance faite aujourd\'hui, bravo !';

  @override
  String get dailyGoalTodo => 'Fais une séance pour continuer.';

  @override
  String streakDays(int count) {
    return '$count j';
  }

  @override
  String get onbTitle => 'Bienvenue dans Lira';

  @override
  String get onbSubtitle =>
      'Mesurons d\'abord ta vitesse de lecture actuelle, pour te fixer un objectif sur mesure.';

  @override
  String get onbMeasure => 'Mesurer ma vitesse';

  @override
  String get onbReadHint =>
      'Lis ce texte à ton rythme, puis appuie sur « J\'ai fini ».';

  @override
  String get onbFinishReading => 'J\'ai fini de lire';

  @override
  String get onbYourSpeed => 'Ta vitesse';

  @override
  String onbGoalLabel(int count) {
    return 'Ton objectif : $count mpm';
  }

  @override
  String get onbStart => 'C\'est parti ! 🚀';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get darkTheme => 'Thème sombre';

  @override
  String get defaultSpeed => 'Vitesse par défaut';

  @override
  String wpmValue(int count) {
    return '$count mots/min';
  }

  @override
  String get groupSize => 'Taille des groupes (guidage)';

  @override
  String wordsValue(int count) {
    return '$count mots';
  }

  @override
  String get slowLongWords => 'Ralentir les mots longs (RSVP)';

  @override
  String get pauseOnPunctuation => 'Pause sur la ponctuation (RSVP)';

  @override
  String get dailyReminder => 'Rappel quotidien';

  @override
  String get reminderTime => 'Heure du rappel';

  @override
  String get clearHistory => 'Effacer l\'historique';

  @override
  String get clearHistorySubtitle =>
      'Supprime toutes les sessions enregistrées';

  @override
  String get historyCleared => 'Historique effacé';

  @override
  String get language => 'Langue';

  @override
  String get languageSystem => 'Système (appareil)';

  @override
  String get aboutDescription =>
      'Entraîneur de lecture rapide. Développé en TDD.';

  @override
  String get exRsvpTitle => 'Lecteur RSVP';

  @override
  String get exRsvpSubtitle => 'Présentation visuelle sérielle rapide';

  @override
  String get exPacerTitle => 'Guidage';

  @override
  String get exPacerSubtitle => 'Lecture par groupes, rythmée';

  @override
  String get exSpeedTitle => 'Test de vitesse';

  @override
  String get exSpeedSubtitle => 'Mots/min + compréhension';

  @override
  String get exSkimTitle => 'Écrémage';

  @override
  String get exSkimSubtitle => 'Saisir l\'idée générale';

  @override
  String get exScanTitle => 'Balayage';

  @override
  String get exScanSubtitle => 'Repérer une info précise';

  @override
  String get exSchulteTitle => 'Table de Schulte';

  @override
  String get exSchulteSubtitle => 'Vision périphérique';

  @override
  String get exScrambleTitle => 'Mots mélangés';

  @override
  String get exScrambleSubtitle => 'Lire malgré le désordre';

  @override
  String get scrambleHint =>
      'Seules la 1re et la dernière lettre sont à leur place. Lis normalement : ton cerveau rétablit les mots.';

  @override
  String get scrambleDone => 'J\'ai lu';

  @override
  String get scrambleShowOriginal => 'Voir l\'original';

  @override
  String get scrambleHighlight => 'Surligner les repères';

  @override
  String get scrambleMarkers => 'Repères (mots mélangés)';

  @override
  String get markColorEnds => 'En couleur';

  @override
  String get markDimMiddle => 'Milieu estompé';

  @override
  String get markUnderline => 'Soulignés';

  @override
  String get markNone => 'Aucun';

  @override
  String get scrambleSpeedTitle => 'En lecture mélangée';

  @override
  String scrambleSpeedCompare(int percent, int ref) {
    return '$percent % de ta vitesse de lecture habituelle (~$ref mots/min).';
  }

  @override
  String get scrambleIntensity => 'Intensité (mots mélangés)';

  @override
  String get intensityEasy => 'Facile';

  @override
  String get intensityMedium => 'Moyen';

  @override
  String get intensityHard => 'Difficile';

  @override
  String get scrambleTapHint => 'Touche un mot pour l\'entrevoir.';

  @override
  String scrambleHints(int count) {
    return '$count coups de pouce';
  }

  @override
  String get introTitle => 'Le secret des mots mélangés';

  @override
  String get introBody =>
      'En gardant la première et la dernière lettre de chaque mot, ton cerveau reconstitue le texte par la forme des mots — pas lettre par lettre. Entraîne-toi à lire vite malgré le désordre.';

  @override
  String get introGotIt => 'J\'ai compris';

  @override
  String get scrambleTimed => 'Chrono';

  @override
  String get scrambleComfort => 'Confort de lecture';

  @override
  String get scrambleComfortSub => 'Interligne et espacement agrandis';

  @override
  String get scrambleStable => 'Même mélange à chaque fois';

  @override
  String get scrambleStableSub => 'Rejoue le même mélange pour un texte donné';

  @override
  String get exWordsTitle => 'Phrases mélangées';

  @override
  String get exWordsSubtitle => 'Remettre les mots dans l\'ordre';

  @override
  String get exKeywordsTitle => 'Lecture mots-clés';

  @override
  String get exKeywordsSubtitle => 'Glisser sur les mots-outils';

  @override
  String get keywordsHint =>
      'Les petits mots grammaticaux sont estompés : laisse ton regard glisser dessus et pose-le sur les mots importants.';

  @override
  String get kwNormal => 'Normal';

  @override
  String get kwDim => 'Estompé';

  @override
  String get kwContent => 'Contenu seul';

  @override
  String get pacerProgressive => 'Empan progressif';

  @override
  String get keywordsSpeedTitle => 'En lecture mots-clés';

  @override
  String get wordsHint =>
      'Les mots sont dans le désordre ; le premier et le dernier restent à leur place. Reconstruis le sens.';

  @override
  String get scrambleBest => 'Mélangé (record)';

  @override
  String get scrambleSessionsStat => 'Séances mélangées';

  @override
  String get progressTitle => 'Progrès';

  @override
  String get progressEmpty =>
      'Fais un exercice pour voir tes progrès apparaître ici ! 🚀';

  @override
  String get statBestSpeed => 'Meilleure vitesse';

  @override
  String get statAvgSpeed => 'Vitesse moyenne';

  @override
  String get statStreak => 'Série';

  @override
  String get statSessions => 'Séances';

  @override
  String get unitWpm => 'mpm';

  @override
  String get unitDays => 'jour(s)';

  @override
  String get unitTotal => 'total';

  @override
  String get speedEvolution => 'Évolution de la vitesse';

  @override
  String get chartMorePoints =>
      'Encore un exercice ou deux pour tracer la courbe.';

  @override
  String get badgesTitle => 'Badges';

  @override
  String get badgeFirst => 'Première séance';

  @override
  String get badgeRegular => 'Assidu · 3 jours';

  @override
  String get badgeQuick => 'Vif · 300 mpm';

  @override
  String get badgeFlash => 'Éclair · 500 mpm';

  @override
  String get badgeExplorer => 'Explorateur';

  @override
  String goalReached(int count) {
    return 'Objectif atteint : $count mpm 🎉';
  }

  @override
  String goalLabel(int count) {
    return 'Objectif : $count mpm';
  }

  @override
  String get libraryTitle => 'Textes';

  @override
  String get add => 'Ajouter';

  @override
  String get pasteText => 'Coller du texte';

  @override
  String get importFile => 'Importer un fichier (EPUB / PDF)';

  @override
  String get importFileSubtitle => 'Découpé en extraits de ~500 mots';

  @override
  String get pasteDialogTitle => 'Coller un texte';

  @override
  String get titleOptional => 'Titre (optionnel)';

  @override
  String get pasteHint => 'Colle ton texte ici';

  @override
  String get cancel => 'Annuler';

  @override
  String get cannotReadFile => 'Impossible de lire le fichier.';

  @override
  String importedCount(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count extraits importés',
      one: '1 extrait importé',
    );
    return '$_temp0 depuis « $name ».';
  }

  @override
  String importFailed(String error) {
    return 'Échec de l\'import : $error';
  }

  @override
  String errorGeneric(String error) {
    return 'Erreur : $error';
  }

  @override
  String get noTextForExercise =>
      'Aucun texte disponible pour cet exercice.\nAjoute un texte dans l\'onglet « Textes ».';

  @override
  String get sourceUser => 'perso';

  @override
  String get sourceCorpus => 'corpus';

  @override
  String textMeta(int count, String source) {
    return '$count mots · $source';
  }

  @override
  String textPickerMeta(int count, String level) {
    return '$count mots · niveau $level/5';
  }

  @override
  String bookExcerpts(int count, int words) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count extraits',
      one: '1 extrait',
    );
    return '$_temp0 · $words mots';
  }

  @override
  String excerptN(int count) {
    return 'Extrait $count';
  }

  @override
  String excerptDone(int count) {
    return 'Terminé · $count mots';
  }

  @override
  String excerptReadPct(int pct, int count) {
    return 'Lu à $pct % · $count mots';
  }

  @override
  String resumeExcerpt(int count) {
    return 'Reprendre (extrait $count)';
  }

  @override
  String get startReading => 'Commencer la lecture';

  @override
  String get importedBook => 'Livre importé';

  @override
  String get deleteBook => 'Supprimer le livre';

  @override
  String get launchExercise => 'Lancer un exercice';

  @override
  String get rsvpTapPlay => 'Appuie sur Lecture';

  @override
  String speedLabel(int count) {
    return 'Vitesse : $count mots/min';
  }

  @override
  String get rsvpDone => 'Lecture terminée ! 🎉';

  @override
  String rsvpSummary(int count, int wpm) {
    return '$count mots · $wpm mpm';
  }

  @override
  String groupLabel(int count) {
    return 'Groupe : $count mots';
  }

  @override
  String get pacerDone => 'Guidage terminé ! 🎉';

  @override
  String get doneReading => 'J\'ai fini de lire';

  @override
  String get validate => 'Valider';

  @override
  String get finish => 'Terminer';

  @override
  String get wpmCaption => 'mots / minute';

  @override
  String get comprehension => 'Compréhension';

  @override
  String get effectiveSpeed => 'Vitesse effective';

  @override
  String get skimHint =>
      'Survole les idées principales, puis réponds aux questions.';

  @override
  String get skimDone => 'J\'ai survolé';

  @override
  String scanTargetLabel(String target) {
    return 'Repère dans le texte : « $target »';
  }

  @override
  String get yourAnswer => 'Ta réponse';

  @override
  String scanFound(int seconds) {
    return 'Trouvé en ${seconds}s !';
  }

  @override
  String get scanKeepLooking => 'Pas encore… continue à chercher 🔎';

  @override
  String schulteLooking(int count) {
    return 'Cherche : $count';
  }

  @override
  String schulteDone(int seconds, int errors) {
    String _temp0 = intl.Intl.pluralLogic(
      errors,
      locale: localeName,
      other: '$errors erreurs',
      one: '1 erreur',
    );
    return 'Terminé en ${seconds}s · $_temp0';
  }

  @override
  String get replay => 'Rejouer';

  @override
  String get start => 'Commencer';

  @override
  String get inProgress => 'En cours…';
}
