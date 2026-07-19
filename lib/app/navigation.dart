import 'package:flutter/material.dart';

import '../domain/measure/reading_session.dart';
import '../domain/text/reading_text.dart';
import 'screens/pacer_screen.dart';
import 'screens/rsvp_screen.dart';
import 'screens/scanning_screen.dart';
import 'screens/schulte_screen.dart';
import 'screens/scramble_screen.dart';
import 'screens/skimming_screen.dart';
import 'screens/speed_test_screen.dart';

/// Renvoie l'écran d'exercice correspondant à un [type] (et un [text] si requis).
Widget exerciseScreenFor(ExerciseType type, ReadingText? text) {
  switch (type) {
    case ExerciseType.rsvp:
      return RsvpScreen(text: text!);
    case ExerciseType.pacer:
      return PacerScreen(text: text!);
    case ExerciseType.speedTest:
      return SpeedTestScreen(text: text!);
    case ExerciseType.skimming:
      return SkimmingScreen(text: text!);
    case ExerciseType.scanning:
      return ScanningScreen(text: text!);
    case ExerciseType.schulte:
      return const SchulteScreen();
    case ExerciseType.scramble:
      return ScrambleScreen(text: text!);
    case ExerciseType.wordScramble:
      return ScrambleScreen(text: text!, mode: ScrambleMode.words);
  }
}
