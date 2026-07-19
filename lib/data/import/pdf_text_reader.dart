import 'dart:typed_data';

/// Port d'extraction de texte d'un PDF.
///
/// Abstrait la dépendance concrète (Syncfusion) : le service d'import et ses
/// tests ne dépendent que de cette interface. Asynchrone car l'implémentation
/// réelle décharge le travail lourd dans un isolate d'arrière-plan.
abstract class PdfTextReader {
  Future<String> readText(Uint8List bytes);
}
