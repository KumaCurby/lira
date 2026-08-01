// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get tabTraining => 'Treino';

  @override
  String get tabTexts => 'Textos';

  @override
  String get tabProgress => 'Progresso';

  @override
  String get tabSettings => 'Definições';

  @override
  String get homeGreetingTitle => 'Pronto para ler mais depressa?';

  @override
  String get homeGreetingSubtitle =>
      'Escolhe um exercício e melhora todos os dias.';

  @override
  String get continueSection => 'Continuar';

  @override
  String get resume => 'Retomar';

  @override
  String get dailyGoalTitle => 'Objetivo do dia';

  @override
  String get dailyGoalDone => 'Sessão feita hoje, parabéns!';

  @override
  String get dailyGoalTodo => 'Faz uma sessão para continuar.';

  @override
  String streakDays(int count) {
    return '$count d';
  }

  @override
  String get onbTitle => 'Bem-vindo ao Lira';

  @override
  String get onbSubtitle =>
      'Vamos primeiro medir a tua velocidade de leitura atual, para definir um objetivo à tua medida.';

  @override
  String get onbMeasure => 'Medir a minha velocidade';

  @override
  String get onbReadHint =>
      'Lê este texto ao teu ritmo e depois toca em «Terminei».';

  @override
  String get onbFinishReading => 'Terminei de ler';

  @override
  String get onbYourSpeed => 'A tua velocidade';

  @override
  String onbGoalLabel(int count) {
    return 'O teu objetivo: $count ppm';
  }

  @override
  String get onbStart => 'Vamos lá! 🚀';

  @override
  String get settingsTitle => 'Definições';

  @override
  String get darkTheme => 'Tema escuro';

  @override
  String get defaultSpeed => 'Velocidade predefinida';

  @override
  String wpmValue(int count) {
    return '$count palavras/min';
  }

  @override
  String get groupSize => 'Tamanho dos grupos (guia)';

  @override
  String wordsValue(int count) {
    return '$count palavras';
  }

  @override
  String get slowLongWords => 'Abrandar palavras longas (RSVP)';

  @override
  String get pauseOnPunctuation => 'Pausa na pontuação (RSVP)';

  @override
  String get dailyReminder => 'Lembrete diário';

  @override
  String get reminderTime => 'Hora do lembrete';

  @override
  String get clearHistory => 'Limpar o histórico';

  @override
  String get clearHistorySubtitle => 'Elimina todas as sessões guardadas';

  @override
  String get historyCleared => 'Histórico limpo';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Sistema (dispositivo)';

  @override
  String get aboutDescription =>
      'Treinador de leitura rápida. Desenvolvido com TDD.';

  @override
  String get exRsvpTitle => 'Leitor RSVP';

  @override
  String get exRsvpSubtitle => 'Apresentação visual serial rápida';

  @override
  String get exPacerTitle => 'Guia';

  @override
  String get exPacerSubtitle => 'Leitura por grupos, ritmada';

  @override
  String get exSpeedTitle => 'Teste de velocidade';

  @override
  String get exSpeedSubtitle => 'Palavras/min + compreensão';

  @override
  String get exSkimTitle => 'Leitura por alto';

  @override
  String get exSkimSubtitle => 'Captar a ideia geral';

  @override
  String get exScanTitle => 'Varrimento';

  @override
  String get exScanSubtitle => 'Localizar uma informação precisa';

  @override
  String get exSchulteTitle => 'Tabela de Schulte';

  @override
  String get exSchulteSubtitle => 'Visão periférica';

  @override
  String get exScrambleTitle => 'Palavras baralhadas';

  @override
  String get exScrambleSubtitle => 'Ler apesar da desordem';

  @override
  String get scrambleHint =>
      'Só a primeira e a última letra ficam no lugar. Lê normalmente: o teu cérebro recompõe as palavras.';

  @override
  String get scrambleDone => 'Já li';

  @override
  String get scrambleShowOriginal => 'Ver o original';

  @override
  String get scrambleHighlight => 'Realçar marcas';

  @override
  String get scrambleMarkers => 'Marcas (palavras baralhadas)';

  @override
  String get markColorEnds => 'A cores';

  @override
  String get markDimMiddle => 'Centro esbatido';

  @override
  String get markUnderline => 'Sublinhados';

  @override
  String get markNone => 'Nenhum';

  @override
  String get scrambleSpeedTitle => 'Leitura baralhada';

  @override
  String scrambleSpeedCompare(int percent, int ref) {
    return '$percent % da tua velocidade de leitura habitual (~$ref ppm).';
  }

  @override
  String get scrambleIntensity => 'Intensidade (palavras baralhadas)';

  @override
  String get intensityEasy => 'Fácil';

  @override
  String get intensityMedium => 'Médio';

  @override
  String get intensityHard => 'Difícil';

  @override
  String get scrambleTapHint => 'Toca numa palavra para a espreitar.';

  @override
  String scrambleHints(int count) {
    return '$count ajudas';
  }

  @override
  String get introTitle => 'O truque das palavras baralhadas';

  @override
  String get introBody =>
      'Mantendo a primeira e a última letra de cada palavra, o teu cérebro reconstrói o texto pela forma das palavras, não letra a letra. Treina para ler depressa apesar da desordem.';

  @override
  String get introGotIt => 'Percebi';

  @override
  String get scrambleTimed => 'Contra o tempo';

  @override
  String get scrambleComfort => 'Conforto de leitura';

  @override
  String get scrambleComfortSub => 'Maior espaçamento de linhas e letras';

  @override
  String get scrambleStable => 'O mesmo baralhamento sempre';

  @override
  String get scrambleStableSub => 'Repete o mesmo baralhamento para um texto';

  @override
  String get exWordsTitle => 'Frases baralhadas';

  @override
  String get exWordsSubtitle => 'Ordenar as palavras';

  @override
  String get exKeywordsTitle => 'Leitura por palavras-chave';

  @override
  String get exKeywordsSubtitle => 'Deslizar sobre as palavras pequenas';

  @override
  String get keywordsHint =>
      'As pequenas palavras gramaticais estão esbatidas: deixa o olhar deslizar sobre elas e pousar nas palavras importantes.';

  @override
  String get kwNormal => 'Normal';

  @override
  String get kwDim => 'Esbatido';

  @override
  String get kwContent => 'Só conteúdo';

  @override
  String get pacerProgressive => 'Amplitude progressiva';

  @override
  String get keywordsSpeedTitle => 'Em leitura por palavras-chave';

  @override
  String get reviewTitle => 'Revisões';

  @override
  String get reviewEmpty => 'Nenhuma revisão hoje. Volta mais tarde!';

  @override
  String reviewDone(int count) {
    return 'Muito bem: $count cartão(ões) revisto(s)!';
  }

  @override
  String reviewProgress(int current, int total) {
    return 'Cartão $current de $total';
  }

  @override
  String get reviewMissing => 'Pergunta não encontrada (texto apagado?)';

  @override
  String get reviewShowAnswer => 'Ver a resposta';

  @override
  String get srsAgain => 'Rever';

  @override
  String get srsHard => 'Difícil';

  @override
  String get srsGood => 'Bem';

  @override
  String get srsEasy => 'Fácil';

  @override
  String homeReviewDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartões para rever',
      one: '1 cartão para rever',
    );
    return '$_temp0';
  }

  @override
  String get homeReviewCta => 'Rever agora';

  @override
  String get wordsHint =>
      'As palavras estão desordenadas; a primeira e a última ficam no lugar. Reconstrói o sentido.';

  @override
  String get scrambleBest => 'Baralhado (recorde)';

  @override
  String get scrambleSessionsStat => 'Sessões baralhadas';

  @override
  String get progressTitle => 'Progresso';

  @override
  String get progressEmpty =>
      'Faz um exercício para veres o teu progresso aqui! 🚀';

  @override
  String get statBestSpeed => 'Melhor velocidade';

  @override
  String get statAvgSpeed => 'Velocidade média';

  @override
  String get statStreak => 'Sequência';

  @override
  String get statSessions => 'Sessões';

  @override
  String get unitWpm => 'ppm';

  @override
  String get unitDays => 'dia(s)';

  @override
  String get unitTotal => 'total';

  @override
  String get speedEvolution => 'Evolução da velocidade';

  @override
  String get chartMorePoints =>
      'Mais um ou dois exercícios para traçar a curva.';

  @override
  String get badgesTitle => 'Emblemas';

  @override
  String get badgeFirst => 'Primeira sessão';

  @override
  String get badgeRegular => 'Assíduo · 3 dias';

  @override
  String get badgeQuick => 'Rápido · 300 ppm';

  @override
  String get badgeFlash => 'Relâmpago · 500 ppm';

  @override
  String get badgeExplorer => 'Explorador';

  @override
  String goalReached(int count) {
    return 'Objetivo alcançado: $count ppm 🎉';
  }

  @override
  String goalLabel(int count) {
    return 'Objetivo: $count ppm';
  }

  @override
  String get libraryTitle => 'Textos';

  @override
  String get add => 'Adicionar';

  @override
  String get pasteText => 'Colar texto';

  @override
  String get importFile => 'Importar um ficheiro (EPUB / PDF)';

  @override
  String get importFileSubtitle => 'Dividido em excertos de ~500 palavras';

  @override
  String get pasteDialogTitle => 'Colar um texto';

  @override
  String get titleOptional => 'Título (opcional)';

  @override
  String get pasteHint => 'Cola o teu texto aqui';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cannotReadFile => 'Não foi possível ler o ficheiro.';

  @override
  String importedCount(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count excertos importados',
      one: '1 excerto importado',
    );
    return '$_temp0 de «$name».';
  }

  @override
  String importFailed(String error) {
    return 'Falha na importação: $error';
  }

  @override
  String errorGeneric(String error) {
    return 'Erro: $error';
  }

  @override
  String get noTextForExercise =>
      'Nenhum texto disponível para este exercício.\nAdiciona um texto no separador «Textos».';

  @override
  String get sourceUser => 'pessoal';

  @override
  String get sourceCorpus => 'corpus';

  @override
  String textMeta(int count, String source) {
    return '$count palavras · $source';
  }

  @override
  String textPickerMeta(int count, String level) {
    return '$count palavras · nível $level/5';
  }

  @override
  String bookExcerpts(int count, int words) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count excertos',
      one: '1 excerto',
    );
    return '$_temp0 · $words palavras';
  }

  @override
  String excerptN(int count) {
    return 'Excerto $count';
  }

  @override
  String excerptDone(int count) {
    return 'Concluído · $count palavras';
  }

  @override
  String excerptReadPct(int pct, int count) {
    return 'Lido a $pct % · $count palavras';
  }

  @override
  String resumeExcerpt(int count) {
    return 'Retomar (excerto $count)';
  }

  @override
  String get startReading => 'Começar a leitura';

  @override
  String get importedBook => 'Livro importado';

  @override
  String get deleteBook => 'Eliminar o livro';

  @override
  String get launchExercise => 'Iniciar um exercício';

  @override
  String get rsvpTapPlay => 'Toca em Reproduzir';

  @override
  String speedLabel(int count) {
    return 'Velocidade: $count palavras/min';
  }

  @override
  String get rsvpDone => 'Leitura concluída! 🎉';

  @override
  String rsvpSummary(int count, int wpm) {
    return '$count palavras · $wpm ppm';
  }

  @override
  String groupLabel(int count) {
    return 'Grupo: $count palavras';
  }

  @override
  String get pacerDone => 'Guia concluída! 🎉';

  @override
  String get doneReading => 'Terminei de ler';

  @override
  String get validate => 'Validar';

  @override
  String get finish => 'Terminar';

  @override
  String get wpmCaption => 'palavras / minuto';

  @override
  String get comprehension => 'Compreensão';

  @override
  String get effectiveSpeed => 'Velocidade efetiva';

  @override
  String get skimHint =>
      'Passa os olhos pelas ideias principais e depois responde às perguntas.';

  @override
  String get skimDone => 'Já passei os olhos';

  @override
  String scanTargetLabel(String target) {
    return 'Localiza no texto: «$target»';
  }

  @override
  String get yourAnswer => 'A tua resposta';

  @override
  String scanFound(int seconds) {
    return 'Encontrado em ${seconds}s!';
  }

  @override
  String get scanKeepLooking => 'Ainda não… continua a procurar 🔎';

  @override
  String schulteLooking(int count) {
    return 'Procura: $count';
  }

  @override
  String schulteDone(int seconds, int errors) {
    String _temp0 = intl.Intl.pluralLogic(
      errors,
      locale: localeName,
      other: '$errors erros',
      one: '1 erro',
    );
    return 'Concluído em ${seconds}s · $_temp0';
  }

  @override
  String get replay => 'Repetir';

  @override
  String get start => 'Começar';

  @override
  String get inProgress => 'Em curso…';
}
