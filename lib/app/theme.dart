import 'package:flutter/material.dart';

/// Palette « Corail » de Lira — reprise du modèle de référence (livraison).
///
/// Primaire `#F26158`, foncé `#C0392B`, doux `#FBD3CE`, fond crème `#FCF4E9`.
class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFFF26158); // corail
  static const Color primaryDark = Color(0xFFC0392B); // en-têtes
  static const Color primarySoft = Color(0xFFFBD3CE); // cartes / puces
  static const Color cream = Color(0xFFFCF4E9); // fond clair
  static const Color darkBg = Color(0xFF1C1917); // fond sombre chaud
  static const Color ink = Color(0xFF2B2B2B);
  static const Color inkSoft = Color(0xFF8A8A8A);
}

/// Couleur d'amorce (conservée pour la génération d'icône/splash).
const Color seedColor = AppColors.primary;

/// Construit le thème Material 3 de l'app pour une luminosité donnée.
ThemeData buildTheme(Brightness brightness) {
  final isLight = brightness == Brightness.light;
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: brightness,
  ).copyWith(primary: AppColors.primary, onPrimary: Colors.white);

  final bg = isLight ? AppColors.cream : AppColors.darkBg;
  final cardColor = isLight ? Colors.white : scheme.surfaceContainerHigh;

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: bg,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide.none,
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
