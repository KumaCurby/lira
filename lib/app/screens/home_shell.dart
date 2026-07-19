import 'package:flutter/material.dart';

import '../../domain/measure/reading_session.dart';
import '../../l10n/app_localizations.dart';
import '../exercise_catalog.dart';
import '../theme.dart';
import 'library_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';
import 'text_picker_screen.dart';
import 'training_screen.dart';

/// Coquille principale : 4 onglets (Entraînement, Textes, Progrès, Réglages)
/// + bouton d'action central (accès rapide au lecteur RSVP), façon modèle.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _screens = [
    TrainingScreen(),
    LibraryScreen(),
    ProgressScreen(),
    SettingsScreen(),
  ];

  void _select(int i) => setState(() => _index = i);

  /// Le bouton central lance directement le choix d'un texte pour le RSVP.
  void _quickRsvp() {
    final rsvp = exerciseCatalog.firstWhere((e) => e.type == ExerciseType.rsvp);
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => TextPickerScreen(info: rsvp)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final barColor = Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : scheme.surfaceContainerHigh;

    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        // Pas d'animation hero : évite la collision de tag avec le FAB
        // « Ajouter » de la bibliothèque (même route, dans l'IndexedStack).
        heroTag: null,
        shape: const CircleBorder(),
        onPressed: _quickRsvp,
        tooltip: l10n.exRsvpTitle,
        child: const Icon(Icons.bolt),
      ),
      bottomNavigationBar: BottomAppBar(
        color: barColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        height: 66,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.fitness_center,
              label: l10n.tabTraining,
              index: 0,
              current: _index,
              onTap: _select,
            ),
            _NavItem(
              icon: Icons.menu_book,
              label: l10n.tabTexts,
              index: 1,
              current: _index,
              onTap: _select,
            ),
            const SizedBox(width: 48),
            _NavItem(
              icon: Icons.insights,
              label: l10n.tabProgress,
              index: 2,
              current: _index,
              onTap: _select,
            ),
            _NavItem(
              icon: Icons.settings,
              label: l10n.tabSettings,
              index: 3,
              current: _index,
              onTap: _select,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int index;
  final int current;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final selected = index == current;
    final color = selected
        ? AppColors.primary
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 23),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
