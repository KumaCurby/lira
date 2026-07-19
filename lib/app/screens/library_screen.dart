import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/measure/reading_session.dart';
import '../../domain/progress/book_resume.dart';
import '../../domain/progress/reading_progress.dart';
import '../../domain/text/reading_text.dart';
import '../../domain/usecases/import_text.dart';
import '../../l10n/app_localizations.dart';
import '../navigation.dart';
import '../providers.dart';
import '../widgets/exercise_launcher_sheet.dart';

/// Onglet « Textes » : corpus intégré + textes importés (collés ou fichiers).
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  void _showAddMenu(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.content_paste),
              title: Text(l10n.pasteText),
              onTap: () {
                Navigator.pop(sheetContext);
                _addPastedText(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: Text(l10n.importFile),
              subtitle: Text(l10n.importFileSubtitle),
              onTap: () {
                Navigator.pop(sheetContext);
                _importFromFile(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addPastedText(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.pasteDialogTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: l10n.titleOptional),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bodyController,
                minLines: 4,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: l10n.pasteHint,
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.add),
          ),
        ],
      ),
    );

    if (confirmed != true || bodyController.text.trim().isEmpty) return;

    final text = importText(
      id: 'user-${DateTime.now().microsecondsSinceEpoch}',
      raw: bodyController.text,
      title: titleController.text,
    );
    await ref.read(textRepositoryProvider).save(text);
    ref.invalidate(textsProvider);
  }

  Future<void> _importFromFile(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['epub', 'pdf'],
      withData: true,
    );
    if (result == null) return; // annulé
    final picked = result.files.single;
    final bytes = picked.bytes;
    if (bytes == null) {
      if (context.mounted) _snack(context, l10n.cannotReadFile);
      return;
    }

    if (context.mounted) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    }

    try {
      final service = ref.read(documentImportServiceProvider);
      final texts = await service.importFile(
        filename: picked.name,
        bytes: bytes,
        idPrefix: 'user-${DateTime.now().microsecondsSinceEpoch}',
      );
      for (final text in texts) {
        await ref.read(textRepositoryProvider).save(text);
      }
      ref.invalidate(textsProvider);
      if (context.mounted) {
        Navigator.of(context).pop(); // ferme l'indicateur
        _snack(context, l10n.importedCount(texts.length, picked.name));
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        _snack(context, l10n.importFailed('$e'));
      }
    }
  }

  void _snack(BuildContext context, String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  Future<void> _delete(WidgetRef ref, ReadingText text) async {
    await ref.read(textRepositoryProvider).delete(text.id);
    ref.invalidate(textsProvider);
  }

  Future<void> _deleteBook(WidgetRef ref, List<ReadingText> parts) async {
    await ref.read(textRepositoryProvider).deleteAll(parts.map((t) => t.id));
    ref.invalidate(textsProvider);
  }

  /// Reprend la lecture d'un livre dans le lecteur RSVP, sur l'extrait donné.
  Future<void> _resume(
    BuildContext context,
    WidgetRef ref,
    ReadingText passage,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => exerciseScreenFor(ExerciseType.rsvp, passage),
      ),
    );
    ref.invalidate(readingProgressProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final textsAsync = ref.watch(textsProvider);
    final progress =
        ref.watch(readingProgressProvider).valueOrNull ??
        const <String, ReadingProgress>{};

    return Scaffold(
      appBar: AppBar(title: Text(l10n.libraryTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMenu(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.add),
      ),
      body: textsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorGeneric('$e'))),
        data: (texts) => _TextList(
          texts: texts,
          progress: progress,
          onLaunch: (text) => showExerciseLauncher(context, ref, text),
          onDelete: (text) => _delete(ref, text),
          onDeleteBook: (parts) => _deleteBook(ref, parts),
          onResume: (passage) => _resume(context, ref, passage),
        ),
      ),
    );
  }
}

/// Liste de la bibliothèque : textes autonomes + livres regroupés (dépliables).
class _TextList extends StatelessWidget {
  const _TextList({
    required this.texts,
    required this.progress,
    required this.onLaunch,
    required this.onDelete,
    required this.onDeleteBook,
    required this.onResume,
  });

  final List<ReadingText> texts;
  final Map<String, ReadingProgress> progress;
  final void Function(ReadingText text) onLaunch;
  final void Function(ReadingText text) onDelete;
  final void Function(List<ReadingText> parts) onDeleteBook;
  final void Function(ReadingText passage) onResume;

