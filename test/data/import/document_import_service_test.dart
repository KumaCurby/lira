import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/data/import/document_import_service.dart';
import 'package:lecture_rapide/data/import/pdf_text_reader.dart';
import 'package:lecture_rapide/domain/text/reading_text.dart';

class _FakePdfReader implements PdfTextReader {
  _FakePdfReader(this.text);
  final String text;
  @override
  Future<String> readText(Uint8List bytes) async => text;
}

const _container =
    '<?xml version="1.0"?>'
    '<container xmlns="urn:oasis:names:tc:opendocument:xmlns:container">'
    '<rootfiles><rootfile full-path="content.opf"/></rootfiles></container>';
const _opf =
    '<?xml version="1.0"?>'
    '<package xmlns="http://www.idpf.org/2007/opf">'
    '<metadata xmlns:dc="http://purl.org/dc/elements/1.1/">'
    '<dc:title>Roman EPUB</dc:title></metadata>'
    '<manifest><item id="c1" href="c1.xhtml"/></manifest>'
    '<spine><itemref idref="c1"/></spine></package>';

Uint8List _epub() {
  final archive = Archive()
    ..add(ArchiveFile.string('META-INF/container.xml', _container))
    ..add(ArchiveFile.string('content.opf', _opf))
    ..add(
      ArchiveFile.string(
        'c1.xhtml',
        '<html><body><p>Un texte court.</p></body></html>',
      ),
    );
  return ZipEncoder().encodeBytes(archive);
}

void main() {
  group('DocumentImportService', () {
    test('importe un EPUB et titre depuis les métadonnées', () async {
      final service = DocumentImportService(pdfReader: _FakePdfReader(''));

      final texts = await service.importFile(
        filename: 'peu-importe.epub',
        bytes: _epub(),
        idPrefix: 'imp1',
      );

      expect(texts, isNotEmpty);
      expect(texts.first.source, TextSource.user);
      expect(texts.first.title, 'Roman EPUB');
    });

    test(
      'importe un PDF via le lecteur injecté et découpe en passages',
      () async {
        final longText = List.filled(1200, 'mot').join(' ');
        final service = DocumentImportService(
          pdfReader: _FakePdfReader(longText),
        );

        final texts = await service.importFile(
          filename: '/chemin/vers/Mon_Document.pdf',
          bytes: Uint8List(0),
          idPrefix: 'imp2',
          targetWords: 500,
        );

        expect(texts.length, greaterThanOrEqualTo(2));
        expect(texts.first.title, startsWith('Mon Document')); // depuis le nom
        expect(texts.first.id, 'imp2-1');
      },
    );

    test('rejette un format non supporté', () async {
      final service = DocumentImportService(pdfReader: _FakePdfReader(''));
      await expectLater(
        service.importFile(
          filename: 'note.txt',
          bytes: Uint8List(0),
          idPrefix: 'x',
        ),
        throwsArgumentError,
      );
    });
  });
}
