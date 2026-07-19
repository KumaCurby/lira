import '../../domain/progress/reading_progress.dart';
import '../../domain/repositories/progress_repository.dart';

/// Progression en mémoire (tests, prévisualisation).
class InMemoryProgressRepository implements ProgressRepository {
  final Map<String, ReadingProgress> _byTextId = {};

  @override
  Future<Map<String, ReadingProgress>> all() async =>
      Map.unmodifiable(_byTextId);

  @override
  Future<void> save(ReadingProgress progress) async =>
      _byTextId[progress.textId] = progress;

  @override
  Future<void> clear() async => _byTextId.clear();
}
