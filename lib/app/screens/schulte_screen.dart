import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/measure/reading_session.dart';
import '../../domain/schulte/schulte_generator.dart';
import '../../domain/schulte/schulte_run.dart';
import '../../domain/schulte/schulte_table.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';

/// Table de Schulte : toucher 1, 2, 3… dans l'ordre pour élargir l'empan visuel.
class SchulteScreen extends ConsumerStatefulWidget {
  const SchulteScreen({super.key});

  @override
  ConsumerState<SchulteScreen> createState() => _SchulteScreenState();
}

class _SchulteScreenState extends ConsumerState<SchulteScreen> {
  int _size = 5;
  late SchulteTable _table;
  late SchulteRun _run;
  bool _started = false;
  bool _done = false;
  int? _wrong;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    _table = SchulteGenerator(
      ref.read(randomSourceProvider),
    ).generate(size: _size);
    _run = SchulteRun(ref.read(clockProvider), count: _table.count);
    _started = false;
    _done = false;
    _wrong = null;
  }

  void _start() => setState(() {
    _run.start();
    _started = true;
  });

  Future<void> _tap(int value) async {
    if (!_started || _done) return;
    if (_run.tap(value)) {
      if (_run.isComplete) {
        setState(() => _done = true);
        await recordSession(
          ref,
          ReadingSession(
            type: ExerciseType.schulte,
            wordCount: _table.count,
            elapsed: _run.elapsed,
            wpm: 0,
            date: ref.read(clockProvider).now(),
          ),
        );
      } else {
        setState(() {});
      }
    } else {
      setState(() => _wrong = value);
      Timer(const Duration(milliseconds: 250), () {
        if (mounted) setState(() => _wrong = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.exSchulteTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children: [
                for (final n in [3, 4, 5, 6, 7])
                  ChoiceChip(
                    label: Text('$n×$n'),
                    selected: _size == n,
                    onSelected: (_) => setState(() {
                      _size = n;
                      _generate();
                    }),
                  ),
              ],
            ),
          ),
          if (_started && !_done)
            Text(
              l10n.schulteLooking(_run.nextExpected),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.count(
                  crossAxisCount: _size,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (final value in _table.cells)
                      _Cell(
                        value: value,
                        done: _started && value < _run.nextExpected,
                        wrong: value == _wrong,
                        onTap: () => _tap(value),
                        scheme: scheme,
                      ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _done
                  ? Column(
                      children: [
                        Text(
                          l10n.schulteDone(_run.elapsed.inSeconds, _run.errors),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () => setState(_generate),
                          icon: const Icon(Icons.replay),
                          label: Text(l10n.replay),
                        ),
                      ],
                    )
                  : FilledButton(
                      onPressed: _started ? null : _start,
                      child: Text(_started ? l10n.inProgress : l10n.start),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.value,
    required this.done,
    required this.wrong,
    required this.onTap,
    required this.scheme,
  });

  final int value;
  final bool done;
  final bool wrong;
  final VoidCallback onTap;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final Color background;
    final Color foreground;
    if (wrong) {
      background = scheme.errorContainer;
      foreground = scheme.onErrorContainer;
    } else if (done) {
      background = scheme.primary;
      foreground = scheme.onPrimary;
    } else {
      background = scheme.surfaceContainerHighest;
      foreground = scheme.onSurface;
    }

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Center(
          child: Text(
            '$value',
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
