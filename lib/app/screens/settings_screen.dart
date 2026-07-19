import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/settings/reading_settings.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';
import '../widgets/language_flag.dart';

/// Onglet « Réglages » : langue, préférences de lecture, rappel, données.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  /// Langues proposées : code et nom (dans la langue elle-même). Le drapeau
  /// est rendu en SVG par [LanguageFlag].
  static const List<({String code, String name})> _languages = [
    (code: 'fr', name: 'Français'),
    (code: 'en', name: 'English'),
    (code: 'es', name: 'Español'),
    (code: 'it', name: 'Italiano'),
    (code: 'de', name: 'Deutsch'),
    (code: 'pt', name: 'Português'),
  ];

  ({String code, String name}) _lang(String? code) => _languages.firstWhere(
    (l) => l.code == code,
    orElse: () => _languages.first,
  );

  void _pickLanguage(
    BuildContext context,
    WidgetRef ref,
    ReadingSettings settings,
    AppLocalizations l10n,
  ) {
    Widget option(({String code, String name}) lang) {
      final selected = (settings.localeCode ?? 'fr') == lang.code;
      return SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context);
          ref
              .read(settingsProvider.notifier)
              .update(settings.copyWith(localeCode: lang.code));
        },
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            LanguageFlag(code: lang.code),
            const SizedBox(width: 12),
            Text(lang.name),
          ],
        ),
      );
    }

    showDialog<void>(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text(l10n.language),
        children: [for (final lang in _languages) option(lang)],
      ),
    );
  }

  static String _emphasisLabel(AppLocalizations l10n, ScrambleEmphasis mode) =>
      switch (mode) {
        ScrambleEmphasis.colorEnds => l10n.markColorEnds,
        ScrambleEmphasis.dimMiddle => l10n.markDimMiddle,
        ScrambleEmphasis.underline => l10n.markUnderline,
        ScrambleEmphasis.none => l10n.markNone,
      };

  void _pickEmphasis(
    BuildContext context,
    WidgetRef ref,
    ReadingSettings settings,
    AppLocalizations l10n,
  ) {
    Widget option(ScrambleEmphasis mode) {
      final selected = settings.scrambleEmphasis == mode;
      return SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context);
          ref
              .read(settingsProvider.notifier)
              .update(settings.copyWith(scrambleEmphasis: mode));
        },
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Text(_emphasisLabel(l10n, mode)),
          ],
        ),
      );
    }

    showDialog<void>(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text(l10n.scrambleMarkers),
        children: [for (final mode in ScrambleEmphasis.values) option(mode)],
      ),
    );
  }

  static String _intensityLabel(
    AppLocalizations l10n,
    ScrambleIntensity mode,
  ) => switch (mode) {
    ScrambleIntensity.easy => l10n.intensityEasy,
    ScrambleIntensity.medium => l10n.intensityMedium,
    ScrambleIntensity.hard => l10n.intensityHard,
  };

  void _pickIntensity(
    BuildContext context,
    WidgetRef ref,
    ReadingSettings settings,
    AppLocalizations l10n,
  ) {
    Widget option(ScrambleIntensity mode) {
      final selected = settings.scrambleIntensity == mode;
      return SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context);
          ref
              .read(settingsProvider.notifier)
              .update(settings.copyWith(scrambleIntensity: mode));
        },
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Text(_intensityLabel(l10n, mode)),
          ],
        ),
      );
    }

    showDialog<void>(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text(l10n.scrambleIntensity),
        children: [for (final mode in ScrambleIntensity.values) option(mode)],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LanguageFlag(code: settings.localeCode ?? 'fr', width: 22),
                const SizedBox(width: 8),
                Text(_lang(settings.localeCode).name),
              ],
            ),
            onTap: () => _pickLanguage(context, ref, settings, l10n),
          ),
          const Divider(),
          SwitchListTile(
            title: Text(l10n.darkTheme),
            secondary: const Icon(Icons.dark_mode),
            value: settings.darkMode,
            onChanged: (v) => controller.update(settings.copyWith(darkMode: v)),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.speed),
            title: Text(l10n.defaultSpeed),
            subtitle: Text(l10n.wpmValue(settings.defaultWpm)),
          ),
          Slider(
            value: settings.defaultWpm.toDouble(),
            min: 100,
            max: 800,
            divisions: 28,
            label: '${settings.defaultWpm}',
            onChanged: (v) =>
                controller.update(settings.copyWith(defaultWpm: v.round())),
          ),
          ListTile(
            leading: const Icon(Icons.view_column),
            title: Text(l10n.groupSize),
            subtitle: Text(l10n.wordsValue(settings.chunkSize)),
          ),
          Slider(
            value: settings.chunkSize.toDouble(),
            min: 1,
            max: 6,
            divisions: 5,
            label: '${settings.chunkSize}',
            onChanged: (v) =>
                controller.update(settings.copyWith(chunkSize: v.round())),
          ),
          const Divider(),
          SwitchListTile(
            title: Text(l10n.slowLongWords),
            secondary: const Icon(Icons.text_fields),
            value: settings.slowLongWords,
            onChanged: (v) =>
                controller.update(settings.copyWith(slowLongWords: v)),
          ),
          SwitchListTile(
            title: Text(l10n.pauseOnPunctuation),
            secondary: const Icon(Icons.more_horiz),
            value: settings.pauseOnPunctuation,
            onChanged: (v) =>
                controller.update(settings.copyWith(pauseOnPunctuation: v)),
          ),
          ListTile(
            leading: const Icon(Icons.shuffle),
            title: Text(l10n.scrambleMarkers),
            subtitle: Text(_emphasisLabel(l10n, settings.scrambleEmphasis)),
            onTap: () => _pickEmphasis(context, ref, settings, l10n),
          ),
          ListTile(
            leading: const Icon(Icons.tune),
            title: Text(l10n.scrambleIntensity),
            subtitle: Text(_intensityLabel(l10n, settings.scrambleIntensity)),
            onTap: () => _pickIntensity(context, ref, settings, l10n),
          ),
          SwitchListTile(
            title: Text(l10n.scrambleStable),
            subtitle: Text(l10n.scrambleStableSub),
            secondary: const Icon(Icons.lock_outline),
            value: settings.scrambleStable,
            onChanged: (v) =>
                controller.update(settings.copyWith(scrambleStable: v)),
          ),
          SwitchListTile(
            title: Text(l10n.scrambleComfort),
            subtitle: Text(l10n.scrambleComfortSub),
            secondary: const Icon(Icons.format_line_spacing),
            value: settings.scrambleComfort,
            onChanged: (v) =>
                controller.update(settings.copyWith(scrambleComfort: v)),
          ),
          const Divider(),
          SwitchListTile(
            title: Text(l10n.dailyReminder),
            secondary: const Icon(Icons.notifications_active_outlined),
            value: settings.reminderEnabled,
            onChanged: (v) =>
                controller.update(settings.copyWith(reminderEnabled: v)),
          ),
          if (settings.reminderEnabled)
            ListTile(
              leading: const Icon(Icons.schedule),
              title: Text(l10n.reminderTime),
              subtitle: Text(
                '${settings.reminderHour.toString().padLeft(2, '0')}:'
                '${settings.reminderMinute.toString().padLeft(2, '0')}',
              ),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: settings.reminderHour,
                    minute: settings.reminderMinute,
                  ),
                );
                if (picked != null) {
                  controller.update(
                    settings.copyWith(
                      reminderHour: picked.hour,
                      reminderMinute: picked.minute,
                    ),
                  );
                }
              },
            ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.delete_sweep,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(l10n.clearHistory),
            subtitle: Text(l10n.clearHistorySubtitle),
            onTap: () async {
              await ref.read(sessionRepositoryProvider).clear();
              ref.invalidate(sessionsProvider);
              ref.invalidate(progressProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.historyCleared)));
              }
            },
          ),
          const Divider(),
          AboutListTile(
            icon: const Icon(Icons.info_outline),
            applicationName: 'Lira',
            applicationVersion: '0.1.0',
            aboutBoxChildren: [Text(l10n.aboutDescription)],
          ),
        ],
      ),
    );
  }
}
