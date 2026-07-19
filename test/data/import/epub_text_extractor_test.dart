import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/data/import/epub_text_extractor.dart';

const _container =
    '<?xml version="1.0" encoding="UTF-8"?>'
    '<container version="1.0" '
    'xmlns="urn:oasis:names:tc:opendocument:xmlns:container">'
    '<rootfiles><rootfile full-path="OEBPS/content.opf" '
    'media-type="application/oebps-package+xml"/></rootfiles></container>';

const _opf =
    '<?xml version="1.0"?>'
    '<package xmlns="http://www.idpf.org/2007/opf" version="3.0" '
    'unique-identifier="id">'
    '<metadata xmlns:dc="http://purl.org/dc/elements/1.1/">'
    '<dc:title>Mon Livre EPUB</dc:title></metadata>'
    '<manifest>'
    '<item id="c1" href="chap1.xhtml" media-type="application/xhtml+xml"/>'
    '<item id="c2" href="chap2.xhtml" media-type="application/xhtml+xml"/>'
    '</manifest>'
    '<spine><itemref idref="c1"/><itemref idref="c2"/></spine></package>';

const _chap1 =
    '<html><body><h1>Chapitre 1</h1><p>Le début de l\'histoire.</p></body></html>';
const _chap2 = '<html><body><p>La suite et la fin.</p></body></html>';

Uint8List _buildEpub() {
  final archive = Archive()
    ..add(ArchiveFile.string('mimetype', 'application/epub+zip'))
    ..add(ArchiveFile.string('META-INF/container.xml', _container))
    ..add(ArchiveFile.string('OEBPS/content.opf', _opf))
    ..add(ArchiveFile.string('OEBPS/chap1.xhtml', _chap1))
    ..add(ArchiveFile.string('OEBPS/chap2.xhtml', _chap2));
  return ZipEncoder().encodeBytes(archive);
}

void main() {
  group('extractEpubText', () {
    test(
      'extrait le titre et le texte des chapitres dans l\'ordre du spine',
      () {
        final doc = extractEpubText(_buildEpub());

        expect(doc.title, 'Mon Livre EPUB');
        expect(doc.text, contains('Le début de l\'histoire.'));
        expect(doc.text, contains('La suite et la fin.'));
        expect(doc.text.indexOf('début'), lessThan(doc.text.indexOf('fin')));
      },
    );

    test('lève une erreur si container.xml est absent', () {
      final archive = Archive()
        ..add(ArchiveFile.string('OEBPS/content.opf', _opf));
      expect(
        () => extractEpubText(ZipEncoder().encodeBytes(archive)),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
