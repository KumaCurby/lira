import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/measure/comprehension_score.dart';
import '../../domain/srs/srs_card.dart';
import '../../domain/srs/srs_scheduler.dart';
import '../../domain/text/reading_text.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';
import '../theme.dart';

/// LR13 — Écran de révision espacée. Enchaîne les cartes dues (une par une)
/// et propose 4 qualités de réponse ; chaque tap replanifie la carte.
class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  bool _revealed = false;
  int _reviewed = 0;
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dueAsync = ref.watch(dueSrsCardsProvider);
    final textsAsync = ref.watch(textsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reviewTitle)),
      body: dueAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (due) => textsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (texts) {
            final byId = {for (final t in texts) t.id: t};
            if (due.isEmpty || _current >= due.length) {
              return _empty(context, l10n);
            }
            final card = due[_current];
            final text = byId[card.textId];
            return _cardView(context, l10n, card, text);
          },
        ),
      ),
    );
  }

  Widget _empty(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 72,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              _reviewed > 0 ? l10n.reviewDone(_reviewed) : l10n.reviewEmpty,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardView(
    BuildContext context,
    AppLocalizations l10n,
    SrsCard card,
    ReadingText? text,
  ) {
    final questionIdx = _questionIndex(card.cardKey);
    final question =
        (questionIdx != null &&
            text != null &&
            questionIdx < text.questions.length)
        ? text.questions[questionIdx]
        : null;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                l10n.reviewProgress(_current + 1, _reviewed + _remaining()),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: question == null
                ? Center(child: Text(l10n.reviewMissing))
                : _quizCard(context, l10n, question, text),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _revealed
                ? _qualityBar(context, l10n, card)
                : SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => setState(() => _revealed = true),
                      icon: const Icon(Icons.visibility),
                      label: Text(l10n.reviewShowAnswer),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _quizCard(
    BuildContext context,
    AppLocalizations l10n,
    Question q,
    ReadingText? text,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (text != null) ...[
            Text(
              text.title,
              style: TextStyle(color: scheme.outline, fontSize: 12),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            q.prompt,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < q.options.length; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: _revealed && i == q.correctIndex
                    ? AppColors.primarySoft.withValues(alpha: 0.6)
                    : scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
                border: _revealed && i == q.correctIndex
                    ? Border.all(color: AppColors.primary, width: 1.5)
                    : null,
              ),
              child: Row(
                children: [
                  if (_revealed && i == q.correctIndex)
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  Expanded(child: Text(q.options[i])),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _qualityBar(
    BuildContext context,
    AppLocalizations l10n,
    SrsCard card,
  ) {
    Widget b(String label, SrsAnswer a, Color c) => Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FilledButton(
          onPressed: () => _answer(card, a),
          style: FilledButton.styleFrom(backgroundColor: c),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
    return Row(
      children: [
        b(l10n.srsAgain, SrsAnswer.again, const Color(0xFFE53935)),
        b(l10n.srsHard, SrsAnswer.hard, const Color(0xFFFB8C00)),
        b(l10n.srsGood, SrsAnswer.good, const Color(0xFF43A047)),
        b(l10n.srsEasy, SrsAnswer.easy, const Color(0xFF00897B)),
      ],
    );
  }

  Future<void> _answer(SrsCard card, SrsAnswer answer) async {
    final now = ref.read(clockProvider).now();
    final next = scheduleNext(card, answer, now: now);
    await ref.read(srsRepositoryProvider).upsert(next);
    if (!mounted) return;
    setState(() {
      _reviewed++;
      _current++;
      _revealed = false;
    });
    ref.invalidate(srsCardsProvider);
    ref.invalidate(dueSrsCardsProvider);
  }

  int _remaining() {
    final due = ref.read(dueSrsCardsProvider).valueOrNull ?? const [];
    return due.length - _current;
  }

  int? _questionIndex(String key) {
    if (!key.startsWith('q:')) return null;
    return int.tryParse(key.substring(2));
  }
}
