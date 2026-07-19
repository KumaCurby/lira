import 'package:flutter/material.dart';

/// Affiche un mot RSVP avec sa lettre-pivot (ORP) mise en couleur, encadrée de
/// deux marqueurs verticaux — le repère visuel classique de la lecture flashée.
class RsvpWordView extends StatelessWidget {
  const RsvpWordView({super.key, required this.word, required this.orpIndex});

  final String word;
  final int orpIndex;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.w800,
      letterSpacing: 1.5,
    );

    final safeIndex = word.isEmpty
        ? 0
        : orpIndex.clamp(0, word.length - 1).toInt();
    final before = word.isEmpty ? '' : word.substring(0, safeIndex);
    final pivot = word.isEmpty ? '' : word.substring(safeIndex, safeIndex + 1);
    final after = word.isEmpty ? '' : word.substring(safeIndex + 1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.arrow_drop_down, color: scheme.primary),
        RichText(
          text: TextSpan(
            style: style,
            children: [
              TextSpan(
                text: before,
                style: TextStyle(color: scheme.onSurface),
              ),
              TextSpan(
                text: pivot,
                style: TextStyle(color: scheme.primary),
              ),
              TextSpan(
                text: after,
                style: TextStyle(color: scheme.onSurface),
              ),
            ],
          ),
        ),
        Icon(Icons.arrow_drop_up, color: scheme.primary),
      ],
    );
  }
}
