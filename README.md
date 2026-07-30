<p align="center">
  <img src="assets/branding/icon.png" width="96" alt="Lira" />
</p>

<h1 align="center">Lira</h1>

<p align="center"><em>Entraîneur de lecture rapide — Flutter, 100 % local, développé en TDD.</em></p>

<p align="center"><a href="https://kumacurby.github.io/lira/"><strong>Essayer Lira dans le navigateur ↗</strong></a></p>

---

**Lira** aide à **lire plus vite** grâce aux méthodes classiques d'entraînement, avec un
retour chiffré (mots/minute, compréhension, progression). Le cœur de l'app est un
**moteur Dart pur** entièrement testé : l'aléatoire et le temps sont injectés
(`RandomSource`, `Clock`) → exercices reproductibles en test, variés en production.

Multi-plateforme (Android · iOS · Web · macOS · Windows · Linux) et localisé en
**6 langues** — 🇫🇷 · 🇬🇧 · 🇪🇸 · 🇮🇹 · 🇩🇪 · 🇵🇹 (français par défaut).

## Exercices

| Exercice | But |
|----------|-----|
| **Lecteur RSVP** | Présentation visuelle sérielle rapide (mot par mot, lettre-pivot colorée) |
| **Guidage** | Lecture par groupes de mots, rythmée |
| **Test de vitesse** | Lecture chronométrée → quiz de compréhension → mots/min effectifs |
| **Écrémage** | Survol des idées principales |
| **Balayage** | Repérage d'une information précise |
| **Tables de Schulte** | Élargissement de la vision périphérique |
| **Mots mélangés** (typoglycémie) | Lire des mots dont l'intérieur est brassé, 1re et dernière lettre fixes |
| **Phrases mélangées** | Reconstruire le sens quand l'ordre des mots est brassé |

### Zoom sur la typoglycémie

- **Intensité** facile / moyen / difficile (dérangement : aucune lettre du milieu à sa place).
- **Repères** configurables : couleur, souligné, milieu estompé, ou aucun.
- **Comparaison** de la vitesse en lecture mélangée à ta vitesse habituelle.
- **Coup de pouce** : toucher un mot pour l'entrevoir un instant en clair.
- **Chrono** optionnel, **confort de lecture** (interligne/espacement agrandis),
  **mélange reproductible** par texte, explication au premier lancement.

## Fonctionnalités

- **Corpus intégré** (9 textes FR de difficulté croissante) **+ import EPUB / PDF** et collage de texte.
- **Progression** : meilleure vitesse, moyenne, tendance, **série de jours**, badges, courbe (`fl_chart`).
- **Reprise de lecture** là où on s'est arrêté.
- **Objectif quotidien** + **rappel** (notification locale).
- **Thème** clair / sombre (palette corail).
- **Réglages** : langue, vitesse par défaut, taille des groupes, options RSVP et typoglycémie.

## Architecture

Découpage par phases, esprit « clean » + TDD ; docstrings FR avec identifiants
d'exigence `LR0`…`LR11`.

```
lib/
  core/     RandomSource · Clock · normalisation de texte (abstractions injectables)
  domain/   moteur pur : text · measure · rsvp · pacer · schulte · skimming ·
            scramble · progress · settings · repositories (interfaces)
  data/     corpus (assets JSON) · mappers JSON · dépôts shared_preferences + mémoire ·
            import EPUB/PDF
  app/      UI Flutter : providers Riverpod · écrans · widgets · thème · navigation
  l10n/     ARB (6 langues) → AppLocalizations généré
test/       miroir de lib/ (tests en français)
```

- **État** : [Riverpod](https://riverpod.dev)
- **Persistance** : `shared_preferences` + (dé)sérialisation JSON
- **i18n** : `flutter gen-l10n` (`l10n.yaml`, template `lib/l10n/app_fr.arb`)

## Démarrer

Prérequis : [Flutter](https://docs.flutter.dev/get-started/install) (canal stable).

```bash
flutter pub get
flutter gen-l10n
flutter run              # sur un appareil / émulateur connecté
flutter run -d chrome    # dans le navigateur
```

## Qualité

```bash
flutter test                                 # 195 tests
flutter analyze                              # analyse statique
dart format --set-exit-if-changed lib test   # format
```

Un workflow **GitHub Actions** (`.github/workflows/ci.yml`) enchaîne *format → analyze →
test* à chaque push. Le fichier est présent en local ; pour l'activer sur GitHub :
`gh auth refresh -h github.com -s workflow`, puis committer et pousser le workflow.

## Statut

Phases 0 (moteur), 1 (contenu + persistance) et 2 (UI) terminées ; finitions en cours.
Version `0.1.0`.

---

<sub>Projet personnel — aucune licence définie pour l'instant.</sub>
