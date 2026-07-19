import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

import 'html_to_text.dart';

/// Résultat d'extraction : titre (si présent dans les métadonnées) + texte brut.
class ExtractedDocument {
  const ExtractedDocument({this.title, required this.text});

  final String? title;
  final String text;
}

/// Extrait le texte d'un EPUB (ZIP de fichiers XHTML) en pur Dart.
///
/// Suit la structure standard : `META-INF/container.xml` → OPF (métadonnées +
/// manifeste + spine) → chapitres XHTML lus dans l'ordre du spine.
ExtractedDocument extractEpubText(Uint8List bytes) {
  final archive = ZipDecoder().decodeBytes(bytes);

  String? readFile(String name) {
    for (final file in archive) {
      if (file.isFile && file.name == name) {
        return utf8.decode(file.content, allowMalformed: true);
      }
    }
    return null;
  }

  final containerXml = readFile('META-INF/container.xml');
  if (containerXml == null) {
    throw const FormatException('EPUB invalide : container.xml manquant');
  }
  final opfPath = _rootfilePath(containerXml);
  final opfXml = readFile(opfPath);
  if (opfXml == null) {
    throw FormatException('EPUB invalide : OPF introuvable ($opfPath)');
  }

  final opf = XmlDocument.parse(opfXml);
  final title = _localElements(opf, 'title')
      .map((e) => e.innerText.trim())
      .where((t) => t.isNotEmpty)
      .cast<String?>()
      .firstWhere((_) => true, orElse: () => null);

  final manifest = <String, String>{};
  for (final item in _localElements(opf, 'item')) {
    final id = item.getAttribute('id');
    final href = item.getAttribute('href');
    if (id != null && href != null) manifest[id] = href;
  }
  final spine = _localElements(
    opf,
    'itemref',
  ).map((e) => e.getAttribute('idref')).whereType<String>().toList();

  final opfDir = _dirname(opfPath);
  final buffer = StringBuffer();
  for (final idref in spine) {
    final href = manifest[idref];
    if (href == null) continue;
    final content = readFile(_joinPath(opfDir, href));
    if (content == null) continue;
    final text = htmlToText(content);
    if (text.isNotEmpty) buffer.writeln('$text\n');
  }

  return ExtractedDocument(title: title, text: buffer.toString().trim());
}

Iterable<XmlElement> _localElements(XmlDocument doc, String localName) => doc
    .descendants
    .whereType<XmlElement>()
    .where((e) => e.name.local == localName);

String _rootfilePath(String containerXml) {
  final rootfile = _localElements(
    XmlDocument.parse(containerXml),
    'rootfile',
  ).cast<XmlElement?>().firstWhere((_) => true, orElse: () => null);
  final path = rootfile?.getAttribute('full-path');
  if (path == null) {
    throw const FormatException('EPUB invalide : full-path manquant');
  }
  return path;
}

String _dirname(String path) {
  final i = path.lastIndexOf('/');
  return i < 0 ? '' : path.substring(0, i);
}

String _joinPath(String dir, String href) {
  final cleaned = href.startsWith('./') ? href.substring(2) : href;
  return dir.isEmpty ? cleaned : '$dir/$cleaned';
}
