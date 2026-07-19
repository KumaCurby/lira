import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/clock/clock.dart';
import '../../domain/measure/reading_session.dart';
import '../../domain/progress/reading_progress.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/rsvp/build_rsvp_frames.dart';
import '../../domain/rsvp/rsvp_frame.dart';
import '../../domain/text/reading_text.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';
import '../widgets/rsvp_word_view.dart';

List<String> _displayTokens(String text) =>
    text.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

/// Lecteur RSVP : mots flashés un à un, vitesse réglable en direct.
class RsvpScreen extends ConsumerStatefulWidget {
  const RsvpScreen({super.key, required this.text});

  final ReadingText text;

  @override
  ConsumerState<RsvpScreen> createState() => _RsvpScreenState();
}

class _RsvpScreenState extends ConsumerState<RsvpScreen> {
  late final List<String> _words = _displayTokens(widget.text.body);
  late int _wpm;
  late bool _slowLongWords;
  late bool _pauseOnPunctuation;

  List<RsvpFrame> _frames = const [];
  int _index = 0;
  bool _playing = false;
  bool _finished = false;
  Timer? _timer;
  final Stopwatch _stopwatch = Stopwatch();

  // Références lues en initState pour rester utilisables dans dispose().
  late final ProgressRepository _progressRepo;
  late final Clock _clock;

  @override
  void initState() {
    super.initState();
    _progressRepo = ref.read(progressRepositoryProvider);
    _clock = ref.read(clockProvider);
    final settings = ref.read(settingsProvider);
    _wpm = settings.defaultWpm;
    _slowLongWords = settings.slowLongWords;
    _pauseOnPunctuation = settings.pauseOnPunctuation;
    _rebuildFrames();
    _restoreProgress();
  }

  void _rebuildFrames() {
    _frames = buildRsvpFrames(
      _words,
      wpm: _wpm,
      slowLongWords: _slowLongWords,
      pauseOnPunctuation: _pauseOnPunctuation,
    );
  }

  /// Reprend à la dernière position sauvegardée pour ce texte (si en cours).
  Future<void> _restoreProgress() async {
    final progresses = await _progressRepo.all();
    final prog = progresses[widget.text.id];
    if (!mounted) return;
    if (prog != null && prog.wordIndex > 0 && prog.wordIndex < _frames.length) {
      setState(() => _index = prog.wordIndex);
    }
  }

  void _saveProgress() {
    if (_words.isEmpty) return;
    _progressRepo.save(
      ReadingProgress(
        textId: widget.text.id,
        wordIndex: _index,
        wordCount: _words.length,
        updatedAt: _clock.now(),
      ),
    );
  }

  void _play() {
    if (_words.isEmpty) return;
    if (_finished || _index >= _frames.length) {
      _index = 0;
      _finished = false;
      _stopwatch.reset();
    }
    setState(() => _playing = true);
    _stopwatch.start();
    _tick();
  }

  void _tick() {
    if (_index >= _frames.length) {
      _finish();
      return;
    }
    _timer = Timer(_frames[_index].duration, () {
      if (!mounted) return;
      setState(() => _index++);
      _tick();
    });
  }

  void _pause() {
    _timer?.cancel();
    _stopwatch.stop();
    setState(() => _playing = false);
    _saveProgress();
  }

  void _restart() {
    _timer?.cancel();
    _stopwatch
      ..stop()
      ..reset();
    setState(() {
      _index = 0;
      _playing = false;
      _finished = false;
    });
  }

  Future<void> _finish() async {
    _timer?.cancel();
    _stopwatch.stop();
    setState(() {
      _playing = false;
      _finished = true;
      _index = _frames.length;
    });
    _saveProgress();

    final elapsed = _stopwatch.elapsed;
    if (elapsed > Duration.zero) {
      await recordSession(
        ref,
        ReadingSession(
          type: ExerciseType.rsvp,
          wordCount: _words.length,
          elapsed: elapsed,
          wpm: _wpm,
          textId: widget.text.id,
          date: _clock.now(),
        ),
      );
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.rsvpDone)),
      );
    }
  }

  void _onWpmChanged(double value) {
    setState(() {
      _wpm = value.round();
      _rebuildFrames();
    });
    if (_playing) {
      _timer?.cancel();
      _tick();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _saveProgress();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final progress = _frames.isEmpty
        ? 0.0
        : (_index / _frames.length).clamp(0.0, 1.0);
    final showWord = _index < _frames.length && (_playing || _index > 0);

    return Scaffold(
      appBar: AppBar(title: Text(widget.text.title)),
      body: Column(
        children: [
          LinearProgressIndicator(value: progress, minHeight: 6),
          Expanded(
            child: Center(
              child: _finished
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 64,
                          color: scheme.primary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.rsvpSummary(_words.length, _wpm),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    )
                  : showWord
                  ? RsvpWordView(
                      word: _frames[_index].word,
                      orpIndex: _frames[_index].orpIndex,
                    )
                  : Text(
                      l10n.rsvpTapPlay,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
            ),
          ),
          _Controls(
            playing: _playing,
            wpm: _wpm,
            onPlayPause: _playing ? _pause : _play,
            onRestart: _restart,
            onWpmChanged: _onWpmChanged,
          ),
        ],
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.playing,
    required this.wpm,
    required this.onPlayPause,
    required this.onRestart,
    required this.onWpmChanged,
  });

  final bool playing;
  final int wpm;
  final VoidCallback onPlayPause;
  final VoidCallback onRestart;
  final ValueChanged<double> onWpmChanged;

  @override
  Widget build(BuildContext context) {
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
                  onPressed: onRestart,
                  icon: const Icon(Icons.replay),
                ),
                const SizedBox(width: 20),
                FloatingActionButton.large(
                  onPressed: onPlayPause,
                  child: Icon(playing ? Icons.pause : Icons.play_arrow),
                ),
                const SizedBox(width: 20),
                const SizedBox(width: 48), // symétrie visuelle
              ],
            ),
            const SizedBox(height: 8),
            Text(l10n.speedLabel(wpm)),
            Slider(
              value: wpm.toDouble(),
              min: 100,
              max: 800,
              divisions: 28,
              label: '$wpm',
              onChanged: onWpmChanged,
            ),
          ],
        ),
      ),
    );
  }
}
