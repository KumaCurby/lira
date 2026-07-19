import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/data/mappers/reading_settings_mapper.dart';
import 'package:lecture_rapide/domain/settings/reading_settings.dart';

void main() {
  group('reading_settings_mapper', () {
    test('le round-trip conserve les réglages', () {
      const settings = ReadingSettings(
        defaultWpm: 450,
        chunkSize: 4,
        slowLongWords: false,
        pauseOnPunctuation: true,
        darkMode: true,
        targetWpm: 520,
        hasOnboarded: true,
        reminderEnabled: true,
        reminderHour: 8,
        reminderMinute: 30,
        localeCode: 'en',
      );

      final back = settingsFromJson(settingsToJson(settings));

      expect(back.defaultWpm, 450);
      expect(back.chunkSize, 4);
      expect(back.slowLongWords, isFalse);
      expect(back.pauseOnPunctuation, isTrue);
      expect(back.darkMode, isTrue);
      expect(back.targetWpm, 520);
      expect(back.hasOnboarded, isTrue);
      expect(back.reminderEnabled, isTrue);
      expect(back.reminderHour, 8);
      expect(back.reminderMinute, 30);
      expect(back.localeCode, 'en');
    });

    test('applique les valeurs par défaut sur un JSON partiel', () {
      final back = settingsFromJson({'defaultWpm': 500});

      expect(back.defaultWpm, 500);
      expect(back.chunkSize, 3); // défaut
      expect(back.darkMode, isFalse); // défaut
    });
  });
}
