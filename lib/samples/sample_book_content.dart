// Contenu d'un « livre » d'exemple, ORIGINAL et libre de droit (créé pour
// l'application, versé dans le domaine public / CC0). Chapitres variés mais
// cohérents, assez denses pour tester tous les exercices et l'import.
//
// Utilisé par `tool/generate_sample_books.dart` (génère les fichiers EPUB/PDF)
// et par `test/data/import/sample_book_import_test.dart`.

import 'dart:typed_data';

import 'package:archive/archive.dart';

const String sampleBookTitle = 'L\'Almanach des curiosités';

const List<({String title, String body})> sampleBookChapters = [
  (
    title: 'La naissance des volcans',
    body:
        "Un volcan naît là où la chaleur des profondeurs de la Terre parvient "
        "à percer la surface. Sous nos pieds, le manteau terrestre est composé "
        "de roches si chaudes qu'elles se déforment lentement. Par endroits, "
        "cette roche fond et forme un liquide épais, le magma, moins dense que "
        "ce qui l'entoure. Il s'élève alors peu à peu, s'accumule dans des "
        "réservoirs, puis cherche une issue vers le ciel."
        "\n\n"
        "Quand la pression devient trop forte, l'éruption commence. Le magma "
        "qui atteint l'air libre prend le nom de lave. Certaines coulées sont "
        "fluides et s'étalent en longues rivières incandescentes ; d'autres, "
        "plus visqueuses, emprisonnent les gaz et provoquent des explosions "
        "violentes. Au fil des siècles, les matériaux rejetés s'empilent et "
        "dessinent la silhouette des montagnes de feu. Loin d'être seulement "
        "destructrices, ces éruptions fertilisent les sols et ont, depuis "
        "toujours, façonné les paysages et les îles de notre planète.",
  ),
  (
    title: 'Le grand voyage des oiseaux',
    body:
        "Chaque année, des milliards d'oiseaux entreprennent un voyage "
        "extraordinaire. Lorsque les jours raccourcissent et que la nourriture "
        "se raréfie, ils quittent leurs régions de reproduction pour gagner des "
        "contrées plus clémentes. Certaines espèces parcourent quelques "
        "centaines de kilomètres ; d'autres traversent des continents et des "
        "océans entiers, volant parfois plusieurs jours sans se poser."
        "\n\n"
        "Comment retrouvent-ils leur chemin ? Les chercheurs pensent qu'ils "
        "combinent plusieurs boussoles. Le jour, ils s'orientent grâce à la "
        "position du soleil ; la nuit, grâce aux étoiles. Beaucoup perçoivent "
        "aussi le champ magnétique terrestre, comme s'ils portaient une carte "
        "invisible. La mémoire des fleuves et des côtes complète ce sens de "
        "l'orientation. Le périple reste dangereux : tempêtes, prédateurs et "
        "fatigue déciment les rangs. Pourtant, au printemps suivant, les "
        "survivants reviennent souvent au même nid.",
  ),
  (
    title: 'L\'énigme du sommeil',
    body:
        "Nous passons environ un tiers de notre vie à dormir, et pourtant le "
        "sommeil garde une part de mystère. Il ne s'agit pas d'un simple repos : "
        "le cerveau, loin de s'éteindre, reste étonnamment actif. La nuit se "
        "déroule en cycles, qui alternent le sommeil lent, profond et "
        "réparateur, et le sommeil paradoxal, pendant lequel surgissent la "
        "plupart des rêves."
        "\n\n"
        "Le sommeil sert à consolider la mémoire. Les souvenirs et les "
        "apprentissages de la journée sont triés, renforcés ou effacés pendant "
        "que nous dormons. Le corps, lui aussi, en profite pour réparer ses "
        "tissus et renforcer ses défenses. Priver un être vivant de sommeil "
        "trop longtemps entraîne des troubles graves de l'attention et de "
        "l'humeur. Quant aux rêves, leur fonction reste débattue, et ils "
        "continuent d'intriguer savants et curieux.",
  ),
  (
    title: 'La longue histoire de la roue',
    body:
        "On imagine souvent la roue comme l'une des toutes premières "
        "inventions humaines. En réalité, elle est apparue tardivement, bien "
        "après la maîtrise du feu, de l'agriculture ou de la poterie. Les plus "
        "anciennes roues connues ne servaient d'ailleurs pas au transport, mais "
        "à façonner l'argile : c'étaient des tours de potier."
        "\n\n"
        "L'idée d'un axe traversant un disque pour faire rouler une charge est "
        "venue ensuite. Elle a transformé le déplacement des marchandises, puis, "
        "montée sur des chars, celui des hommes et des armées. Longtemps, les "
        "routes trop mauvaises limitèrent son usage ; il fallut attendre des "
        "voies mieux entretenues pour qu'elle révèle toute sa puissance. De la "
        "brouette au moulin, du rouage d'horloge à la turbine, la roue s'est "
        "glissée partout. Objet si banal qu'on l'oublie, elle demeure l'un des "
        "principes mécaniques les plus féconds jamais imaginés.",
  ),
  (
    title: 'La lumière et les couleurs',
    body:
        "La lumière blanche du soleil paraît sans couleur, et c'est pourtant "
        "un mélange. Lorsqu'elle traverse une goutte de pluie ou un prisme de "
        "verre, elle se sépare en une gamme continue de teintes : c'est le "
        "spectre, celui que dessine l'arc-en-ciel. Chaque couleur correspond à "
        "une longueur d'onde différente, du rouge, le plus long, au violet, le "
        "plus court."
        "\n\n"
        "Les objets qui nous entourent n'ont pas de couleur en propre. Une "
        "feuille paraît verte parce qu'elle absorbe la plupart des longueurs "
        "d'onde et renvoie surtout le vert vers nos yeux. Dans la rétine, des "
        "cellules spécialisées captent ces signaux et le cerveau reconstruit "
        "l'image colorée du monde. D'autres animaux ne voient pas comme nous : "
        "certains distinguent l'ultraviolet, invisible pour l'humain. La couleur "
        "n'est donc pas seulement dans les choses ; elle naît de la rencontre "
        "entre la lumière, la matière et un regard.",
  ),
  (
    title: 'Mesurer le temps',
    body:
        "Mesurer le temps a toujours occupé les hommes. Les premières "
        "horloges furent le ciel lui-même : la course du soleil rythmait le "
        "jour, le retour des saisons ordonnait l'année. On planta des bâtons "
        "pour lire l'ombre, on construisit des cadrans solaires, puis on inventa "
        "la clepsydre, qui laissait couler l'eau à un rythme régulier, et le "
        "sablier, où glissait le sable."
        "\n\n"
        "Le grand tournant vint avec les horloges mécaniques, dont les rouages "
        "découpaient le temps en intervalles égaux, de jour comme de nuit. Le "
        "balancier, puis le ressort, améliorèrent peu à peu leur précision. "
        "Aujourd'hui, les horloges atomiques mesurent la seconde avec une "
        "exactitude vertigineuse, en comptant les vibrations d'un atome. Cette "
        "précision permet aux satellites de nous localiser et aux réseaux du "
        "monde entier de rester synchronisés. Du bâton planté dans le sable à "
        "l'atome, la quête d'un temps toujours plus juste ne s'est jamais "
        "arrêtée.",
  ),
  (
    title: 'Le sel, un trésor ancien',
    body:
        "Aujourd'hui banal, le sel fut longtemps une denrée précieuse. Sans "
        "réfrigérateur, il était le principal moyen de conserver les aliments : "
        "on salait le poisson, la viande et les légumes pour traverser l'hiver. "
        "Cette fonction vitale lui donna une valeur considérable. On l'échangeait, "
        "on le taxait, et il arrivait qu'on paie une partie des salaires en sel — "
        "le mot « salaire » en garde d'ailleurs la trace."
        "\n\n"
        "Le sel voyageait par de longues routes, à dos de chameau à travers les "
        "déserts ou par bateau le long des côtes. Des villes entières prospérèrent "
        "grâce à son commerce, et des conflits éclatèrent pour le contrôle des "
        "salines. On l'extrayait de deux façons : en récoltant celui que la mer "
        "laisse en s'évaporant dans les marais salants, ou en creusant les mines "
        "de sel gemme, vestiges d'océans disparus. De condiment modeste, le sel "
        "devint ainsi un véritable moteur de l'histoire.",
  ),
  (
    title: 'Les marées et la Lune',
    body:
        "Deux fois par jour, la mer monte puis se retire, découvrant les "
        "plages et les rochers. Ce mouvement régulier, la marée, est provoqué "
        "surtout par la Lune. Bien que lointaine, notre satellite attire les eaux "
        "de la Terre par sa gravité ; l'océan se soulève légèrement du côté qui "
        "lui fait face, formant une onde qui suit la Lune dans sa course autour "
        "de la planète."
        "\n\n"
        "Le Soleil, plus massif mais bien plus éloigné, joue lui aussi son rôle. "
        "Quand la Lune et le Soleil s'alignent, leurs forces s'additionnent et "
        "les marées deviennent particulièrement fortes : ce sont les grandes "
        "marées. Quand ils forment un angle droit, les marées s'atténuent. "
        "L'amplitude dépend aussi de la forme des côtes et des fonds : dans "
        "certaines baies, l'eau peut monter de plus de dix mètres, tandis "
        "qu'ailleurs elle bouge à peine.",
  ),
];

