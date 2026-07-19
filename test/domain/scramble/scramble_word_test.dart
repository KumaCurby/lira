import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/core/random/seeded_random_source.dart';
import 'package:lecture_rapide/domain/scramble/scramble_word.dart';

void main() {
  group('scrambleWord (LR10)', () {
    test('conserve la première et la dernière lettre', () {
      final out = scrambleWord('lecture', SeededRandomSource(1));
      expect(out[0], 'l');
      expect(out[out.length - 1], 'e');
    });

    test('conserve la longueur et l\'ensemble des lettres (anagramme)', () {
      final out = scrambleWord('cerveau', SeededRandomSource(3));
      expect(out.length, 'cerveau'.length);
      expect(out.split('')..sort(), 'cerveau'.split('')..sort());
    });

    test('laisse intacts les mots de moins de 4 lettres', () {
      final rnd = SeededRandomSource(1);
      expect(scrambleWord('le', rnd), 'le');
      expect(scrambleWord('mot', rnd), 'mot');
      expect(scrambleWord('a', rnd), 'a');
      expect(scrambleWord('', rnd), '');
    });

    test('un mot de 4 lettres ne bouge que ses 2 lettres du milieu', () {
      final out = scrambleWord('dans', SeededRandomSource(5));
      expect(out[0], 'd');
      expect(out[3], 's');
      expect(out.split('')..sort(), 'dans'.split('')..sort());
    });

    test('est reproductible : même graine => même résultat', () {
      final a = scrambleWord('typoglycemie', SeededRandomSource(42));
      final b = scrambleWord('typoglycemie', SeededRandomSource(42));
      expect(a, b);
    });

    test('mélange réellement l\'intérieur d\'un mot assez long', () {
      // Sur un mot long, au moins une graine doit produire un ordre différent.
      final variants = {
        for (var seed = 0; seed < 8; seed++)
          scrambleWord('extraordinaire', SeededRandomSource(seed)),
      };
      expect(variants.any((v) => v != 'extraordinaire'), isTrue);
    });
  });

  group('scrambleText (LR10)', () {
    test('préserve les espaces, la ponctuation et les retours à la ligne', () {
      const source = 'Dans le pré, un chat.\nIl dort ?';
      final out = scrambleText(source, SeededRandomSource(7));

      // Même squelette : tout ce qui n'est pas lettre reste en place.
      String skeleton(String s) =>
          s.replaceAll(RegExp(r'\p{L}', unicode: true), '·');
      expect(skeleton(out), skeleton(source));
      expect(out.length, source.length);
    });

    test('chaque mot garde sa première et sa dernière lettre', () {
      const source = 'Le cerveau parvient à lire correctement.';
      final out = scrambleText(source, SeededRandomSource(11));

      final srcWords = RegExp(
        r'\p{L}+',
        unicode: true,
      ).allMatches(source).map((m) => m[0]!).toList();
      final outWords = RegExp(
        r'\p{L}+',
        unicode: true,
      ).allMatches(out).map((m) => m[0]!).toList();

      expect(outWords, hasLength(srcWords.length));
      for (var i = 0; i < srcWords.length; i++) {
        expect(outWords[i][0], srcWords[i][0]);
        expect(
          outWords[i][outWords[i].length - 1],
          srcWords[i][srcWords[i].length - 1],
        );
        expect(outWords[i].split('')..sort(), srcWords[i].split('')..sort());
      }
    });

    test('ne touche pas aux chiffres', () {
      final out = scrambleText('Page 250 sur 300', SeededRandomSource(1));
      expect(out.contains('250'), isTrue);
      expect(out.contains('300'), isTrue);
    });

    test('est reproductible : même graine => même texte', () {
      const source = 'Un texte un peu plus long pour vérifier la stabilité.';
      final a = scrambleText(source, SeededRandomSource(99));
      final b = scrambleText(source, SeededRandomSource(99));
      expect(a, b);
    });
  });

  group('scrambleWord — vrai mélange garanti (#8)', () {
    test('un mot dont le milieu a 2 lettres distinctes change TOUJOURS', () {
      for (var seed = 0; seed < 30; seed++) {
        expect(
          scrambleWord('chat', SeededRandomSource(seed)),
          isNot('chat'),
          reason: 'graine $seed',
        );
      }
    });

    test('un milieu non mélangeable (lettres identiques) reste intact', () {
      // « sees » : milieu « ee » → aucune autre disposition possible.
      for (var seed = 0; seed < 5; seed++) {
        expect(scrambleWord('sees', SeededRandomSource(seed)), 'sees');
      }
    });
  });

  group("apostrophes et traits d'union comme un seul mot (#9)", () {
    List<String> wordsIn(String s) =>
        scrambleWordPattern.allMatches(s).map((m) => m[0]!).toList();

    test("« aujourd'hui » : extrémités du MOT ENTIER + apostrophe figées", () {
      final out = scrambleWord("aujourd'hui", SeededRandomSource(4));
      expect(out[0], 'a');
      expect(out[out.length - 1], 'i');
      expect(out.indexOf("'"), "aujourd'hui".indexOf("'"));
      expect(out.split('')..sort(), "aujourd'hui".split('')..sort());
    });

    test("« peut-être » : trait d'union figé, extrémités conservées", () {
      final out = scrambleWord('peut-être', SeededRandomSource(2));
      expect(out[0], 'p');
      expect(out[out.length - 1], 'e');
      expect(out.indexOf('-'), 'peut-être'.indexOf('-'));
      expect(out.split('')..sort(), 'peut-être'.split('')..sort());
    });

    test('scrambleText traite le mot composé comme une seule unité', () {
      final out = scrambleText("Je lis aujourd'hui.", SeededRandomSource(1));
      final w = wordsIn(out);
      expect(w, hasLength(3)); // « Je », « lis », « aujourd'hui »
      expect(w.last[0], 'a');
      expect(w.last[w.last.length - 1], 'i');
    });
  });

  group('intensité via minLength / derange (#1)', () {
    test('minLength élevé laisse les mots courts intacts', () {
      // « avec » (4) et « lire » (4) restent intacts à minLength 6.
      expect(scrambleWord('avec', SeededRandomSource(1), minLength: 6), 'avec');
      final out = scrambleText(
        'avec un texte extraordinaire',
        SeededRandomSource(3),
        minLength: 6,
      );
      expect(out.contains('avec'), isTrue); // court → intact
      expect(out.contains('extraordinaire'), isFalse); // long → mélangé
    });

    test('derange : aucune lettre du milieu à sa position d\'origine', () {
      const word = 'abcdef'; // milieu b,c,d,e tout distinct
      for (var seed = 0; seed < 20; seed++) {
        final out = scrambleWord(word, SeededRandomSource(seed), derange: true);
        expect(out[0], 'a');
        expect(out[5], 'f');
        for (var i = 1; i <= 4; i++) {
          expect(out[i], isNot(word[i]), reason: 'pos $i, graine $seed');
        }
      }
    });
  });
}
