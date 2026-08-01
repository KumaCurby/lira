import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme.dart';

/// LR20 — Programme d'entraînement structuré sur 6 semaines. Chaque semaine
/// dose les exercices pour construire progressivement l'endurance et la
/// vitesse — sans sacrifier la compréhension. Contenu statique v1 (FR).
class ProgramScreen extends StatelessWidget {
  const ProgramScreen({super.key});

  static const List<_Week> _program = [
    _Week(
      number: 1,
      theme: 'S1 · Poser les bases',
      target: 'Objectif : 300 mpm avec 80 % de compréhension.',
      days: [
        _Day(label: 'Lundi', exercises: 'Test de vitesse (mesure initiale)'),
        _Day(label: 'Mardi', exercises: 'RSVP 250 mpm · Guidage groupes de 2'),
        _Day(label: 'Mercredi', exercises: 'Schulte 3×3 · Écrémage'),
        _Day(label: 'Jeudi', exercises: 'RSVP 300 mpm · Test de vitesse'),
        _Day(label: 'Vendredi', exercises: 'Révisions SRS · Lecture normale'),
      ],
    ),
    _Week(
      number: 2,
      theme: 'S2 · Étendre l\'empan',
      target: 'Objectif : lire par groupes de 3 mots.',
      days: [
        _Day(label: 'Lundi', exercises: 'Empan progressif · Schulte 4×4'),
        _Day(label: 'Mardi', exercises: 'Colonnes 2 · Écrémage'),
        _Day(label: 'Mercredi', exercises: 'Guidage groupes de 3 à 350 mpm'),
        _Day(label: 'Jeudi', exercises: 'Colonnes 3 · Balayage'),
        _Day(label: 'Vendredi', exercises: 'Révisions SRS · Test de vitesse'),
      ],
    ),
    _Week(
      number: 3,
      theme: 'S3 · Faire taire la voix intérieure',
      target: 'Objectif : 400 mpm avec 75 % de compréhension.',
      days: [
        _Day(label: 'Lundi', exercises: 'Sans voix intérieure 120 bpm'),
        _Day(label: 'Mardi', exercises: 'Mots-clés (estompé) · RSVP 400 mpm'),
        _Day(
          label: 'Mercredi',
          exercises: 'Sans voix intérieure 140 bpm · Notes Cornell',
        ),
        _Day(label: 'Jeudi', exercises: 'Mots mélangés · Révisions'),
        _Day(
          label: 'Vendredi',
          exercises: 'Test de vitesse + résumé 3 phrases',
        ),
      ],
    ),
    _Week(
      number: 4,
      theme: 'S4 · Ancrer la mémoire',
      target: 'Objectif : 20 cartes SRS actives, révisions quotidiennes.',
      days: [
        _Day(label: 'Lundi', exercises: 'Lecture soutenue + notes Cornell'),
        _Day(label: 'Mardi', exercises: 'RSVP 400 mpm · Révisions SRS'),
        _Day(
          label: 'Mercredi',
          exercises: 'Test de vitesse + résumé + rappel J+1',
        ),
        _Day(label: 'Jeudi', exercises: 'Techniques mnémoniques + application'),
        _Day(
          label: 'Vendredi',
          exercises: 'Écrémage + quiz rapide · Révisions',
        ),
      ],
    ),
    _Week(
      number: 5,
      theme: 'S5 · Chercher le plafond',
      target: 'Objectif : identifier ta vitesse plafond.',
      days: [
        _Day(label: 'Lundi', exercises: 'Vitesse plafond (première mesure)'),
        _Day(label: 'Mardi', exercises: 'RSVP à 90 % du plafond · Notes'),
        _Day(label: 'Mercredi', exercises: 'Vitesse plafond (2e mesure)'),
        _Day(label: 'Jeudi', exercises: 'Colonnes 3 · Mots-clés'),
        _Day(
          label: 'Vendredi',
          exercises: 'Test de vitesse + comparaison au plafond',
        ),
      ],
    ),
    _Week(
      number: 6,
      theme: 'S6 · Simuler le concours',
      target: 'Objectif : score composite ≥ 350.',
      days: [
        _Day(label: 'Lundi', exercises: 'Compétition (texte niveau 4)'),
        _Day(label: 'Mardi', exercises: 'Révisions · Notes Cornell'),
        _Day(label: 'Mercredi', exercises: 'Compétition (texte niveau 5)'),
        _Day(label: 'Jeudi', exercises: 'Vitesse plafond + Colonnes'),
        _Day(
          label: 'Vendredi',
          exercises: 'Compétition finale · Bilan personnel',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.programTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.programIntro,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          for (final w in _program) ...[
            _WeekCard(week: w),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _Week {
  const _Week({
    required this.number,
    required this.theme,
    required this.target,
    required this.days,
  });
  final int number;
  final String theme;
  final String target;
  final List<_Day> days;
}

class _Day {
  const _Day({required this.label, required this.exercises});
  final String label;
  final String exercises;
}

class _WeekCard extends StatefulWidget {
  const _WeekCard({required this.week});
  final _Week week;

  @override
  State<_WeekCard> createState() => _WeekCardState();
}

class _WeekCardState extends State<_WeekCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${widget.week.number}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.week.theme,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.week.target,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(_open ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
          if (_open) ...[
            const Divider(height: 1),
            for (final d in widget.week.days)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        d.label,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Expanded(child: Text(d.exercises)),
                  ],
                ),
              ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
