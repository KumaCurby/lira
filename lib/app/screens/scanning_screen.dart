import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/clock/system_clock.dart';
import '../../domain/measure/reading_session.dart';
import '../../domain/measure/wpm_calculator.dart';
import '../../domain/skimming/scan_challenge.dart';
import '../../domain/text/reading_text.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';

/// Balayage : retrouver une information cible dans le texte, le plus vite possible.
class ScanningScreen extends ConsumerStatefulWidget {
  const ScanningScreen({super.key, required this.text});

  final ReadingText text;

  @override
  ConsumerState<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends ConsumerState<ScanningScreen> {
  late final ScanChallenge _challenge = ScanChallenge(
    const SystemClock(),
    text: widget.text.body,
    target: widget.text.scanTarget ?? '',
  );
  final Stopwatch _stopwatch = Stopwatch();
  final TextEditingController _controller = TextEditingController();
  bool _found = false;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
  }

  Future<void> _submit() async {
    if (_challenge.check(_controller.text)) {
      _stopwatch.stop();
      _elapsed = _stopwatch.elapsed;
      setState(() => _found = true);
      await recordSession(
        ref,
        ReadingSession(
          type: ExerciseType.scanning,
          wordCount: widget.text.wordCount,
          elapsed: _elapsed,
          wpm: _elapsed > Duration.zero
              ? wordsPerMinute(
                  wordCount: widget.text.wordCount,
                  elapsed: _elapsed,
                )
              : 0,
          textId: widget.text.id,
          date: ref.read(clockProvider).now(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.scanKeepLooking)),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    if (_found) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.text.title)),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emoji_events, size: 72, color: scheme.primary),
              const SizedBox(height: 16),
              Text(
                l10n.scanFound(_elapsed.inSeconds),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              FilledButton.tonal(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.finish),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.text.title)),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: scheme.tertiaryContainer,
            child: Text(
              l10n.scanTargetLabel(widget.text.scanTarget ?? ''),
              style: TextStyle(
                color: scheme.onTertiaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Text(
                widget.text.body,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: l10n.yourAnswer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(onPressed: _submit, child: Text(l10n.validate)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
