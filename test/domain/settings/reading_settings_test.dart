import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/settings/reading_settings.dart';

void main() {
  group('ReadingSettings', () {
    test('expose des valeurs par défaut raisonnables', () {
      const settings = ReadingSettings();
      expect(settings.defaultWpm, 250);
      expect(settings.chunkSize, 3);
      expect(settings.pauseOnPunctuation, isTrue);
      expect(settings.targetWpm, 400);
      expect(settings.hasOnboarded, isFalse);
    });

    test('copyWith ne change que les champs fournis', () {
      const settings = ReadingSettings();
      final updated = settings.copyWith(targetWpm: 500, hasOnboarded: true);

      expect(updated.targetWpm, 500);
      expect(updated.hasOnboarded, isTrue);
      expect(updated.defaultWpm, settings.defaultWpm);
      expect(updated.chunkSize, settings.chunkSize);
      expect(updated.darkMode, settings.darkMode);
    });
  });
}
