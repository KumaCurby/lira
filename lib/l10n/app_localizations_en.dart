// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tabTraining => 'Training';

  @override
  String get tabTexts => 'Texts';

  @override
  String get tabProgress => 'Progress';

  @override
  String get tabSettings => 'Settings';

  @override
  String get homeGreetingTitle => 'Ready to read faster?';

  @override
  String get homeGreetingSubtitle => 'Pick an exercise and improve every day.';

  @override
  String get continueSection => 'Continue';

  @override
  String get resume => 'Resume';

  @override
  String get dailyGoalTitle => 'Daily goal';

  @override
  String get dailyGoalDone => 'Session done today, well done!';

  @override
  String get dailyGoalTodo => 'Do a session to keep going.';

  @override
  String streakDays(int count) {
    return '${count}d';
  }

  @override
  String get onbTitle => 'Welcome to Lira';

  @override
  String get onbSubtitle =>
      'Let\'s first measure your current reading speed to set you a tailored goal.';

  @override
  String get onbMeasure => 'Measure my speed';

  @override
  String get onbReadHint =>
      'Read this text at your own pace, then tap \"I\'m done\".';

  @override
  String get onbFinishReading => 'I\'m done reading';

  @override
  String get onbYourSpeed => 'Your speed';

  @override
  String onbGoalLabel(int count) {
    return 'Your goal: $count wpm';
  }

  @override
  String get onbStart => 'Let\'s go! 🚀';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get defaultSpeed => 'Default speed';

  @override
  String wpmValue(int count) {
    return '$count wpm';
  }

  @override
  String get groupSize => 'Group size (pacer)';

  @override
  String wordsValue(int count) {
    return '$count words';
  }

  @override
  String get slowLongWords => 'Slow down long words (RSVP)';

  @override
  String get pauseOnPunctuation => 'Pause on punctuation (RSVP)';

  @override
  String get dailyReminder => 'Daily reminder';

  @override
  String get reminderTime => 'Reminder time';

  @override
  String get clearHistory => 'Clear history';

  @override
  String get clearHistorySubtitle => 'Deletes all recorded sessions';

  @override
  String get historyCleared => 'History cleared';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System (device)';

  @override
  String get aboutDescription => 'Speed-reading trainer. Built with TDD.';

  @override
  String get exRsvpTitle => 'RSVP reader';

  @override
  String get exRsvpSubtitle => 'Rapid Serial Visual Presentation';

  @override
  String get exPacerTitle => 'Pacer';

  @override
  String get exPacerSubtitle => 'Paced group reading';

  @override
  String get exSpeedTitle => 'Speed test';

  @override
  String get exSpeedSubtitle => 'Wpm + comprehension';

  @override
  String get exSkimTitle => 'Skimming';

  @override
  String get exSkimSubtitle => 'Grasp the main idea';

  @override
  String get exScanTitle => 'Scanning';

  @override
  String get exScanSubtitle => 'Find a specific detail';

  @override
  String get exSchulteTitle => 'Schulte table';

  @override
  String get exSchulteSubtitle => 'Peripheral vision';

  @override
  String get exScrambleTitle => 'Scrambled words';

  @override
  String get exScrambleSubtitle => 'Read through the jumble';

  @override
  String get scrambleHint =>
      'Only the first and last letter stay put. Just read normally — your brain restores the words.';

  @override
  String get scrambleDone => 'I\'ve read it';

  @override
  String get scrambleShowOriginal => 'Show original';

  @override
  String get scrambleHighlight => 'Highlight markers';

  @override
  String get scrambleMarkers => 'Markers (scrambled words)';

  @override
  String get markColorEnds => 'Colored';

  @override
  String get markDimMiddle => 'Dimmed middle';

  @override
  String get markUnderline => 'Underlined';

  @override
  String get markNone => 'None';

  @override
  String get scrambleSpeedTitle => 'Scrambled reading';

  @override
  String scrambleSpeedCompare(int percent, int ref) {
    return '$percent% of your usual reading speed (~$ref wpm).';
  }

  @override
  String get scrambleIntensity => 'Intensity (scrambled words)';

  @override
  String get intensityEasy => 'Easy';

  @override
  String get intensityMedium => 'Medium';

  @override
  String get intensityHard => 'Hard';

  @override
  String get scrambleTapHint => 'Tap a word for a quick peek.';

  @override
  String scrambleHints(int count) {
    return '$count hints';
  }

  @override
  String get introTitle => 'The scrambled-words trick';

  @override
  String get introBody =>
      'By keeping the first and last letter of each word, your brain rebuilds the text from word shapes — not letter by letter. Practise reading fast despite the jumble.';

  @override
  String get introGotIt => 'Got it';

  @override
  String get scrambleTimed => 'Timed';

  @override
  String get scrambleComfort => 'Reading comfort';

  @override
  String get scrambleComfortSub => 'Larger line and letter spacing';

  @override
  String get scrambleStable => 'Same scramble every time';

  @override
  String get scrambleStableSub => 'Replays the same scramble for a given text';

  @override
  String get exWordsTitle => 'Scrambled sentences';

  @override
  String get exWordsSubtitle => 'Put the words back in order';

  @override
  String get exKeywordsTitle => 'Keyword reading';

  @override
  String get exKeywordsSubtitle => 'Skim over the small words';

  @override
  String get keywordsHint =>
      'The small grammar words are dimmed: let your eyes glide over them and land on the words that matter.';

  @override
  String get kwNormal => 'Normal';

  @override
  String get kwDim => 'Dimmed';

  @override
  String get kwContent => 'Content only';

  @override
  String get pacerProgressive => 'Progressive span';

  @override
  String get keywordsSpeedTitle => 'Keyword reading';

  @override
  String get reviewTitle => 'Reviews';

  @override
  String get reviewEmpty => 'No reviews due today. Come back later!';

  @override
  String reviewDone(int count) {
    return 'Well done — $count card(s) reviewed!';
  }

  @override
  String reviewProgress(int current, int total) {
    return 'Card $current of $total';
  }

  @override
  String get reviewMissing => 'Question not found (text deleted?)';

  @override
  String get reviewShowAnswer => 'Show answer';

  @override
  String get srsAgain => 'Again';

  @override
  String get srsHard => 'Hard';

  @override
  String get srsGood => 'Good';

  @override
  String get srsEasy => 'Easy';

  @override
  String homeReviewDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards to review',
      one: '1 card to review',
    );
    return '$_temp0';
  }

  @override
  String get homeReviewCta => 'Review now';

  @override
  String get exColumnsTitle => 'Column reading';

  @override
  String get exColumnsSubtitle => 'Fewer fixations per line';

  @override
  String get columnsHint =>
      'Text is laid out in narrow columns: force your eyes to hop more often — you\'ll take in more words per fixation.';

  @override
  String columnsCount(int count) {
    return '$count columns';
  }

  @override
  String get exNoSubvocalTitle => 'Silence the inner voice';

  @override
  String get exNoSubvocalSubtitle => 'Count mentally while reading';

  @override
  String get noSubvocalHint =>
      'Follow the 1‑2‑3‑4 beat with your eyes while reading: your inner voice is busy, forcing you to recognise words by shape.';

  @override
  String noSubvocalTempo(int count) {
    return 'Tempo: $count bpm';
  }

  @override
  String get takeNotes => 'Take notes';

  @override
  String get noteEditorTitle => 'My notes';

  @override
  String get save => 'Save';

  @override
  String get noteTabSummary => 'Summary';

  @override
  String get noteTabCornell => 'Cornell';

  @override
  String get noteSummaryHint =>
      'In 3 sentences, sum up what you just read. Short, precise — it anchors the meaning.';

  @override
  String get noteSummaryPlaceholder => 'Idea 1, idea 2, idea 3…';

  @override
  String get noteCornellHint =>
      'Cornell method: detailed notes on the right, cues/questions on the left, final summary at the bottom.';

  @override
  String get noteCornellCues => 'Cues / questions';

  @override
  String get noteCornellCuesHint => 'One word per line';

  @override
  String get noteCornellNotes => 'Notes';

  @override
  String get noteCornellNotesHint => 'Write what you take away';

  @override
  String get noteCornellSummary => 'Summary';

  @override
  String get myNotes => 'My notes';

  @override
  String get myNotesEmpty => 'No notes yet. Take one after an exercise!';

  @override
  String get mnemonicsTitle => 'Memory techniques';

  @override
  String get mnemonicsSubtitle => 'Memory palace, chunking, imagery…';

  @override
  String get wordsHint =>
      'The words are shuffled; the first and last stay put. Rebuild the meaning.';

  @override
  String get scrambleBest => 'Scrambled (best)';

  @override
  String get scrambleSessionsStat => 'Scrambled sessions';

  @override
  String get progressTitle => 'Progress';

  @override
  String get progressEmpty =>
      'Do an exercise to see your progress appear here! 🚀';

  @override
  String get statBestSpeed => 'Best speed';

  @override
  String get statAvgSpeed => 'Average speed';

  @override
  String get statStreak => 'Streak';

  @override
  String get statSessions => 'Sessions';

  @override
  String get unitWpm => 'wpm';

  @override
  String get unitDays => 'day(s)';

  @override
  String get unitTotal => 'total';

  @override
  String get speedEvolution => 'Speed over time';

  @override
  String get chartMorePoints => 'A couple more exercises to plot the curve.';

  @override
  String get badgesTitle => 'Badges';

  @override
  String get badgeFirst => 'First session';

  @override
  String get badgeRegular => 'Regular · 3 days';

  @override
  String get badgeQuick => 'Quick · 300 wpm';

  @override
  String get badgeFlash => 'Flash · 500 wpm';

  @override
  String get badgeExplorer => 'Explorer';

  @override
  String goalReached(int count) {
    return 'Goal reached: $count wpm 🎉';
  }

  @override
  String goalLabel(int count) {
    return 'Goal: $count wpm';
  }

  @override
  String get libraryTitle => 'Texts';

  @override
  String get add => 'Add';

  @override
  String get pasteText => 'Paste text';

  @override
  String get importFile => 'Import a file (EPUB / PDF)';

  @override
  String get importFileSubtitle => 'Split into ~500-word excerpts';

  @override
  String get pasteDialogTitle => 'Paste a text';

  @override
  String get titleOptional => 'Title (optional)';

  @override
  String get pasteHint => 'Paste your text here';

  @override
  String get cancel => 'Cancel';

  @override
  String get cannotReadFile => 'Couldn\'t read the file.';

  @override
  String importedCount(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count excerpts imported',
      one: '1 excerpt imported',
    );
    return '$_temp0 from \"$name\".';
  }

  @override
  String importFailed(String error) {
    return 'Import failed: $error';
  }

  @override
  String errorGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get noTextForExercise =>
      'No text available for this exercise.\nAdd a text in the \"Texts\" tab.';

  @override
  String get sourceUser => 'mine';

  @override
  String get sourceCorpus => 'corpus';

  @override
  String textMeta(int count, String source) {
    return '$count words · $source';
  }

  @override
  String textPickerMeta(int count, String level) {
    return '$count words · level $level/5';
  }

  @override
  String bookExcerpts(int count, int words) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count excerpts',
      one: '1 excerpt',
    );
    return '$_temp0 · $words words';
  }

  @override
  String excerptN(int count) {
    return 'Excerpt $count';
  }

  @override
  String excerptDone(int count) {
    return 'Done · $count words';
  }

  @override
  String excerptReadPct(int pct, int count) {
    return '$pct% read · $count words';
  }

  @override
  String resumeExcerpt(int count) {
    return 'Resume (excerpt $count)';
  }

  @override
  String get startReading => 'Start reading';

  @override
  String get importedBook => 'Imported book';

  @override
  String get deleteBook => 'Delete book';

  @override
  String get launchExercise => 'Start an exercise';

  @override
  String get rsvpTapPlay => 'Tap Play';

  @override
  String speedLabel(int count) {
    return 'Speed: $count wpm';
  }

  @override
  String get rsvpDone => 'Reading complete! 🎉';

  @override
  String rsvpSummary(int count, int wpm) {
    return '$count words · $wpm wpm';
  }

  @override
  String groupLabel(int count) {
    return 'Group: $count words';
  }

  @override
  String get pacerDone => 'Pacing complete! 🎉';

  @override
  String get doneReading => 'I\'m done reading';

  @override
  String get validate => 'Submit';

  @override
  String get finish => 'Finish';

  @override
  String get wpmCaption => 'words / minute';

  @override
  String get comprehension => 'Comprehension';

  @override
  String get effectiveSpeed => 'Effective speed';

  @override
  String get skimHint => 'Skim the key ideas, then answer the questions.';

  @override
  String get skimDone => 'I\'ve skimmed';

  @override
  String scanTargetLabel(String target) {
    return 'Find in the text: \"$target\"';
  }

  @override
  String get yourAnswer => 'Your answer';

  @override
  String scanFound(int seconds) {
    return 'Found in ${seconds}s!';
  }

  @override
  String get scanKeepLooking => 'Not yet… keep looking 🔎';

  @override
  String schulteLooking(int count) {
    return 'Find: $count';
  }

  @override
  String schulteDone(int seconds, int errors) {
    String _temp0 = intl.Intl.pluralLogic(
      errors,
      locale: localeName,
      other: '$errors errors',
      one: '1 error',
    );
    return 'Done in ${seconds}s · $_temp0';
  }

  @override
  String get replay => 'Replay';

  @override
  String get start => 'Start';

  @override
  String get inProgress => 'In progress…';
}
