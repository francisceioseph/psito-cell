// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Psito Cell';

  @override
  String moves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count coups',
      one: '1 coup',
      zero: '0 coup',
    );
    return '$_temp0';
  }

  @override
  String get youWon => 'Vous avez gagné !';

  @override
  String get freePerch => 'Perchoir libre';

  @override
  String get emptyColumn => 'Colonne vide';

  @override
  String nestOf(String suit) {
    return 'Nid de $suit';
  }

  @override
  String cardName(String rank, String suit) {
    return '$rank de $suit';
  }

  @override
  String get rankAce => 'As';

  @override
  String get rankJack => 'Valet';

  @override
  String get rankQueen => 'Dame';

  @override
  String get rankKing => 'Roi';

  @override
  String get suitClubs => 'trèfle';

  @override
  String get suitSpades => 'pique';

  @override
  String get suitHearts => 'cœur';

  @override
  String get suitDiamonds => 'carreau';

  @override
  String winSummary(String moves, String time) {
    return '$moves en $time';
  }

  @override
  String get statMoves => 'Coups';

  @override
  String get howToPlayBody =>
      'Placez toutes les cartes dans les quatre nids, de l’As au Roi, par couleur.\n\nDans les colonnes, une carte se pose sur une carte d’un rang au-dessus, de l’autre couleur. Chaque perchoir garde une carte à la fois.\n\nCliquez sur une carte puis sur sa destination, ou faites-la glisser. Un double clic l’envoie au meilleur endroit. Les cartes dont on n’a plus besoin s’envolent seules vers les nids.\n\nLes places libres décident du nombre de cartes qui peuvent bouger ensemble.\n\nCtrl+Z annule, Ctrl+R recommence cette partie et Ctrl+N en lance une nouvelle.';

  @override
  String get aboutBody =>
      'Une réussite douillette avec des calopsittes. Sans publicité, sans télémétrie et sans compte.';

  @override
  String get aboutLegal =>
      'Code sous licence Apache 2.0. Illustrations des cartes sous CC0.';
}
