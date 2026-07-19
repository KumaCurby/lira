import 'dart:typed_data';

import 'package:flutter/foundation.dart' show compute;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'pdf_text_reader.dart';

/// Extraction de texte PDF via Syncfusion (pur Dart, toutes plateformes).
///
/// L'extraction (lourde) s'exécute dans un **isolate d'arrière-plan** via
/// `compute`, pour ne pas figer l'interface sur les gros fichiers. Sur le web,
/// `compute` s'exécute sur le thread principal (pas d'isolate disponible).
///
/// Ne gère pas les PDF scannés (images) : ceux-ci ne contiennent pas de texte.
class SyncfusionPdfTextReader implements PdfTextReader {
  const SyncfusionPdfTextReader();

  @override
  Future<String> readText(Uint8List bytes) => compute(_extractPdfText, bytes);
}

/// Fonction de haut niveau exécutée dans l'isolate (argument et retour sérialisables).
String _extractPdfText(Uint8List bytes) {
  final document = PdfDocument(inputBytes: bytes);
  try {
    return PdfTextExtractor(document).extractText();
  } finally {
    document.dispose();
  }
}
