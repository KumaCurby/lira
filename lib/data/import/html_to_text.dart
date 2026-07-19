/// Convertit un fragment (X)HTML en texte brut, en préservant une structure de
/// paragraphes (frontières de blocs → ligne vide) pour le découpage ultérieur.
String htmlToText(String html) {
  var s = html;

  // Retirer les blocs non lisibles.
  s = s.replaceAll(
    RegExp(r'<script[^>]*>[\s\S]*?</script>', caseSensitive: false),
    ' ',
  );
  s = s.replaceAll(
    RegExp(r'<style[^>]*>[\s\S]*?</style>', caseSensitive: false),
    ' ',
  );

  // Fins de blocs → saut de paragraphe.
  s = s.replaceAll(
    RegExp(
      r'</(p|div|h[1-6]|li|blockquote|section|article)>',
      caseSensitive: false,
    ),
    '\n\n',
  );
  // Sauts de ligne explicites.
  s = s.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
  // Toutes les autres balises.
  s = s.replaceAll(RegExp(r'<[^>]+>'), '');

  s = _decodeEntities(s);

  // Nettoyage des espaces sans écraser les sauts de paragraphe.
  s = s.replaceAll(RegExp(r'[ \t\r\f]+'), ' ');
  s = s.replaceAll(RegExp(r' *\n *'), '\n');
  s = s.replaceAll(RegExp(r'\n{3,}'), '\n\n');
  return s.trim();
}

const Map<String, String> _entities = {
  '&nbsp;': ' ', '&amp;': '&', '&lt;': '<', '&gt;': '>', '&quot;': '"',
  '&apos;': "'", '&#39;': "'", '&rsquo;': '’', '&lsquo;': '‘',
  '&ldquo;': '“', '&rdquo;': '”', '&laquo;': '«', '&raquo;': '»',
  '&hellip;': '…', '&mdash;': '—', '&ndash;': '–',
  // Accents et ligatures fréquents dans les EPUB français.
  '&agrave;': 'à', '&acirc;': 'â', '&auml;': 'ä', '&aacute;': 'á',
  '&ccedil;': 'ç', '&egrave;': 'è', '&eacute;': 'é', '&ecirc;': 'ê',
  '&euml;': 'ë', '&igrave;': 'ì', '&icirc;': 'î', '&iuml;': 'ï',
  '&ograve;': 'ò', '&ocirc;': 'ô', '&ouml;': 'ö', '&ugrave;': 'ù',
  '&ucirc;': 'û', '&uuml;': 'ü', '&ntilde;': 'ñ', '&yuml;': 'ÿ',
  '&oelig;': 'œ', '&aelig;': 'æ', '&euro;': '€', '&copy;': '©', '&deg;': '°',
  '&Agrave;': 'À', '&Acirc;': 'Â', '&Ccedil;': 'Ç', '&Egrave;': 'È',
  '&Eacute;': 'É', '&Ecirc;': 'Ê', '&Ocirc;': 'Ô', '&Ugrave;': 'Ù',
};

String _decodeEntities(String input) {
  var out = input;
  _entities.forEach((entity, char) => out = out.replaceAll(entity, char));
  // Entités numériques décimales (&#233;) et hexadécimales (&#xE9;).
  out = out.replaceAllMapped(RegExp(r'&#(x?[0-9a-fA-F]+);'), (m) {
    final raw = m.group(1)!;
    final code = raw.startsWith('x')
        ? int.tryParse(raw.substring(1), radix: 16)
        : int.tryParse(raw);
    return code == null ? m.group(0)! : String.fromCharCode(code);
  });
  return out;
}
