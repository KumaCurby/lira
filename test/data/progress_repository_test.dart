import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/data/mappers/reading_progress_mapper.dart';
import 'package:lecture_rapide/data/memory/in_memory_progress_repository.dart';
import 'package:lecture_rapide/data/prefs/shared_prefs_progress_repository.dart';
import 'package:lecture_rapide/domain/progress/reading_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

ReadingProgress _p(String id, int idx) => ReadingProgress(
  textId: id,
  wordIndex: idx,
  wordCount: 100,
  updatedAt: DateTime(2026, 1, 1),
);

void main() {
  test('mapper : round-trip de la progression', () {
    final p = ReadingProgress(
      textId: 't1',
      wordIndex: 12,
      wordCount: 40,
      updatedAt: DateTime(2026, 7, 10, 14, 30),
    );
    final back = readingProgressFromJson(readingProgressToJson(p));

    expect(back.textId, 't1');
    expect(back.wordIndex, 12);
    expect(back.wordCount, 40);
    expect(back.updatedAt, DateTime(2026, 7, 10, 14, 30));
  });

  test('InMemoryProgressRepository sauvegarde, écrase et efface', () async {
    final repo = InMemoryProgressRepository();

    await repo.save(_p('t', 10));
    await repo.save(_p('t', 30)); // écrase par textId
    expect((await repo.all())['t']?.wordIndex, 30);

    await repo.clear();
    expect(await repo.all(), isEmpty);
  });

  test('SharedPrefsProgressRepository persiste entre instances', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await SharedPrefsProgressRepository(prefs).save(_p('t', 25));

    final reloaded = await SharedPrefsProgressRepository(
      await SharedPreferences.getInstance(),
    ).all();
    expect(reloaded['t']?.wordIndex, 25);
  });
}
