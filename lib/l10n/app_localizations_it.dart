// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get tabTraining => 'Allenamento';

  @override
  String get tabTexts => 'Testi';

  @override
  String get tabProgress => 'Progressi';

  @override
  String get tabSettings => 'Impostazioni';

  @override
  String get homeGreetingTitle => 'Pronto a leggere più veloce?';

  @override
  String get homeGreetingSubtitle =>
      'Scegli un esercizio e migliora ogni giorno.';

  @override
  String get continueSection => 'Continua';

  @override
  String get resume => 'Riprendi';

  @override
  String get dailyGoalTitle => 'Obiettivo del giorno';

  @override
  String get dailyGoalDone => 'Sessione fatta oggi, bravo!';

  @override
  String get dailyGoalTodo => 'Fai una sessione per continuare.';

  @override
  String streakDays(int count) {
    return '$count g';
  }

  @override
  String get onbTitle => 'Benvenuto in Lira';

  @override
  String get onbSubtitle =>
      'Misuriamo prima la tua velocità di lettura attuale, per fissarti un obiettivo su misura.';

  @override
  String get onbMeasure => 'Misura la mia velocità';

  @override
  String get onbReadHint =>
      'Leggi questo testo al tuo ritmo, poi tocca «Ho finito».';

  @override
  String get onbFinishReading => 'Ho finito di leggere';

  @override
  String get onbYourSpeed => 'La tua velocità';

  @override
  String onbGoalLabel(int count) {
    return 'Il tuo obiettivo: $count ppm';
  }

  @override
  String get onbStart => 'Si parte! 🚀';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get darkTheme => 'Tema scuro';

  @override
  String get defaultSpeed => 'Velocità predefinita';

  @override
  String wpmValue(int count) {
    return '$count parole/min';
  }

  @override
  String get groupSize => 'Dimensione dei gruppi (guida)';

  @override
  String wordsValue(int count) {
    return '$count parole';
  }

  @override
  String get slowLongWords => 'Rallenta le parole lunghe (RSVP)';

  @override
  String get pauseOnPunctuation => 'Pausa sulla punteggiatura (RSVP)';

  @override
  String get dailyReminder => 'Promemoria giornaliero';

  @override
  String get reminderTime => 'Ora del promemoria';

  @override
  String get clearHistory => 'Cancella la cronologia';

  @override
  String get clearHistorySubtitle => 'Elimina tutte le sessioni salvate';

  @override
  String get historyCleared => 'Cronologia cancellata';

  @override
  String get language => 'Lingua';

  @override
  String get languageSystem => 'Sistema (dispositivo)';

  @override
  String get aboutDescription =>
      'Allenatore di lettura veloce. Sviluppato con TDD.';

  @override
  String get exRsvpTitle => 'Lettore RSVP';

  @override
  String get exRsvpSubtitle => 'Presentazione visiva seriale rapida';

  @override
  String get exPacerTitle => 'Guida';

  @override
  String get exPacerSubtitle => 'Lettura a gruppi, ritmata';

  @override
  String get exSpeedTitle => 'Test di velocità';

  @override
  String get exSpeedSubtitle => 'Parole/min + comprensione';

  @override
  String get exSkimTitle => 'Scrematura';

  @override
  String get exSkimSubtitle => 'Cogliere l\'idea generale';

  @override
  String get exScanTitle => 'Scansione';

  @override
  String get exScanSubtitle => 'Trovare un\'informazione precisa';

  @override
  String get exSchulteTitle => 'Tavola di Schulte';

  @override
  String get exSchulteSubtitle => 'Visione periferica';

  @override
  String get exScrambleTitle => 'Parole mescolate';

  @override
  String get exScrambleSubtitle => 'Leggere nonostante il disordine';

  @override
  String get scrambleHint =>
      'Solo la prima e l\'ultima lettera restano al loro posto. Leggi normalmente: il cervello ricompone le parole.';

  @override
  String get scrambleDone => 'Ho letto';

  @override
  String get scrambleShowOriginal => 'Mostra l\'originale';

  @override
  String get scrambleHighlight => 'Evidenzia i segni';

  @override
  String get scrambleMarkers => 'Segni (parole mescolate)';

  @override
  String get markColorEnds => 'A colori';

  @override
  String get markDimMiddle => 'Centro attenuato';

  @override
  String get markUnderline => 'Sottolineati';

  @override
  String get markNone => 'Nessuno';

  @override
  String get scrambleSpeedTitle => 'Lettura mescolata';

  @override
  String scrambleSpeedCompare(int percent, int ref) {
    return '$percent % della tua velocità di lettura abituale (~$ref ppm).';
  }

  @override
  String get scrambleIntensity => 'Intensità (parole mescolate)';

  @override
  String get intensityEasy => 'Facile';

  @override
  String get intensityMedium => 'Medio';

  @override
  String get intensityHard => 'Difficile';

  @override
  String get scrambleTapHint => 'Tocca una parola per intravederla.';

  @override
  String scrambleHints(int count) {
    return '$count aiuti';
  }

  @override
  String get introTitle => 'Il trucco delle parole mescolate';

  @override
  String get introBody =>
      'Mantenendo la prima e l\'ultima lettera di ogni parola, il cervello ricostruisce il testo dalla forma delle parole, non lettera per lettera. Allenati a leggere in fretta nonostante il disordine.';

  @override
  String get introGotIt => 'Ho capito';

  @override
  String get scrambleTimed => 'A tempo';

  @override
  String get scrambleComfort => 'Comfort di lettura';

  @override
  String get scrambleComfortSub => 'Interlinea e spaziatura maggiori';

  @override
  String get scrambleStable => 'Stesso mescolamento ogni volta';

  @override
  String get scrambleStableSub => 'Ripete lo stesso mescolamento per un testo';

  @override
  String get exWordsTitle => 'Frasi mescolate';

  @override
  String get exWordsSubtitle => 'Rimetti le parole in ordine';

  @override
  String get exKeywordsTitle => 'Lettura per parole chiave';

  @override
  String get exKeywordsSubtitle => 'Scivolare sulle paroline';

  @override
  String get keywordsHint =>
      'Le piccole parole grammaticali sono attenuate: lascia scorrere lo sguardo su di esse e posalo sulle parole importanti.';

  @override
  String get kwNormal => 'Normale';

  @override
  String get kwDim => 'Attenuato';

  @override
  String get kwContent => 'Solo contenuto';

  @override
  String get pacerProgressive => 'Ampiezza progressiva';

  @override
  String get keywordsSpeedTitle => 'In lettura per parole chiave';

  @override
  String get reviewTitle => 'Ripassi';

  @override
  String get reviewEmpty => 'Nessun ripasso per oggi. Torna più tardi!';

  @override
  String reviewDone(int count) {
    return 'Ben fatto: $count carta/e ripassate!';
  }

  @override
  String reviewProgress(int current, int total) {
    return 'Carta $current di $total';
  }

  @override
  String get reviewMissing => 'Domanda non trovata (testo eliminato?)';

  @override
  String get reviewShowAnswer => 'Mostra la risposta';

  @override
  String get srsAgain => 'Da rivedere';

  @override
  String get srsHard => 'Difficile';

  @override
  String get srsGood => 'Bene';

  @override
  String get srsEasy => 'Facile';

  @override
  String homeReviewDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count carte da ripassare',
      one: '1 carta da ripassare',
    );
    return '$_temp0';
  }

  @override
  String get homeReviewCta => 'Ripassa ora';

  @override
  String get exColumnsTitle => 'Lettura a colonne';

  @override
  String get exColumnsSubtitle => 'Meno fissazioni per riga';

  @override
  String get columnsHint =>
      'Il testo è in colonne strette: forza gli occhi a saltare più spesso — coglierai più parole a ogni fissazione.';

  @override
  String columnsCount(int count) {
    return '$count colonne';
  }

  @override
  String get exNoSubvocalTitle => 'Senza voce interiore';

  @override
  String get exNoSubvocalSubtitle => 'Contare mentalmente leggendo';

  @override
  String get noSubvocalHint =>
      'Segui con gli occhi il ritmo 1‑2‑3‑4 mentre leggi: la voce interiore è occupata, riconosci le parole dalla forma.';

  @override
  String noSubvocalTempo(int count) {
    return 'Tempo: $count bpm';
  }

  @override
  String get takeNotes => 'Prendi appunti';

  @override
  String get noteEditorTitle => 'I miei appunti';

  @override
  String get save => 'Salva';

  @override
  String get noteTabSummary => 'Riassunto';

  @override
  String get noteTabCornell => 'Cornell';

  @override
  String get noteSummaryHint =>
      'In 3 frasi riassumi quello che hai letto. Breve, preciso: ancora il senso.';

  @override
  String get noteSummaryPlaceholder => 'Idea 1, idea 2, idea 3…';

  @override
  String get noteCornellHint =>
      'Metodo Cornell: appunti dettagliati a destra, parole chiave/domande a sinistra, riassunto in basso.';

  @override
  String get noteCornellCues => 'Parole chiave / domande';

  @override
  String get noteCornellCuesHint => 'Una parola per riga';

  @override
  String get noteCornellNotes => 'Appunti';

  @override
  String get noteCornellNotesHint => 'Scrivi ciò che ricordi';

  @override
  String get noteCornellSummary => 'Riassunto';

  @override
  String get myNotes => 'I miei appunti';

  @override
  String get myNotesEmpty =>
      'Nessun appunto per ora. Prendine uno dopo un esercizio!';

  @override
  String get mnemonicsTitle => 'Tecniche di memorizzazione';

  @override
  String get mnemonicsSubtitle => 'Palazzo della memoria, chunking, immagini…';

  @override
  String get exCompetitionTitle => 'Competizione';

  @override
  String get exCompetitionSubtitle =>
      'Punteggio composito = ppm × comprensione';

  @override
  String get competitionReadHint =>
      'Leggi veloce E bene: il punteggio finale combina i due.';

  @override
  String get competitionDone => 'Ho finito';

  @override
  String get competitionScoreLabel => 'PUNTEGGIO';

  @override
  String get competitionScoreCaption => 'parole efficaci / min';

  @override
  String get exSpeedCapTitle => 'Velocità limite';

  @override
  String get exSpeedCapSubtitle => 'Trova la tua ppm massima utile';

  @override
  String get speedCapHint =>
      'La velocità sale ogni 10 s. Tocca STOP appena perdi il filo; il quiz confermerà se il tuo limite è reale.';

  @override
  String get speedCapStop => 'STOP mi perdo';

  @override
  String get speedCapValidated => '✓ comprensione mantenuta';

  @override
  String get speedCapCeiling => 'IL TUO LIMITE';

  @override
  String speedCapReal(int percent) {
    return 'Limite convalidato: $percent % di comprensione.';
  }

  @override
  String speedCapFake(int percent) {
    return 'Troppo veloce: solo $percent % di comprensione. Scala di un gradino.';
  }

  @override
  String get wordsHint =>
      'Le parole sono in disordine; la prima e l\'ultima restano al loro posto. Ricostruisci il senso.';

  @override
  String get scrambleBest => 'Mescolato (record)';

  @override
  String get scrambleSessionsStat => 'Sessioni mescolate';

  @override
  String get progressTitle => 'Progressi';

  @override
  String get progressEmpty =>
      'Fai un esercizio per vedere i tuoi progressi qui! 🚀';

  @override
  String get statBestSpeed => 'Velocità migliore';

  @override
  String get statAvgSpeed => 'Velocità media';

  @override
  String get statStreak => 'Serie';

  @override
  String get statSessions => 'Sessioni';

  @override
  String get unitWpm => 'ppm';

  @override
  String get unitDays => 'giorno/i';

  @override
  String get unitTotal => 'totale';

  @override
  String get speedEvolution => 'Andamento della velocità';

  @override
  String get chartMorePoints =>
      'Ancora uno o due esercizi per tracciare la curva.';

  @override
  String get badgesTitle => 'Distintivi';

  @override
  String get badgeFirst => 'Prima sessione';

  @override
  String get badgeRegular => 'Costante · 3 giorni';

  @override
  String get badgeQuick => 'Sveglio · 300 ppm';

  @override
  String get badgeFlash => 'Fulmine · 500 ppm';

  @override
  String get badgeExplorer => 'Esploratore';

  @override
  String goalReached(int count) {
    return 'Obiettivo raggiunto: $count ppm 🎉';
  }

  @override
  String goalLabel(int count) {
    return 'Obiettivo: $count ppm';
  }

  @override
  String get libraryTitle => 'Testi';

  @override
  String get add => 'Aggiungi';

  @override
  String get pasteText => 'Incolla testo';

  @override
  String get importFile => 'Importa un file (EPUB / PDF)';

  @override
  String get importFileSubtitle => 'Diviso in estratti di ~500 parole';

  @override
  String get pasteDialogTitle => 'Incolla un testo';

  @override
  String get titleOptional => 'Titolo (facoltativo)';

  @override
  String get pasteHint => 'Incolla qui il tuo testo';

  @override
  String get cancel => 'Annulla';

  @override
  String get cannotReadFile => 'Impossibile leggere il file.';

  @override
  String importedCount(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count estratti importati',
      one: '1 estratto importato',
    );
    return '$_temp0 da «$name».';
  }

  @override
  String importFailed(String error) {
    return 'Importazione non riuscita: $error';
  }

  @override
  String errorGeneric(String error) {
    return 'Errore: $error';
  }

  @override
  String get noTextForExercise =>
      'Nessun testo disponibile per questo esercizio.\nAggiungi un testo nella scheda «Testi».';

  @override
  String get sourceUser => 'personale';

  @override
  String get sourceCorpus => 'corpus';

  @override
  String textMeta(int count, String source) {
    return '$count parole · $source';
  }

  @override
  String textPickerMeta(int count, String level) {
    return '$count parole · livello $level/5';
  }

  @override
  String bookExcerpts(int count, int words) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count estratti',
      one: '1 estratto',
    );
    return '$_temp0 · $words parole';
  }

  @override
  String excerptN(int count) {
    return 'Estratto $count';
  }

  @override
  String excerptDone(int count) {
    return 'Completato · $count parole';
  }

  @override
  String excerptReadPct(int pct, int count) {
    return 'Letto al $pct % · $count parole';
  }

  @override
  String resumeExcerpt(int count) {
    return 'Riprendi (estratto $count)';
  }

  @override
  String get startReading => 'Inizia la lettura';

  @override
  String get importedBook => 'Libro importato';

  @override
  String get deleteBook => 'Elimina il libro';

  @override
  String get launchExercise => 'Avvia un esercizio';

  @override
  String get rsvpTapPlay => 'Tocca Riproduci';

  @override
  String speedLabel(int count) {
    return 'Velocità: $count parole/min';
  }

  @override
  String get rsvpDone => 'Lettura completata! 🎉';

  @override
  String rsvpSummary(int count, int wpm) {
    return '$count parole · $wpm ppm';
  }

  @override
  String groupLabel(int count) {
    return 'Gruppo: $count parole';
  }

  @override
  String get pacerDone => 'Guida completata! 🎉';

  @override
  String get doneReading => 'Ho finito di leggere';

  @override
  String get validate => 'Conferma';

  @override
  String get finish => 'Termina';

  @override
  String get wpmCaption => 'parole / minuto';

  @override
  String get comprehension => 'Comprensione';

  @override
  String get effectiveSpeed => 'Velocità effettiva';

  @override
  String get skimHint =>
      'Scorri le idee principali, poi rispondi alle domande.';

  @override
  String get skimDone => 'Ho scorso';

  @override
  String scanTargetLabel(String target) {
    return 'Trova nel testo: «$target»';
  }

  @override
  String get yourAnswer => 'La tua risposta';

  @override
  String scanFound(int seconds) {
    return 'Trovato in ${seconds}s!';
  }

  @override
  String get scanKeepLooking => 'Non ancora… continua a cercare 🔎';

  @override
  String schulteLooking(int count) {
    return 'Cerca: $count';
  }

  @override
  String schulteDone(int seconds, int errors) {
    String _temp0 = intl.Intl.pluralLogic(
      errors,
      locale: localeName,
      other: '$errors errori',
      one: '1 errore',
    );
    return 'Completato in ${seconds}s · $_temp0';
  }

  @override
  String get replay => 'Rigioca';

  @override
  String get start => 'Inizia';

  @override
  String get inProgress => 'In corso…';
}
