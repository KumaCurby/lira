import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/rsvp/build_rsvp_frames.dart';

void main() {
  group('buildRsvpFrames (LR4)', () {
    test('produit une frame par mot', () {
      final frames = buildRsvpFrames(['le', 'chat', 'dort'], wpm: 300);
      expect(frames.map((f) => f.word).toList(), ['le', 'chat', 'dort']);
    });

    test('durée de base = 60000/wpm (mot court, sans options)', () {
      final frames = buildRsvpFrames(
        ['chat'],
        wpm: 600,
        slowLongWords: false,
        pauseOnPunctuation: false,
      );
      expect(frames.single.duration, const Duration(milliseconds: 100));
    });

    test('un wpm plus élevé raccourcit les durées', () {
      Duration durAt(int wpm) => buildRsvpFrames(
        ['chat'],
        wpm: wpm,
        slowLongWords: false,
        pauseOnPunctuation: false,
      ).single.duration;

      expect(durAt(600), lessThan(durAt(300)));
    });

    test('ralentit les mots longs (slowLongWords)', () {
      Duration durOf(String w) => buildRsvpFrames(
        [w],
        wpm: 600,
        slowLongWords: true,
        pauseOnPunctuation: false,
      ).single.duration;

      expect(durOf('a' * 6), const Duration(milliseconds: 100)); // pas d'extra
      expect(
        durOf('a' * 14),
        const Duration(milliseconds: 140),
      ); // 100×(1+0.05×8)
    });

    test('pause en fin de phrase (×2) et sur virgule (×1.5)', () {
      Duration durOf(String w) => buildRsvpFrames(
        [w],
        wpm: 600,
        slowLongWords: false,
        pauseOnPunctuation: true,
      ).single.duration;

      expect(durOf('fin.'), const Duration(milliseconds: 200));
      expect(durOf('mot,'), const Duration(milliseconds: 150));
    });

    test('sans pauseOnPunctuation, la ponctuation n\'ajoute rien', () {
      final frames = buildRsvpFrames(
        ['fin.'],
        wpm: 600,
        slowLongWords: false,
        pauseOnPunctuation: false,
      );
      expect(frames.single.duration, const Duration(milliseconds: 100));
    });

    test('l\'ORP est calculé sur le mot sans ponctuation', () {
      final frame = buildRsvpFrames(['chat.'], wpm: 600).single;
      expect(frame.orpIndex, 1); // « chat » = 4 lettres -> 1
    });

    test('refuse un wpm <= 0', () {
      expect(() => buildRsvpFrames(['x'], wpm: 0), throwsArgumentError);
    });
  });
}
