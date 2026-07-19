/// Façon de mettre en avant les « repères » (1re/dernière lettre) dans
/// l'exercice de mots mélangés (typoglycémie).
enum ScrambleEmphasis {
  /// 1re/dernière lettre en couleur d'accent (par défaut).
  colorEnds,

  /// 1re/dernière normales, milieu estompé en gris.
  dimMiddle,

  /// 1re/dernière lettre soulignées.
  underline,

  /// Aucun repère : texte brut.
  none,
}

/// Intensité du mélange dans l'exercice de mots mélangés.
enum ScrambleIntensity {
  /// Facile : seuls les mots longs sont mélangés (lecture plus aisée).
  easy,

  /// Moyen : tous les mots d'au moins 4 lettres (par défaut).
  medium,

  /// Difficile : mélange maximal (dérangement — aucune lettre à sa place).
  hard,
}

/// Préférences de lecture de l'utilisateur (persistées en Phase 1, réglées en
/// Phase 3). Objet-valeur immuable ; utiliser [copyWith] pour dériver.
class ReadingSettings {
  const ReadingSettings({
    this.defaultWpm = 250,
    this.chunkSize = 3,
    this.slowLongWords = true,
    this.pauseOnPunctuation = true,
    this.darkMode = false,
    this.targetWpm = 400,
    this.hasOnboarded = false,
    this.reminderEnabled = false,
    this.reminderHour = 20,
    this.reminderMinute = 0,
    this.localeCode = 'fr',
    this.scrambleEmphasis = ScrambleEmphasis.colorEnds,
    this.scrambleIntensity = ScrambleIntensity.medium,
    this.scrambleStable = false,
    this.scrambleComfort = false,
    this.scrambleIntroSeen = false,
  });

  /// Vitesse de lecture de départ (mots/min) — par défaut ≈ la **moyenne
  /// mondiale** de lecture adulte silencieuse (~250 mots/min, plage 200–250).
  final int defaultWpm;
  final int chunkSize;
  final bool slowLongWords;
  final bool pauseOnPunctuation;
  final bool darkMode;

  /// Objectif de vitesse de lecture (mpm) fixé par l'utilisateur.
  final int targetWpm;

  /// Vrai une fois l'onboarding initial effectué.
  final bool hasOnboarded;

  /// Rappel quotidien activé, et heure/minute de déclenchement.
  final bool reminderEnabled;
  final int reminderHour;
  final int reminderMinute;

  /// Langue de l'interface : `fr` par défaut, aussi `en`/`es`/`it`/`de`/`pt`.
  final String? localeCode;

  /// Style des repères dans l'exercice de mots mélangés (typoglycémie).
  final ScrambleEmphasis scrambleEmphasis;

  /// Intensité du mélange (facile/moyen/difficile).
  final ScrambleIntensity scrambleIntensity;

  /// Rejouer le **même** mélange en revenant sur un texte (graine = id du texte).
  final bool scrambleStable;

  /// Confort de lecture : interligne et espacement des lettres agrandis.
  final bool scrambleComfort;

  /// Vrai une fois l'explication de la typoglycémie affichée (une seule fois).
  final bool scrambleIntroSeen;

  ReadingSettings copyWith({
    int? defaultWpm,
    int? chunkSize,
    bool? slowLongWords,
    bool? pauseOnPunctuation,
    bool? darkMode,
    int? targetWpm,
    bool? hasOnboarded,
    bool? reminderEnabled,
    int? reminderHour,
    int? reminderMinute,
    String? localeCode,
    bool clearLocale = false,
    ScrambleEmphasis? scrambleEmphasis,
    ScrambleIntensity? scrambleIntensity,
    bool? scrambleStable,
    bool? scrambleComfort,
    bool? scrambleIntroSeen,
  }) {
    return ReadingSettings(
      defaultWpm: defaultWpm ?? this.defaultWpm,
      chunkSize: chunkSize ?? this.chunkSize,
      slowLongWords: slowLongWords ?? this.slowLongWords,
      pauseOnPunctuation: pauseOnPunctuation ?? this.pauseOnPunctuation,
      darkMode: darkMode ?? this.darkMode,
      targetWpm: targetWpm ?? this.targetWpm,
      hasOnboarded: hasOnboarded ?? this.hasOnboarded,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      localeCode: clearLocale ? null : (localeCode ?? this.localeCode),
      scrambleEmphasis: scrambleEmphasis ?? this.scrambleEmphasis,
      scrambleIntensity: scrambleIntensity ?? this.scrambleIntensity,
      scrambleStable: scrambleStable ?? this.scrambleStable,
      scrambleComfort: scrambleComfort ?? this.scrambleComfort,
      scrambleIntroSeen: scrambleIntroSeen ?? this.scrambleIntroSeen,
    );
  }
}
