import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme.dart';

/// LR16 — Techniques mnémoniques : contenu pédagogique statique (français,
/// non traduit v1) présenté en cartes de référence rapide.
class MnemonicsScreen extends StatelessWidget {
  const MnemonicsScreen({super.key});

  static const List<_Technique> _techniques = [
    _Technique(
      icon: Icons.account_balance,
      title: 'Palais de mémoire (méthode des lieux)',
      body:
          'Choisis un lieu que tu connais bien (ta maison, ton trajet). Associe '
          'chaque idée à retenir à un endroit précis, dans l\'ordre du parcours. '
          'Pour te rappeler, refais mentalement la promenade : chaque endroit '
          'te rendra l\'idée qui y est attachée.',
      example:
          'Trois causes d\'un événement historique → assigne-les à ta porte '
          'd\'entrée, ton salon, ta cuisine. Tu les retrouveras en visualisant '
          'ton trajet.',
    ),
    _Technique(
      icon: Icons.grid_view,
      title: 'Regroupement (chunking)',
      body:
          'Le cerveau retient mal les longues listes brutes. Regroupe les '
          'éléments par 3-4, en formant des blocs qui ont du sens : catégorie, '
          'rime, motif visuel.',
      example:
          'Un numéro « 0698472103 » se retient mieux ainsi : 06.98.47.21.03. '
          'Un texte de 10 idées → regroupe-les en 3 thèmes.',
    ),
    _Technique(
      icon: Icons.abc,
      title: 'Acronymes et phrases-mnémos',
      body:
          'Prends la première lettre de chaque mot à retenir et fabrique un mot '
          'ou une phrase mémorable — plus elle est absurde, mieux tu t\'en '
          'souviens.',
      example:
          '« Mais Où Est Donc Ornicar » = les conjonctions de coordination '
          '(mais, ou, et, donc, or, ni, car). Toute une leçon en 5 mots.',
    ),
    _Technique(
      icon: Icons.visibility,
      title: 'Imagerie mentale',
      body:
          'Transforme une idée abstraite en image mentale vive : couleur, '
          'mouvement, taille exagérée, humour. Le cerveau retient dix fois mieux '
          'les images que les concepts.',
      example:
          'Pour retenir « la population des abeilles a chuté de 40 % » : '
          'imagine une ruche géante à moitié vide, avec des abeilles fatiguées '
          'portant une pancarte « −40 % ».',
    ),
    _Technique(
      icon: Icons.link,
      title: 'Chaînage narratif',
      body:
          'Pour retenir une liste dans l\'ordre, tisse une petite histoire où '
          'chaque élément mène au suivant. L\'ordre naturel du récit fait le '
          'travail à ta place.',
      example:
          'Pain – lampe – vélo – parapluie : « Le pain saute sous la lampe, '
          'roule sur un vélo, et s\'abrite d\'un parapluie. »',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.mnemonicsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Ces techniques ancrent durablement ce que tu lis. '
            'Choisis-en une, mets-la en pratique sur le texte du jour, '
            'et vérifie ton rappel demain.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          for (final t in _techniques) ...[
            _TechniqueCard(technique: t),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _Technique {
  const _Technique({
    required this.icon,
    required this.title,
    required this.body,
    required this.example,
  });
  final IconData icon;
  final String title;
  final String body;
  final String example;
}

class _TechniqueCard extends StatelessWidget {
  const _TechniqueCard({required this.technique});
  final _Technique technique;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(technique.icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  technique.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(technique.body, style: const TextStyle(height: 1.5)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primarySoft.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              technique.example,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
