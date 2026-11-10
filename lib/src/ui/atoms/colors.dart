import 'package:flutter/material.dart';
import 'package:psito_games_ui/psito_games_ui.dart';

abstract final class PsitoColors {
  static const felt = Color(0xFF426854);
  static const feltGlow = Color(0xFF527F68);
  static const feltDark = Color(0xFF34543F);
  static const feltLight = Color(0xFF7FA38F);
  static const cream = Color(0xFFF6EED6);
  static const black = Color(0xFF3B3842);
  static const edge = Color(0xFFAE9A74);
  static const accent = Color(0xFFFFC107);
  static const onFelt = Color(0xFFF3EFE0);
  static const onFeltMuted = Color(0xFFA9C3B3);
  static const barTop = Color(0xFF2F4A3A);
  static const barBottom = Color(0xFF263E30);
}

/// The green felt of the table, for the shared widgets.
const cellPalette = GamePalette(
  felt: PsitoColors.felt,
  feltGlow: PsitoColors.feltGlow,
  feltDark: PsitoColors.feltDark,
  feltLight: PsitoColors.feltLight,
  barTop: PsitoColors.barTop,
  barBottom: PsitoColors.barBottom,
  onFelt: PsitoColors.onFelt,
  onFeltMuted: PsitoColors.onFeltMuted,
  cream: PsitoColors.cream,
  ink: PsitoColors.black,
);
