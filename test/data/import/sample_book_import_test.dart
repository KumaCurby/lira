import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/data/import/document_import_service.dart';
import 'package:lecture_rapide/data/import/pdf_text_reader.dart';
import 'package:lecture_rapide/domain/text/reading_text.dart';
import 'package:lecture_rapide/samples/sample_book_content.dart';

class _UnusedPdfReader implements PdfTextReader {
  @override
  Future<String> readText(Uint8List bytes) =>
      throw StateError('non utilisé pour un EPUB');
}

void main() {
  test('le livre d\'exemple (EPUB) s\'importe en plusieurs passages', () async {
    final service = DocumentImportService(pdfReader: _UnusedPdfReader());

    final texts = await service.importFile(
      filename: 'almanach-des-curiosites.epub',
      bytes: buildSampleEpubBytes(),
      idPrefix: 'sample',
    );

    expect(texts.length, greaterThan(2));
    expect(texts.every((t) => t.source == TextSource.user), isTrue);
    expect(texts.every((t) => t.wordCount > 0), isTrue);
    // Le titre du livre provient des métadonnées EPUB.
    expect(texts.first.title, startsWith(sampleBookTitle));
    // Un contenu bien réel est extrait.
    expect(texts.map((t) => t.body).join(' '), contains('volcan'));
  });
}
