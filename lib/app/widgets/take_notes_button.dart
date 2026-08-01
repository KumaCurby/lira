import 'package:flutter/material.dart';

import '../../domain/text/reading_text.dart';
import '../../l10n/app_localizations.dart';
import '../screens/note_editor_screen.dart';

/// Bouton « Prendre des notes » à placer sur les écrans de résultat pour
/// ouvrir [NoteEditorScreen] avec le texte courant.
class TakeNotesButton extends StatelessWidget {
  const TakeNotesButton({super.key, required this.text});

  final ReadingText text;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return OutlinedButton.icon(
      onPressed: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => NoteEditorScreen(text: text))),
      icon: const Icon(Icons.edit_note),
      label: Text(l10n.takeNotes),
    );
  }
}
