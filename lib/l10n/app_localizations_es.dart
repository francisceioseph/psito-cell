// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Psito Cell';

  @override
  String moves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count movimientos',
      one: '1 movimiento',
    );
    return '$_temp0';
  }

  @override
  String get youWon => '¡Ganaste!';

  @override
  String get freePerch => 'Percha libre';

  @override
  String get emptyColumn => 'Columna vacía';

  @override
  String nestOf(String suit) {
    return 'Nido de $suit';
  }

  @override
  String cardName(String rank, String suit) {
    return '$rank de $suit';
  }

  @override
  String get rankAce => 'As';

  @override
  String get rankJack => 'Jota';

  @override
  String get rankQueen => 'Reina';

  @override
  String get rankKing => 'Rey';

  @override
  String get suitClubs => 'tréboles';

  @override
  String get suitSpades => 'picas';

  @override
  String get suitHearts => 'corazones';

  @override
  String get suitDiamonds => 'diamantes';

  @override
  String winSummary(String moves, String time) {
    return '$moves en $time';
  }

  @override
  String get statMoves => 'Movimientos';

  @override
  String get howToPlayBody =>
      'Lleva todas las cartas a los cuatro nidos, del As al Rey, por palo.\n\nEn las columnas, una carta va sobre otra de un valor más alto y del otro color. Cada percha guarda una carta a la vez.\n\nHaz clic en una carta y luego en su destino, o arrástrala. Un doble clic la envía al mejor lugar. Las cartas que ya no hacen falta vuelan solas a los nidos.\n\nLos espacios libres deciden cuántas cartas pueden moverse a la vez.\n\nCtrl+Z deshace, Ctrl+R reinicia esta partida y Ctrl+N empieza una nueva.';

  @override
  String get aboutBody =>
      'Un solitario acogedor con cacatúas ninfa. Sin anuncios, sin telemetría y sin cuenta.';

  @override
  String get aboutLegal =>
      'Código bajo la licencia Apache 2.0. Arte de las cartas bajo CC0.';
}
