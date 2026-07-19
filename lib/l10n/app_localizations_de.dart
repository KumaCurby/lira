// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get tabTraining => 'Training';

  @override
  String get tabTexts => 'Texte';

  @override
  String get tabProgress => 'Fortschritt';

  @override
  String get tabSettings => 'Einstellungen';

  @override
  String get homeGreetingTitle => 'Bereit, schneller zu lesen?';

  @override
  String get homeGreetingSubtitle =>
      'Wähle eine Übung und werde jeden Tag besser.';

  @override
  String get continueSection => 'Weiter';

  @override
  String get resume => 'Fortsetzen';

  @override
  String get dailyGoalTitle => 'Tagesziel';

  @override
  String get dailyGoalDone => 'Heute schon geübt, super!';

  @override
  String get dailyGoalTodo => 'Mach eine Einheit, um dranzubleiben.';

  @override
  String streakDays(int count) {
    return '$count T';
  }

  @override
  String get onbTitle => 'Willkommen bei Lira';

  @override
  String get onbSubtitle =>
      'Messen wir zuerst deine aktuelle Lesegeschwindigkeit, um dir ein passendes Ziel zu setzen.';

  @override
  String get onbMeasure => 'Meine Geschwindigkeit messen';

  @override
  String get onbReadHint =>
      'Lies diesen Text in deinem Tempo und tippe dann auf «Fertig».';

  @override
  String get onbFinishReading => 'Ich bin fertig mit Lesen';

  @override
  String get onbYourSpeed => 'Deine Geschwindigkeit';

  @override
  String onbGoalLabel(int count) {
    return 'Dein Ziel: $count WpM';
  }

  @override
  String get onbStart => 'Los geht\'s! 🚀';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get darkTheme => 'Dunkles Design';

  @override
  String get defaultSpeed => 'Standardgeschwindigkeit';

  @override
  String wpmValue(int count) {
    return '$count Wörter/Min';
  }

  @override
  String get groupSize => 'Gruppengröße (Pacer)';

  @override
  String wordsValue(int count) {
    return '$count Wörter';
  }

  @override
  String get slowLongWords => 'Lange Wörter verlangsamen (RSVP)';

  @override
  String get pauseOnPunctuation => 'Pause bei Satzzeichen (RSVP)';

  @override
  String get dailyReminder => 'Tägliche Erinnerung';

  @override
  String get reminderTime => 'Erinnerungszeit';

  @override
  String get clearHistory => 'Verlauf löschen';

  @override
  String get clearHistorySubtitle => 'Löscht alle gespeicherten Sitzungen';

  @override
  String get historyCleared => 'Verlauf gelöscht';

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'System (Gerät)';

  @override
  String get aboutDescription => 'Schnelllese-Trainer. Mit TDD entwickelt.';

  @override
  String get exRsvpTitle => 'RSVP-Leser';

  @override
  String get exRsvpSubtitle => 'Schnelle serielle visuelle Präsentation';

  @override
  String get exPacerTitle => 'Pacer';

  @override
  String get exPacerSubtitle => 'Getaktetes Lesen in Gruppen';

  @override
  String get exSpeedTitle => 'Geschwindigkeitstest';

  @override
  String get exSpeedSubtitle => 'Wörter/Min + Verständnis';

  @override
  String get exSkimTitle => 'Überfliegen';

  @override
  String get exSkimSubtitle => 'Den Kerngedanken erfassen';

  @override
  String get exScanTitle => 'Scannen';

  @override
  String get exScanSubtitle => 'Eine bestimmte Info finden';

  @override
  String get exSchulteTitle => 'Schulte-Tabelle';

  @override
  String get exSchulteSubtitle => 'Peripheres Sehen';

  @override
  String get exScrambleTitle => 'Verdrehte Wörter';

  @override
  String get exScrambleSubtitle => 'Trotz Buchstabensalat lesen';

  @override
  String get scrambleHint =>
      'Nur der erste und der letzte Buchstabe bleiben an ihrem Platz. Lies einfach normal – dein Gehirn stellt die Wörter wieder her.';

  @override
  String get scrambleDone => 'Gelesen';

  @override
  String get scrambleShowOriginal => 'Original zeigen';

  @override
  String get scrambleHighlight => 'Marker hervorheben';

  @override
  String get scrambleMarkers => 'Marker (verdrehte Wörter)';

  @override
  String get markColorEnds => 'Farbig';

  @override
  String get markDimMiddle => 'Mitte gedimmt';

  @override
  String get markUnderline => 'Unterstrichen';

  @override
  String get markNone => 'Keine';

  @override
  String get scrambleSpeedTitle => 'Verdrehtes Lesen';

  @override
  String scrambleSpeedCompare(int percent, int ref) {
    return '$percent % deiner üblichen Lesegeschwindigkeit (~$ref WpM).';
  }

  @override
  String get scrambleIntensity => 'Intensität (verdrehte Wörter)';

  @override
  String get intensityEasy => 'Leicht';

  @override
  String get intensityMedium => 'Mittel';

  @override
  String get intensityHard => 'Schwer';

  @override
  String get scrambleTapHint => 'Tippe ein Wort an, um es kurz zu sehen.';

  @override
  String scrambleHints(int count) {
    return '$count Hinweise';
  }

  @override
  String get introTitle => 'Der Trick mit den verdrehten Wörtern';

  @override
  String get introBody =>
      'Wenn der erste und letzte Buchstabe jedes Worts bleibt, setzt dein Gehirn den Text aus den Wortformen zusammen – nicht Buchstabe für Buchstabe. Übe, trotz des Durcheinanders schnell zu lesen.';

  @override
  String get introGotIt => 'Verstanden';

  @override
  String get scrambleTimed => 'Auf Zeit';

  @override
  String get scrambleComfort => 'Lesekomfort';

  @override
  String get scrambleComfortSub => 'Größerer Zeilen- und Buchstabenabstand';

  @override
  String get scrambleStable => 'Immer dieselbe Verdrehung';

  @override
  String get scrambleStableSub =>
      'Wiederholt dieselbe Verdrehung für einen Text';

  @override
  String get exWordsTitle => 'Verdrehte Sätze';

  @override
  String get exWordsSubtitle => 'Wörter neu ordnen';

  @override
  String get wordsHint =>
      'Die Wörter sind vertauscht; das erste und letzte bleiben. Stell den Sinn wieder her.';

  @override
  String get scrambleBest => 'Verdreht (Rekord)';

  @override
  String get scrambleSessionsStat => 'Verdrehte Einheiten';

  @override
  String get progressTitle => 'Fortschritt';

  @override
  String get progressEmpty =>
      'Mach eine Übung, damit dein Fortschritt hier erscheint! 🚀';

  @override
  String get statBestSpeed => 'Beste Geschwindigkeit';

  @override
  String get statAvgSpeed => 'Durchschnitt';

  @override
  String get statStreak => 'Serie';

  @override
  String get statSessions => 'Einheiten';

  @override
  String get unitWpm => 'WpM';

  @override
  String get unitDays => 'Tag(e)';

  @override
  String get unitTotal => 'gesamt';

  @override
  String get speedEvolution => 'Geschwindigkeitsverlauf';

  @override
  String get chartMorePoints => 'Noch ein, zwei Übungen für die Kurve.';

  @override
  String get badgesTitle => 'Abzeichen';

  @override
  String get badgeFirst => 'Erste Einheit';

  @override
  String get badgeRegular => 'Fleißig · 3 Tage';

  @override
  String get badgeQuick => 'Flott · 300 WpM';

  @override
  String get badgeFlash => 'Blitz · 500 WpM';

  @override
  String get badgeExplorer => 'Entdecker';

  @override
  String goalReached(int count) {
    return 'Ziel erreicht: $count WpM 🎉';
  }

  @override
  String goalLabel(int count) {
    return 'Ziel: $count WpM';
  }

  @override
  String get libraryTitle => 'Texte';

  @override
  String get add => 'Hinzufügen';

  @override
  String get pasteText => 'Text einfügen';

  @override
  String get importFile => 'Datei importieren (EPUB / PDF)';

  @override
  String get importFileSubtitle => 'In Abschnitte von ~500 Wörtern geteilt';

  @override
  String get pasteDialogTitle => 'Text einfügen';

  @override
  String get titleOptional => 'Titel (optional)';

  @override
  String get pasteHint => 'Füge deinen Text hier ein';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get cannotReadFile => 'Datei konnte nicht gelesen werden.';

  @override
  String importedCount(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Abschnitte importiert',
      one: '1 Abschnitt importiert',
    );
    return '$_temp0 aus «$name».';
  }

  @override
  String importFailed(String error) {
    return 'Import fehlgeschlagen: $error';
  }

  @override
  String errorGeneric(String error) {
    return 'Fehler: $error';
  }

  @override
  String get noTextForExercise =>
      'Kein Text für diese Übung verfügbar.\nFüge einen Text im Tab «Texte» hinzu.';

  @override
  String get sourceUser => 'eigen';

  @override
  String get sourceCorpus => 'Korpus';

  @override
  String textMeta(int count, String source) {
    return '$count Wörter · $source';
  }

  @override
  String textPickerMeta(int count, String level) {
    return '$count Wörter · Stufe $level/5';
  }

  @override
  String bookExcerpts(int count, int words) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Abschnitte',
      one: '1 Abschnitt',
    );
    return '$_temp0 · $words Wörter';
  }

  @override
  String excerptN(int count) {
    return 'Abschnitt $count';
  }

  @override
  String excerptDone(int count) {
    return 'Fertig · $count Wörter';
  }

  @override
  String excerptReadPct(int pct, int count) {
    return 'Zu $pct % gelesen · $count Wörter';
  }

  @override
  String resumeExcerpt(int count) {
    return 'Fortsetzen (Abschnitt $count)';
  }

  @override
  String get startReading => 'Lesen beginnen';

  @override
  String get importedBook => 'Importiertes Buch';

  @override
  String get deleteBook => 'Buch löschen';

  @override
  String get launchExercise => 'Übung starten';

  @override
  String get rsvpTapPlay => 'Auf Wiedergabe tippen';

  @override
  String speedLabel(int count) {
    return 'Geschwindigkeit: $count Wörter/Min';
  }

  @override
  String get rsvpDone => 'Lesen abgeschlossen! 🎉';

  @override
  String rsvpSummary(int count, int wpm) {
    return '$count Wörter · $wpm WpM';
  }

  @override
  String groupLabel(int count) {
    return 'Gruppe: $count Wörter';
  }

  @override
  String get pacerDone => 'Pacer abgeschlossen! 🎉';

  @override
  String get doneReading => 'Ich bin fertig mit Lesen';

  @override
  String get validate => 'Bestätigen';

  @override
  String get finish => 'Fertig';

  @override
  String get wpmCaption => 'Wörter / Minute';

  @override
  String get comprehension => 'Verständnis';

  @override
  String get effectiveSpeed => 'Effektive Geschwindigkeit';

  @override
  String get skimHint =>
      'Überfliege die Hauptgedanken und beantworte dann die Fragen.';

  @override
  String get skimDone => 'Ich habe überflogen';

  @override
  String scanTargetLabel(String target) {
    return 'Finde im Text: «$target»';
  }

  @override
  String get yourAnswer => 'Deine Antwort';

  @override
  String scanFound(int seconds) {
    return 'In ${seconds}s gefunden!';
  }

  @override
  String get scanKeepLooking => 'Noch nicht… weitersuchen 🔎';

  @override
  String schulteLooking(int count) {
    return 'Suche: $count';
  }

  @override
  String schulteDone(int seconds, int errors) {
    String _temp0 = intl.Intl.pluralLogic(
      errors,
      locale: localeName,
      other: '$errors Fehler',
      one: '1 Fehler',
    );
    return 'In ${seconds}s fertig · $_temp0';
  }

  @override
  String get replay => 'Nochmal';

  @override
  String get start => 'Starten';

  @override
  String get inProgress => 'Läuft…';
}
