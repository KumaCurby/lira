import '../../domain/measure/reading_session.dart';
import '../../domain/repositories/session_repository.dart';

/// Historique de sessions en mémoire (tests, prévisualisation).
class InMemorySessionRepository implements SessionRepository {
  InMemorySessionRepository([List<ReadingSession> seed = const []])
    : _sessions = [...seed];

  final List<ReadingSession> _sessions;

  @override
  Future<List<ReadingSession>> all() async => List.unmodifiable(_sessions);

  @override
  Future<void> add(ReadingSession session) async => _sessions.add(session);

  @override
  Future<void> clear() async => _sessions.clear();
}
