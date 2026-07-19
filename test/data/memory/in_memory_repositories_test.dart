import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/data/memory/in_memory_session_repository.dart';
import 'package:lecture_rapide/data/memory/in_memory_settings_repository.dart';
import 'package:lecture_rapide/data/memory/in_memory_text_repository.dart';
import 'package:lecture_rapide/domain/measure/reading_session.dart';
import 'package:lecture_rapide/domain/settings/reading_settings.dart';
import 'package:lecture_rapide/domain/text/reading_text.dart';

ReadingSession _session() => ReadingSession(
  type: ExerciseType.rsvp,
  wordCount: 1,
  elapsed: const Duration(seconds: 1),
  wpm: 60,
  date: DateTime(2026, 1, 1),
);

void main() {
  group('InMemoryTextRepository', () {
    test('save / all / byId / delete', () async {
      final repo = InMemoryTextRepository();
      await repo.save(
        const ReadingText(
          id: 'x',
          title: 'X',
          body: 'Corps.',
          source: TextSource.user,
        ),
      );

      expect(await repo.all(), hasLength(1));
      expect((await repo.byId('x'))?.title, 'X');

      await repo.delete('x');
      expect(await repo.all(), isEmpty);
      expect(await repo.byId('x'), isNull);
    });

    test('save remplace un texte de même id', () async {
      final repo = InMemoryTextRepository();
      await repo.save(
        const ReadingText(
          id: 'x',
          title: 'V1',
          body: 'a',
          source: TextSource.user,
        ),
      );
      await repo.save(
        const ReadingText(
          id: 'x',
          title: 'V2',
          body: 'b',
          source: TextSource.user,
        ),
      );

      expect(await repo.all(), hasLength(1));
      expect((await repo.byId('x'))?.title, 'V2');
    });

    test('deleteAll supprime plusieurs textes d\'un coup', () async {
      final repo = InMemoryTextRepository();
      for (final id in ['a', 'b', 'c']) {
        await repo.save(
          ReadingText(id: id, title: id, body: 'x', source: TextSource.user),
        );
      }

      await repo.deleteAll(['a', 'c']);

      expect((await repo.all()).map((t) => t.id), ['b']);
    });
  });

  group('InMemorySessionRepository', () {
    test('add / all / clear', () async {
      final repo = InMemorySessionRepository();
      await repo.add(_session());

      expect(await repo.all(), hasLength(1));
      await repo.clear();
      expect(await repo.all(), isEmpty);
    });
  });

  group('InMemorySettingsRepository', () {
    test('load par défaut puis save/load', () async {
      final repo = InMemorySettingsRepository();
      expect((await repo.load()).defaultWpm, 250);

      await repo.save(const ReadingSettings(defaultWpm: 500));
      expect((await repo.load()).defaultWpm, 500);
    });
  });
}