const String _containerXml =
    '<?xml version="1.0" encoding="UTF-8"?>'
    '<container version="1.0" '
    'xmlns="urn:oasis:names:tc:opendocument:xmlns:container">'
    '<rootfiles><rootfile full-path="OEBPS/content.opf" '
    'media-type="application/oebps-package+xml"/></rootfiles></container>';

String _escapeXml(String s) =>
    s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');

String _chapterXhtml(({String title, String body}) chapter) {
  final paragraphs = chapter.body
      .split(RegExp(r'\n\s*\n'))
      .map((p) => '<p>${_escapeXml(p.trim())}</p>')
      .join();
  return '<?xml version="1.0" encoding="UTF-8"?>'
      '<html xmlns="http://www.w3.org/1999/xhtml"><head>'
      '<title>${_escapeXml(chapter.title)}</title></head>'
      '<body><h1>${_escapeXml(chapter.title)}</h1>$paragraphs</body></html>';
}

/// Construit les octets d'un EPUB valide à partir du livre d'exemple.
Uint8List buildSampleEpubBytes() {
  final archive = Archive()
    ..add(ArchiveFile.string('mimetype', 'application/epub+zip'))
    ..add(ArchiveFile.string('META-INF/container.xml', _containerXml));

  final manifest = StringBuffer();
  final spine = StringBuffer();
  for (var i = 0; i < sampleBookChapters.length; i++) {
    final href = 'chap$i.xhtml';
    manifest.write(
      '<item id="c$i" href="$href" media-type="application/xhtml+xml"/>',
    );
    spine.write('<itemref idref="c$i"/>');
    archive.add(
      ArchiveFile.string('OEBPS/$href', _chapterXhtml(sampleBookChapters[i])),
    );
  }

  final opf =
      '<?xml version="1.0" encoding="UTF-8"?>'
      '<package xmlns="http://www.idpf.org/2007/opf" version="3.0" '
      'unique-identifier="id">'
      '<metadata xmlns:dc="http://purl.org/dc/elements/1.1/">'
      '<dc:title>${_escapeXml(sampleBookTitle)}</dc:title>'
      '<dc:language>fr</dc:language></metadata>'
      '<manifest>$manifest</manifest><spine>$spine</spine></package>';
  archive.add(ArchiveFile.string('OEBPS/content.opf', opf));

  return ZipEncoder().encodeBytes(archive);
}

/// Le livre entier en texte brut (pour générer un PDF ou déboguer).
String sampleBookPlainText() {
  final buffer = StringBuffer()
    ..writeln(sampleBookTitle)
    ..writeln();
  for (final chapter in sampleBookChapters) {
    buffer
      ..writeln(chapter.title)
      ..writeln()
      ..writeln(chapter.body)
      ..writeln();
  }
  return buffer.toString();
}
