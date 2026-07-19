import 'clock.dart';

/// Horloge réelle (production).
class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}
