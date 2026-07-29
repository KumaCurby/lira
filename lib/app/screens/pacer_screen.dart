import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/measure/reading_session.dart';
import '../../domain/pacer/pacer_schedule.dart';
import '../../domain/text/reading_text.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';

List<String> _displayTokens(String text) =>
    text.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

/// Guidage : le texte défile par groupes de mots surlignés au rythme choisi.
class PacerScreen extends ConsumerStatefulWidget {
  const PacerScreen({super.key, required this.text});

  final ReadingText text;

  @override
  ConsumerState<PacerScreen> createState() => _PacerScreenState();
}

class _PacerScreenState extends ConsumerState<PacerScreen> {
  late final List<String> _words = _displayTokens(widget.text.body);
  late int _wpm;
  late int _chunkSize;
  bool _progressive = false;

  List<PacerStep> _schedule = const [];
  List<int> _offsets = const [];
  int _step = 0;
  bool _playing = false;
  Timer? _timer;
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    _wpm = settings.defaultWpm;
    _chunkSize = settings.chunkSize;
    _rebuild();
  }

  void _rebuild() {
    _schedule = _progressive
        ? buildProgressivePacerSchedule(_words, wpm: _wpm, maxSpan: _chunkSize)
        : buildPacerSchedule(_words, wpm: _wpm, chunkSize: _chunkSize);
    final offsets = <int>[];
    var offset = 0;
    for (final s in _schedule) {
      offsets.add(offset);
      offset += s.words.length;
    }
    _offsets = offsets;
  }

  void _play() {
    if (_words.isEmpty) return;
    if (_step >= _schedule.length) {
      _step = 0;
      _stopwatch.reset();
    }
    setState(() => _playing = true);
    _stopwatch.start();
    _tick();
  }

  void _tick() {
    if (_step >= _schedule.length) {
      _finish();
      return;
    }
    _timer = Timer(_schedule[_step].duration, () {
      if (!mounted) return;
      setState(() => _step++);
      _tick();
    });
  }

  void _pause() {
    _timer?.cancel();
    _stopwatch.stop();
    setState(() => _playing = false);
  }

  void _restart() {
    _timer?.cancel();
    _stopwatch
      ..stop()
      ..reset();
    setState(() {
      _step = 0;
      _playing = false;
    });
  }

  Future<void> _finish() async {
    _timer?.cancel();
    _stopwatch.stop();
    setState(() {
      _playing = false;
      _step = _schedule.length;
    });
    final elapsed = _stopwatch.elapsed;
    if (elapsed > Duration.zero) {
      await recordSession(
        ref,
        ReadingSession(
          type: ExerciseType.pacer,
          wordCount: _words.length,
          elapsed: elapsed,
          wpm: _wpm,
          textId: widget.text.id,
          date: ref.read(clockProvider).now(),
        ),
      );
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pacerDone)),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final activeStart = _step < _offsets.length ? _offsets[_step] : -1;
    final activeEnd = (_step < _schedule.length)
        ? activeStart + _schedule[_step].words.length
        : -1;

    return Scaffold(
      appBar: AppBar(title: Text(widget.text.title)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 6,
                runSpacing: 10,
                children: [
                  for (var i = 0; i < _words.length; i++)
                    _Word(
                      text: _words[i],
                      active: _playing && i >= activeStart && i < activeEnd,
                      scheme: scheme,
                    ),
                ],
              ),
            ),
          ),
          _controls(context),
        ],
      ),
    );
  }

  Widget _controls(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  onPressed: _restart,
                  icon: const Icon(Icons.replay),
                ),
                const SizedBox(width: 20),
                FloatingActionButton.large(
                  onPressed: _playing ? _pause : _play,
                  child: Icon(_playing ? Icons.pause : Icons.play_arrow),
                ),
                const SizedBox(width: 68),
              ],
            ),
            const SizedBox(height: 8),
            FilterChip(
              selected: _progressive,
              onSelected: (v) {
                setState(() {
                  _progressive = v;
                  _step = 0;
                  _rebuild();
                });
                if (_playing) {
                  _timer?.cancel();
                  _tick();
                }
              },
              avatar: const Icon(Icons.unfold_more, size: 18),
              label: Text(l10n.pacerProgressive),
            ),
            const SizedBox(height: 8),
            Text(l10n.speedLabel(_wpm)),
            Slider(
              value: _wpm.toDouble(),
              min: 100,
              max: 800,
              divisions: 28,
              label: '$_wpm',
              onChanged: (v) {
                setState(() {
                  _wpm = v.round();
                  _rebuild();
                });
                if (_playing) {
                  _timer?.cancel();
                  _tick();
                }
              },
            ),
            Text(l10n.groupLabel(_chunkSize)),
            Slider(
              value: _chunkSize.toDouble(),
              min: 1,
              max: 6,
              divisions: 5,
              label: '$_chunkSize',
              onChanged: (v) {
                setState(() {
                  _chunkSize = v.round();
                  _step = 0;
                  _rebuild();
                });
                if (_playing) {
                  _timer?.cancel();
                  _tick();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Word extends StatelessWidget {
  const _Word({required this.text, required this.active, required this.scheme});

  final String text;
  final bool active;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: active ? scheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: active ? scheme.onPrimary : scheme.onSurface,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
