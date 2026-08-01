// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get tabTraining => 'Entrenamiento';

  @override
  String get tabTexts => 'Textos';

  @override
  String get tabProgress => 'Progreso';

  @override
  String get tabSettings => 'Ajustes';

  @override
  String get homeGreetingTitle => '¿Listo para leer más rápido?';

  @override
  String get homeGreetingSubtitle => 'Elige un ejercicio y progresa cada día.';

  @override
  String get continueSection => 'Continuar';

  @override
  String get resume => 'Reanudar';

  @override
  String get dailyGoalTitle => 'Objetivo del día';

  @override
  String get dailyGoalDone => '¡Sesión hecha hoy, bien hecho!';

  @override
  String get dailyGoalTodo => 'Haz una sesión para continuar.';

  @override
  String streakDays(int count) {
    return '$count d';
  }

  @override
  String get onbTitle => 'Bienvenido a Lira';

  @override
  String get onbSubtitle =>
      'Primero midamos tu velocidad de lectura actual, para fijarte un objetivo a tu medida.';

  @override
  String get onbMeasure => 'Medir mi velocidad';

  @override
  String get onbReadHint =>
      'Lee este texto a tu ritmo y luego pulsa «He terminado».';

  @override
  String get onbFinishReading => 'He terminado de leer';

  @override
  String get onbYourSpeed => 'Tu velocidad';

  @override
  String onbGoalLabel(int count) {
    return 'Tu objetivo: $count ppm';
  }

  @override
  String get onbStart => '¡Vamos! 🚀';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get darkTheme => 'Tema oscuro';

  @override
  String get defaultSpeed => 'Velocidad por defecto';

  @override
  String wpmValue(int count) {
    return '$count palabras/min';
  }

  @override
  String get groupSize => 'Tamaño de los grupos (guía)';

  @override
  String wordsValue(int count) {
    return '$count palabras';
  }

  @override
  String get slowLongWords => 'Ralentizar palabras largas (RSVP)';

  @override
  String get pauseOnPunctuation => 'Pausa en la puntuación (RSVP)';

  @override
  String get dailyReminder => 'Recordatorio diario';

  @override
  String get reminderTime => 'Hora del recordatorio';

  @override
  String get clearHistory => 'Borrar el historial';

  @override
  String get clearHistorySubtitle => 'Elimina todas las sesiones guardadas';

  @override
  String get historyCleared => 'Historial borrado';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Sistema (dispositivo)';

  @override
  String get aboutDescription =>
      'Entrenador de lectura rápida. Desarrollado con TDD.';

  @override
  String get exRsvpTitle => 'Lector RSVP';

  @override
  String get exRsvpSubtitle => 'Presentación visual serial rápida';

  @override
  String get exPacerTitle => 'Guía';

  @override
  String get exPacerSubtitle => 'Lectura por grupos, marcada';

  @override
  String get exSpeedTitle => 'Prueba de velocidad';

  @override
  String get exSpeedSubtitle => 'Palabras/min + comprensión';

  @override
  String get exSkimTitle => 'Ojeada';

  @override
  String get exSkimSubtitle => 'Captar la idea general';

  @override
  String get exScanTitle => 'Escaneo';

  @override
  String get exScanSubtitle => 'Localizar un dato concreto';

  @override
  String get exSchulteTitle => 'Tabla de Schulte';

  @override
  String get exSchulteSubtitle => 'Visión periférica';

  @override
  String get exScrambleTitle => 'Palabras mezcladas';

  @override
  String get exScrambleSubtitle => 'Leer pese al desorden';

  @override
  String get scrambleHint =>
      'Solo la primera y la última letra están en su sitio. Lee con normalidad: tu cerebro recompone las palabras.';

  @override
  String get scrambleDone => 'Ya he leído';

  @override
  String get scrambleShowOriginal => 'Ver el original';

  @override
  String get scrambleHighlight => 'Resaltar marcas';

  @override
  String get scrambleMarkers => 'Marcas (palabras mezcladas)';

  @override
  String get markColorEnds => 'En color';

  @override
  String get markDimMiddle => 'Centro atenuado';

  @override
  String get markUnderline => 'Subrayados';

  @override
  String get markNone => 'Ninguno';

  @override
  String get scrambleSpeedTitle => 'Lectura mezclada';

  @override
  String scrambleSpeedCompare(int percent, int ref) {
    return '$percent % de tu velocidad de lectura habitual (~$ref ppm).';
  }

  @override
  String get scrambleIntensity => 'Intensidad (palabras mezcladas)';

  @override
  String get intensityEasy => 'Fácil';

  @override
  String get intensityMedium => 'Medio';

  @override
  String get intensityHard => 'Difícil';

  @override
  String get scrambleTapHint => 'Toca una palabra para verla un instante.';

  @override
  String scrambleHints(int count) {
    return '$count pistas';
  }

  @override
  String get introTitle => 'El truco de las palabras mezcladas';

  @override
  String get introBody =>
      'Manteniendo la primera y la última letra de cada palabra, tu cerebro reconstruye el texto por la forma de las palabras, no letra a letra. Entrénate para leer rápido pese al desorden.';

  @override
  String get introGotIt => 'Entendido';

  @override
  String get scrambleTimed => 'Contrarreloj';

  @override
  String get scrambleComfort => 'Comodidad de lectura';

  @override
  String get scrambleComfortSub => 'Mayor interlineado y espaciado';

  @override
  String get scrambleStable => 'Mismo desorden cada vez';

  @override
  String get scrambleStableSub => 'Repite el mismo desorden para un texto dado';

  @override
  String get exWordsTitle => 'Frases mezcladas';

  @override
  String get exWordsSubtitle => 'Ordenar las palabras';

  @override
  String get exKeywordsTitle => 'Lectura por palabras clave';

  @override
  String get exKeywordsSubtitle => 'Pasar sobre las palabras vacías';

  @override
  String get keywordsHint =>
      'Las pequeñas palabras gramaticales están atenuadas: deja que la mirada resbale sobre ellas y se pose en las importantes.';

  @override
  String get kwNormal => 'Normal';

  @override
  String get kwDim => 'Atenuado';

  @override
  String get kwContent => 'Solo contenido';

  @override
  String get pacerProgressive => 'Amplitud progresiva';

  @override
  String get keywordsSpeedTitle => 'En lectura por palabras clave';

  @override
  String get reviewTitle => 'Repasos';

  @override
  String get reviewEmpty => 'No hay repasos para hoy. ¡Vuelve más tarde!';

  @override
  String reviewDone(int count) {
    return '¡Bien hecho: $count tarjeta(s) repasada(s)!';
  }

  @override
  String reviewProgress(int current, int total) {
    return 'Tarjeta $current de $total';
  }

  @override
  String get reviewMissing => 'Pregunta no encontrada (¿texto borrado?)';

  @override
  String get reviewShowAnswer => 'Ver la respuesta';

  @override
  String get srsAgain => 'Repetir';

  @override
  String get srsHard => 'Difícil';

  @override
  String get srsGood => 'Bien';

  @override
  String get srsEasy => 'Fácil';

  @override
  String homeReviewDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tarjetas por repasar',
      one: '1 tarjeta por repasar',
    );
    return '$_temp0';
  }

  @override
  String get homeReviewCta => 'Repasar ahora';

  @override
  String get wordsHint =>
      'Las palabras están desordenadas; la primera y la última no se mueven. Reconstruye el sentido.';

  @override
  String get scrambleBest => 'Mezclado (récord)';

  @override
  String get scrambleSessionsStat => 'Sesiones mezcladas';

  @override
  String get progressTitle => 'Progreso';

  @override
  String get progressEmpty => '¡Haz un ejercicio para ver tu progreso aquí! 🚀';

  @override
  String get statBestSpeed => 'Mejor velocidad';

  @override
  String get statAvgSpeed => 'Velocidad media';

  @override
  String get statStreak => 'Racha';

  @override
  String get statSessions => 'Sesiones';

  @override
  String get unitWpm => 'ppm';

  @override
  String get unitDays => 'día(s)';

  @override
  String get unitTotal => 'total';

  @override
  String get speedEvolution => 'Evolución de la velocidad';

  @override
  String get chartMorePoints =>
      'Uno o dos ejercicios más para trazar la curva.';

  @override
  String get badgesTitle => 'Insignias';

  @override
  String get badgeFirst => 'Primera sesión';

  @override
  String get badgeRegular => 'Constante · 3 días';

  @override
  String get badgeQuick => 'Ágil · 300 ppm';

  @override
  String get badgeFlash => 'Relámpago · 500 ppm';

  @override
  String get badgeExplorer => 'Explorador';

  @override
  String goalReached(int count) {
    return 'Objetivo alcanzado: $count ppm 🎉';
  }

  @override
  String goalLabel(int count) {
    return 'Objetivo: $count ppm';
  }

  @override
  String get libraryTitle => 'Textos';

  @override
  String get add => 'Añadir';

  @override
  String get pasteText => 'Pegar texto';

  @override
  String get importFile => 'Importar un archivo (EPUB / PDF)';

  @override
  String get importFileSubtitle => 'Dividido en extractos de ~500 palabras';

  @override
  String get pasteDialogTitle => 'Pegar un texto';

  @override
  String get titleOptional => 'Título (opcional)';

  @override
  String get pasteHint => 'Pega tu texto aquí';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cannotReadFile => 'No se pudo leer el archivo.';

  @override
  String importedCount(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count extractos importados',
      one: '1 extracto importado',
    );
    return '$_temp0 desde «$name».';
  }

  @override
  String importFailed(String error) {
    return 'Error al importar: $error';
  }

  @override
  String errorGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get noTextForExercise =>
      'No hay ningún texto disponible para este ejercicio.\nAñade un texto en la pestaña «Textos».';

  @override
  String get sourceUser => 'propio';

  @override
  String get sourceCorpus => 'corpus';

  @override
  String textMeta(int count, String source) {
    return '$count palabras · $source';
  }

  @override
  String textPickerMeta(int count, String level) {
    return '$count palabras · nivel $level/5';
  }

  @override
  String bookExcerpts(int count, int words) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count extractos',
      one: '1 extracto',
    );
    return '$_temp0 · $words palabras';
  }

  @override
  String excerptN(int count) {
    return 'Extracto $count';
  }

  @override
  String excerptDone(int count) {
    return 'Terminado · $count palabras';
  }

  @override
  String excerptReadPct(int pct, int count) {
    return 'Leído al $pct % · $count palabras';
  }

  @override
  String resumeExcerpt(int count) {
    return 'Reanudar (extracto $count)';
  }

  @override
  String get startReading => 'Empezar la lectura';

  @override
  String get importedBook => 'Libro importado';

  @override
  String get deleteBook => 'Eliminar el libro';

  @override
  String get launchExercise => 'Iniciar un ejercicio';

  @override
  String get rsvpTapPlay => 'Pulsa Reproducir';

  @override
  String speedLabel(int count) {
    return 'Velocidad: $count palabras/min';
  }

  @override
  String get rsvpDone => '¡Lectura terminada! 🎉';

  @override
  String rsvpSummary(int count, int wpm) {
    return '$count palabras · $wpm ppm';
  }

  @override
  String groupLabel(int count) {
    return 'Grupo: $count palabras';
  }

  @override
  String get pacerDone => '¡Guía terminada! 🎉';

  @override
  String get doneReading => 'He terminado de leer';

  @override
  String get validate => 'Validar';

  @override
  String get finish => 'Terminar';

  @override
  String get wpmCaption => 'palabras / minuto';

  @override
  String get comprehension => 'Comprensión';

  @override
  String get effectiveSpeed => 'Velocidad efectiva';

  @override
  String get skimHint =>
      'Repasa las ideas principales y luego responde a las preguntas.';

  @override
  String get skimDone => 'He repasado';

  @override
  String scanTargetLabel(String target) {
    return 'Localiza en el texto: «$target»';
  }

  @override
  String get yourAnswer => 'Tu respuesta';

  @override
  String scanFound(int seconds) {
    return '¡Encontrado en ${seconds}s!';
  }

  @override
  String get scanKeepLooking => 'Todavía no… sigue buscando 🔎';

  @override
  String schulteLooking(int count) {
    return 'Busca: $count';
  }

  @override
  String schulteDone(int seconds, int errors) {
    String _temp0 = intl.Intl.pluralLogic(
      errors,
      locale: localeName,
      other: '$errors errores',
      one: '1 error',
    );
    return 'Terminado en ${seconds}s · $_temp0';
  }

  @override
  String get replay => 'Repetir';

  @override
  String get start => 'Empezar';

  @override
  String get inProgress => 'En curso…';
}
