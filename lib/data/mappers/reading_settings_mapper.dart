import '../../domain/settings/reading_settings.dart';

Map<String, dynamic> settingsToJson(ReadingSettings settings) => {
  'defaultWpm': settings.defaultWpm,
  'chunkSize': settings.chunkSize,
  'slowLongWords': settings.slowLongWords,
  'pauseOnPunctuation': settings.pauseOnPunctuation,
  'darkMode': settings.darkMode,
  'targetWpm': settings.targetWpm,
  'hasOnboarded': settings.hasOnboarded,
  'reminderEnabled': settings.reminderEnabled,
  'reminderHour': settings.reminderHour,
  'reminderMinute': settings.reminderMinute,
  if (settings.localeCode != null) 'localeCode': settings.localeCode,
  'scrambleEmphasis': settings.scrambleEmphasis.name,
  'scrambleIntensity': settings.scrambleIntensity.name,
  'scrambleStable': settings.scrambleStable,
  'scrambleComfort': settings.scrambleComfort,
  'scrambleIntroSeen': settings.scrambleIntroSeen,
  'adaptiveSpeed': settings.adaptiveSpeed,
};

ReadingSettings settingsFromJson(Map<String, dynamic> json) => ReadingSettings(
  defaultWpm: json['defaultWpm'] as int? ?? 250,
  chunkSize: json['chunkSize'] as int? ?? 3,
  slowLongWords: json['slowLongWords'] as bool? ?? true,
  pauseOnPunctuation: json['pauseOnPunctuation'] as bool? ?? true,
  darkMode: json['darkMode'] as bool? ?? false,
  targetWpm: json['targetWpm'] as int? ?? 400,
  hasOnboarded: json['hasOnboarded'] as bool? ?? false,
  reminderEnabled: json['reminderEnabled'] as bool? ?? false,
  reminderHour: json['reminderHour'] as int? ?? 20,
  reminderMinute: json['reminderMinute'] as int? ?? 0,
  localeCode: json['localeCode'] as String?,
  scrambleEmphasis: ScrambleEmphasis.values.firstWhere(
    (e) => e.name == json['scrambleEmphasis'],
    orElse: () => ScrambleEmphasis.colorEnds,
  ),
  scrambleIntensity: ScrambleIntensity.values.firstWhere(
    (e) => e.name == json['scrambleIntensity'],
    orElse: () => ScrambleIntensity.medium,
  ),
  scrambleStable: json['scrambleStable'] as bool? ?? false,
  scrambleComfort: json['scrambleComfort'] as bool? ?? false,
  scrambleIntroSeen: json['scrambleIntroSeen'] as bool? ?? false,
  adaptiveSpeed: json['adaptiveSpeed'] as bool? ?? false,
);
