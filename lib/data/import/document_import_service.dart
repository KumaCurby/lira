import 'dart:typed_data';

import '../../domain/text/reading_text.dart';
import '../../domain/usecases/import_document.dart';
import 'epub_text_extractor.dart';
import 'pdf_text_reader.dart';

/// Oriente un fichier importé (EPUB ou PDF, détecté via son extension) vers le
/// bon extracteur, puis le découpe en passages de bibliothèque.
class DocumentImportService {
  DocumentImportService({required PdfTextReader pdfReader})
    : _pdfReader = pdfReader;

  final PdfTextReader _pdfReader;

  Future<List<ReadingText>> importFile({
    required String filename,
    required Uint8List bytes,
    required String idPrefix,
    int targetWords = 500,
  }) async {
    final ext = filename.contains('.')
        ? filename.split('.').last.toLowerCase()
        : '';

    final String text;
    String? metaTitle;
    switch (ext) {
      case 'epub':
        final doc = extractEpubText(bytes);
        text = doc.text;
        metaTitle = doc.title;
      case 'pdf':
        text = await _pdfReader.readText(bytes);
      default:
        throw ArgumentError(
          'format non supporté : « .$ext » (attendu .epub ou .pdf)',
        );
    }

    final title = (metaTitle != null && metaTitle.trim().isNotEmpty)
        ? metaTitle.trim()
        : _titleFromFilename(filename);

    return importDocument(
      idPrefix: idPrefix,
      title: title,
      rawText: text,
      targetWords: targetWords,
    );
  }

  String _titleFromFilename(String filename) {
    var base = filename;
    final slash = base.lastIndexOf(RegExp(r'[/\\]'));
    if (slash >= 0) base = base.substring(slash + 1);
    final dot = base.lastIndexOf('.');
    if (dot > 0) base = base.substring(0, dot);
    base = base.replaceAll(RegExp(r'[_-]+'), ' ').trim();
    return base.isEmpty ? 'Document importé' : base;
  }
}
