// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Psito Cell';

  @override
  String moves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Züge',
      one: '1 Zug',
    );
    return '$_temp0';
  }

  @override
  String get youWon => 'Gewonnen!';

  @override
  String get freePerch => 'Freie Stange';

  @override
  String get emptyColumn => 'Leere Spalte';

  @override
  String nestOf(String suit) {
    return 'Nest für $suit';
  }

  @override
  String cardName(String rank, String suit) {
    return '$suit-$rank';
  }

  @override
  String get rankAce => 'Ass';

  @override
  String get rankJack => 'Bube';

  @override
  String get rankQueen => 'Dame';

  @override
  String get rankKing => 'König';

  @override
  String get suitClubs => 'Kreuz';

  @override
  String get suitSpades => 'Pik';

  @override
  String get suitHearts => 'Herz';

  @override
  String get suitDiamonds => 'Karo';

  @override
  String winSummary(String moves, String time) {
    return '$moves in $time';
  }

  @override
  String get statMoves => 'Züge';

  @override
  String get howToPlayBody =>
      'Bringe alle Karten in die vier Nester, vom Ass bis zum König, nach Farbe.\n\nIn den Spalten kommt eine Karte auf eine um einen Rang höhere der anderen Farbe. Jede Stange hält eine Karte auf einmal.\n\nKlicke auf eine Karte und dann auf ihr Ziel, oder ziehe sie. Ein Doppelklick schickt sie an den besten Platz. Karten, die nicht mehr gebraucht werden, fliegen von selbst in die Nester.\n\nDie freien Plätze bestimmen, wie viele Karten auf einmal ziehen können.\n\nStrg+Z macht rückgängig, Strg+R startet dieses Spiel neu und Strg+N beginnt ein neues.';

  @override
  String get aboutBody =>
      'Eine gemütliche Patience mit Nymphensittichen. Ohne Werbung, ohne Telemetrie und ohne Konto.';

  @override
  String get aboutLegal =>
      'Code unter der Apache-2.0-Lizenz. Kartengrafiken unter CC0.';
}
