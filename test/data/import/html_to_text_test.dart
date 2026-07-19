import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/data/import/html_to_text.dart';

void main() {
  group('htmlToText', () {
    test('convertit les balises en texte et sépare les paragraphes', () {
      const html =
          '<html><body><h1>Titre</h1>'
          '<p>Bonjour le monde.</p>'
          '<p>Deuxi&egrave;me &amp; dernier.</p></body></html>';

      final text = htmlToText(html);

      expect(text, contains('Titre'));
      expect(text, contains('Bonjour le monde.'));
      expect(text, contains('Deuxième & dernier.'));
      expect(text.split(RegExp(r'\n\s*\n')).length, greaterThanOrEqualTo(2));
    });

    test('retire les blocs script et style', () {
      const html = '<p>Visible</p><script>var x=1;</script><style>.a{}</style>';
      final text = htmlToText(html);

      expect(text, contains('Visible'));
      expect(text, isNot(contains('var x')));
      expect(text, isNot(contains('.a{')));
    });

    test('décode les entités numériques', () {
      expect(htmlToText('caf&#233; et cr&#xE8;me'), 'café et crème');
    });
  });
}
