import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Grande carte de résultat : vitesse, compréhension et vitesse effective.
class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.wpm,
    this.comprehension,
    this.effectiveWpm,
  });

  final int wpm;
  final double? comprehension;
  final int? effectiveWpm;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          children: [
            Text(
              l10n.wpmCaption,
              style: TextStyle(color: scheme.onPrimaryContainer),
            ),
            Text(
              '$wpm',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: scheme.onPrimaryContainer,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (comprehension != null || effectiveWpm != null) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (comprehension != null)
                    _Metric(
                      label: l10n.comprehension,
                      value: '${(comprehension! * 100).round()} %',
                    ),
                  if (effectiveWpm != null)
                    _Metric(label: l10n.effectiveSpeed, value: '$effectiveWpm'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: scheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: TextStyle(color: scheme.onPrimaryContainer)),
      ],
    );
  }
}
