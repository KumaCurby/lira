import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/data/corpus/local_text_repository.dart';
import 'package:lecture_rapide/domain/text/reading_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _corpus = [
  ReadingText(
    id: 'c1',
    title: 'Corpus 1',
    body: 'Un.',
    source: TextSource.builtin,
  ),
];

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('all combine corpus et textes utilisateur', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = LocalTextRepository(corpus: _corpus, prefs: prefs);

    expect(await repo.all(), hasLength(1));

    await repo.save(
      const ReadingText(
        id: 'u1',
        title: 'Perso',
        body: 'Deux.',
        source: TextSource.user,
      ),
    );

    final all = await repo.all();
    expect(all, hasLength(2));
    expect(all.map((t) => t.id), containsAll(['c1', 'u1']));
  });

  test('delete ne retire que les textes utilisateur (corpus intact)', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = LocalTextRepository(corpus: _corpus, prefs: prefs);

    await repo.save(
      const ReadingText(
        id: 'u1',
        title: 'Perso',
        body: 'x',
        source: TextSource.user,
      ),
    );
    await repo.delete('u1');
    expect(await repo.all(), hasLength(1)); // le corpus reste

    await repo.delete('c1'); // sans effet sur le corpus
    expect(await repo.all(), hasLength(1));
  });

  test('deleteAll retire plusieurs extraits (corpus intact)', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = LocalTextRepository(corpus: _corpus, prefs: prefs);

    await repo.save(
      const ReadingText(
        id: 'u1',
        title: 'A',
        body: 'x',
        source: TextSource.user,
        bookId: 'b',
      ),
    );
    await repo.save(
      const ReadingText(
        id: 'u2',
        title: 'B',
        body: 'y',
        source: TextSource.user,
        bookId: 'b',
      ),
    );

    await repo.deleteAll(['u1', 'u2']);

    expect(await repo.all(), hasLength(1)); // le corpus reste
  });

  test('persiste les textes utilisateur entre deux instances', () async {
    final prefs = await SharedPreferences.getInstance();
    await LocalTextRepository(corpus: _corpus, prefs: prefs).save(
      const ReadingText(
        id: 'u1',
        title: 'Perso',
        body: 'x',
        source: TextSource.user,
      ),
    );

    final repo2 = LocalTextRepository(
      corpus: _corpus,
      prefs: await SharedPreferences.getInstance(),
    );
    expect((await repo2.byId('u1'))?.title, 'Perso');
  });
}
