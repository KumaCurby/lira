import 'sentence_splitter.dart';
import 'tokenizer.dart';

/// Découpe un texte en passages d'environ [targetWords] mots, en coupant de
/// préférence aux frontières de paragraphes. Un paragraphe très long (au-delà
/// de 1,5× la cible) est redécoupé par blocs de mots. Aucun passage vide.
///
/// Sert à transformer un long document importé en extraits de taille adaptée
/// à l'entraînement.
List<String> splitIntoPassages(String text, {int targetWords = 500}) {
  if (targetWords < 1) {
    throw ArgumentError('targetWords doit être >= 1 (reçu $targetWords)');
  }

  final passages = <String>[];
  final current = <String>[];
  var currentWords = 0;

  void flush() {
    if (current.isNotEmpty) {
      passages.add(current.join('\n\n'));
      current.clear();
      currentWords = 0;
    }
  }

  for (final paragraph in splitParagraphs(text)) {
    final words = tokenizeWords(paragraph).length;

    if (words > targetWords * 1.5) {
      flush();
      passages.addAll(_splitByWords(paragraph, targetWords));
      continue;
    }
    if (current.isNotEmpty && currentWords + words > targetWords) {
      flush();
    }
    current.add(paragraph);
    currentWords += words;
  }
  flush();

  return passages;
}

/// Redécoupe un long paragraphe en blocs de [targetWords] mots (ponctuation
/// conservée car on repart des jetons d'affichage).
List<String> _splitByWords(String paragraph, int targetWords) {
  final words = paragraph
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();
  final chunks = <String>[];
  for (var i = 0; i < words.length; i += targetWords) {
    final end = (i + targetWords < words.length)
        ? i + targetWords
        : words.length;
    chunks.add(words.sublist(i, end).join(' '));
  }
  return chunks;
}
