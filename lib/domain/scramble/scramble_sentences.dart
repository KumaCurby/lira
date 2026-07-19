import '../../core/random/random_source.dart';
import '../text/tokenizer.dart';

/// LR11 — « Phrases mélangées » : on brasse l'**ordre des mots** d'une phrase
/// en gardant le premier et le dernier mot à leur place. Le lecteur doit
/// reconstruire le sens → entraînement à l'anticipation syntaxique.
///
/// Un segment = une suite sans ponctuation de fin, suivie de sa ponctuation
/// finale éventuelle (`.`, `!`, `?`, `…`). La ponctuation finale et les sauts de
/// paragraphe sont conservés ; la ponctuation **interne** (virgules…) est
/// simplifiée (les mots sont rejoints par une simple espace).
final RegExp _segment = RegExp(r'[^.!?…]+[.!?…]*', unicode: true);
final RegExp _trailingPunct = RegExp(r'[.!?…]*$');
final RegExp _leadingSpace = RegExp(r'^\s*');

/// Mélange l'ordre des mots de chaque phrase de [text] (1er/dernier mot fixes).
/// Les phrases de moins de 4 mots sont laissées telles quelles.
String scrambleWordOrder(String text, RandomSource random) {
  return text.replaceAllMapped(_segment, (m) {
    final chunk = m[0]!;
    final trailing = _trailingPunct.firstMatch(chunk)!.group(0)!;
    final core = chunk.substring(0, chunk.length - trailing.length);
    final leading = _leadingSpace.firstMatch(core)!.group(0)!;

    final words = tokenizeWords(core);
    if (words.length < 4) return chunk;

    final middle = words.sublist(1, words.length - 1);
    final original = List<String>.of(middle);
    for (var i = middle.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = middle[i];
      middle[i] = middle[j];
      middle[j] = temp;
    }
    // Garantir un ordre différent quand c'est possible.
    if (_sameOrder(middle, original) && original.toSet().length > 1) {
      for (var i = 0; i < middle.length; i++) {
        for (var j = i + 1; j < middle.length; j++) {
          if (middle[i] != middle[j]) {
            final temp = middle[i];
            middle[i] = middle[j];
            middle[j] = temp;
            break;
          }
        }
        if (!_sameOrder(middle, original)) break;
      }
    }

    return '$leading${[words.first, ...middle, words.last].join(' ')}$trailing';
  });
}

bool _sameOrder(List<String> a, List<String> b) {
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