  @override
  Widget build(BuildContext context) {
    final standalone = <ReadingText>[];
    final books = <String, List<ReadingText>>{};
    for (final text in texts) {
      if (text.bookId == null) {
        standalone.add(text);
      } else {
        books.putIfAbsent(text.bookId!, () => <ReadingText>[]).add(text);
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        for (final text in standalone) ...[
          _StandaloneCard(text: text, onLaunch: onLaunch, onDelete: onDelete),
          const SizedBox(height: 8),
        ],
        for (final parts in books.values) ...[
          _BookCard(
            parts: parts,
            progress: progress,
            onLaunch: onLaunch,
            onDelete: onDelete,
            onDeleteBook: onDeleteBook,
            onResume: onResume,
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _StandaloneCard extends StatelessWidget {
  const _StandaloneCard({
    required this.text,
    required this.onLaunch,
    required this.onDelete,
  });

  final ReadingText text;
  final void Function(ReadingText text) onLaunch;
  final void Function(ReadingText text) onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isUser = text.source == TextSource.user;
    return Card(
      child: ListTile(
        onTap: () => onLaunch(text),
        leading: CircleAvatar(child: Text('${text.difficulty ?? '?'}')),
        title: Text(text.title),
        subtitle: Text(
          l10n.textMeta(
            text.wordCount,
            isUser ? l10n.sourceUser : l10n.sourceCorpus,
          ),
        ),
        trailing: isUser
            ? IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => onDelete(text),
              )
            : const Icon(Icons.lock_outline, size: 18),
      ),
    );
  }
}

/// Un livre importé : en-tête (avec progression) + extraits repliés dans un
/// [ExpansionTile], et un bouton pour reprendre là où on s'est arrêté.
class _BookCard extends StatelessWidget {
  const _BookCard({
    required this.parts,
    required this.progress,
    required this.onLaunch,
    required this.onDelete,
    required this.onDeleteBook,
    required this.onResume,
  });

  final List<ReadingText> parts;
  final Map<String, ReadingProgress> progress;
  final void Function(ReadingText text) onLaunch;
  final void Function(ReadingText text) onDelete;
  final void Function(List<ReadingText> parts) onDeleteBook;
  final void Function(ReadingText passage) onResume;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final sorted = [...parts]
      ..sort((a, b) => (a.partIndex ?? 0).compareTo(b.partIndex ?? 0));
    final title = sorted.first.bookTitle ?? l10n.importedBook;
    final totalWords = sorted.fold<int>(0, (sum, t) => sum + t.wordCount);
    final fraction = bookProgressFraction(sorted, progress);
    final resume = bookResume(sorted, progress);

    return Card(
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        leading: CircleAvatar(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          child: const Icon(Icons.menu_book),
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.bookExcerpts(sorted.length, totalWords)),
            if (fraction > 0)
              Padding(
                padding: const EdgeInsets.only(top: 6, right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: fraction, minHeight: 5),
                ),
              ),
          ],
        ),
        childrenPadding: const EdgeInsets.only(bottom: 8),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonalIcon(
                onPressed: () => onResume(resume.passage),
                icon: const Icon(Icons.play_arrow),
                label: Text(
                  resume.hasStarted
                      ? l10n.resumeExcerpt(resume.passage.partIndex ?? 0)
                      : l10n.startReading,
                ),
              ),
            ),
          ),
          for (final part in sorted)
            _PassageTile(
              part: part,
              progress: progress[part.id],
              onTap: () => onLaunch(part),
              onDelete: () => onDelete(part),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => onDeleteBook(sorted),
              icon: const Icon(Icons.delete_sweep),
              label: Text(l10n.deleteBook),
            ),
          ),
        ],
      ),
    );
  }
}

/// Une ligne d'extrait dans un livre, avec son état de lecture.
class _PassageTile extends StatelessWidget {
  const _PassageTile({
    required this.part,
    required this.progress,
    required this.onTap,
    required this.onDelete,
  });

  final ReadingText part;
  final ReadingProgress? progress;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final done = progress?.isComplete ?? false;
    final pct = progress == null ? 0 : (progress!.fraction * 100).round();

    final String subtitle;
    if (done) {
      subtitle = l10n.excerptDone(part.wordCount);
    } else if (pct > 0) {
      subtitle = l10n.excerptReadPct(pct, part.wordCount);
    } else {
      subtitle = l10n.wordsValue(part.wordCount);
    }

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 16, right: 8),
      leading: Icon(
        done ? Icons.check_circle : Icons.play_circle_outline,
        color: done ? scheme.primary : scheme.outline,
      ),
      onTap: onTap,
      title: Text(l10n.excerptN(part.partIndex ?? 0)),
      subtitle: Text(subtitle),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: onDelete,
      ),
    );
  }
}
