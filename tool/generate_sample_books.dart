// Génère les fichiers du livre d'exemple sur le disque, dans `sample_books/`.
//
// Lancer avec :  flutter test tool/generate_sample_books.dart
//
// (Utilise le framework de test uniquement pour disposer d'un point d'entrée
// pratique ; ce n'est pas un test unitaire au sens strict.)

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' show Rect;

import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/data/import/epub_text_extractor.dart';
import 'package:lecture_rapide/data/import/pdf_text_reader_syncfusion.dart';
import 'package:lecture_rapide/samples/sample_book_content.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  test('génère l\'EPUB et le PDF du livre d\'exemple', () async {
    final dir = Directory('sample_books')..createSync(recursive: true);

    // --- EPUB (pur Dart) ---
    final epubPath = '${dir.path}/almanach-des-curiosites.epub';
    File(epubPath).writeAsBytesSync(buildSampleEpubBytes());

    // --- PDF (Syncfusion) ---
    final document = PdfDocument();
    final page = document.pages.add();
    final font = PdfStandardFont(PdfFontFamily.helvetica, 12);
    PdfTextElement(text: sampleBookPlainText(), font: font).draw(
      page: page,
      bounds: Rect.fromLTWH(
        0,
        0,
        page.getClientSize().width,
        page.getClientSize().height,
      ),
      format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate),
    );
    final pdfPath = '${dir.path}/almanach-des-curiosites.pdf';
    final pdfBytes = Uint8List.fromList(await document.save());
    File(pdfPath).writeAsBytesSync(pdfBytes);
    document.dispose();

    expect(File(epubPath).existsSync(), isTrue);
    expect(File(pdfPath).existsSync(), isTrue);

    // Round-trip : les fichiers produits se relisent bien (texte extractible).
    expect(extractEpubText(buildSampleEpubBytes()).text, contains('volcan'));
    expect(
      await const SyncfusionPdfTextReader().readText(pdfBytes),
      contains('volcan'),
    );

    // ignore: avoid_print
    print('Livres générés et vérifiés : $epubPath et $pdfPath');
  });
}
