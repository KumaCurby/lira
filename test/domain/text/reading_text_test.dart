import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/text/reading_text.dart';

void main() {
  group('ReadingText', () {
    test('wordCount compte les mots du corps', () {
      const text = ReadingText(
        id: 't1',
        title: 'Essai',
        body: 'Le chat dort paisiblement.',
        source: TextSource.builtin,
      );

      expect(text.wordCount, 4);
    });
  });
}
