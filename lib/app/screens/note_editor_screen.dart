import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/notes/text_note.dart';
import '../../domain/text/reading_text.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';

/// LR16 — Éditeur unifié : résumé libre (méthode « 3 phrases » item 9) ou
/// notes Cornell (item 12). Chaque texte peut avoir plusieurs notes.
class NoteEditorScreen extends ConsumerStatefulWidget {
  const NoteEditorScreen({super.key, required this.text, this.existing});

  final ReadingText text;
  final TextNote? existing;

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  late final TextEditingController _summary;
  late final TextEditingController _cues;
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _summary = TextEditingController(text: widget.existing?.summary ?? '');
    _cues = TextEditingController(text: widget.existing?.cues ?? '');
    _notes = TextEditingController(text: widget.existing?.notes ?? '');
  }

  @override
  void dispose() {
    _tab.dispose();
    _summary.dispose();
    _cues.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final now = ref.read(clockProvider).now();
    final note = TextNote(
      id: widget.existing?.id ?? now.microsecondsSinceEpoch.toString(),
      textId: widget.text.id,
      createdAt: widget.existing?.createdAt ?? now,
      summary: _summary.text.trim().isEmpty ? null : _summary.text.trim(),
      cues: _cues.text.trim().isEmpty ? null : _cues.text.trim(),
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    );
    if (note.isEmpty && widget.existing != null) {
      await ref.read(notesRepositoryProvider).remove(note.id);
    } else if (!note.isEmpty) {
      await ref.read(notesRepositoryProvider).upsert(note);
    }
    ref.invalidate(notesProvider);
    ref.invalidate(notesForTextProvider(widget.text.id));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.noteEditorTitle),
        actions: [TextButton(onPressed: _save, child: Text(l10n.save))],
        bottom: TabBar(
          controller: _tab,
          tabs: [
            Tab(text: l10n.noteTabSummary),
            Tab(text: l10n.noteTabCornell),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [_summaryTab(l10n), _cornellTab(l10n)],
      ),
    );
  }

  Widget _summaryTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.noteSummaryHint,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _summary,
            maxLines: 8,
            minLines: 4,
            decoration: InputDecoration(
              hintText: l10n.noteSummaryPlaceholder,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cornellTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.noteCornellHint,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _cues,
                    maxLines: 12,
                    minLines: 8,
                    decoration: InputDecoration(
                      labelText: l10n.noteCornellCues,
                      hintText: l10n.noteCornellCuesHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _notes,
                    maxLines: 12,
                    minLines: 8,
                    decoration: InputDecoration(
                      labelText: l10n.noteCornellNotes,
                      hintText: l10n.noteCornellNotesHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _summary,
            maxLines: 3,
            minLines: 2,
            decoration: InputDecoration(
              labelText: l10n.noteCornellSummary,
              hintText: l10n.noteSummaryPlaceholder,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
