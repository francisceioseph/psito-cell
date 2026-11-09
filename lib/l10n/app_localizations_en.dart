// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Psito Cell';

  @override
  String get newGame => 'New game';

  @override
  String get restart => 'Restart this game';

  @override
  String get undo => 'Undo';

  @override
  String moves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count moves',
      one: '1 move',
    );
    return '$_temp0';
  }

  @override
  String get youWon => 'You won!';

  @override
  String get playAgain => 'Play again';

  @override
  String get freePerch => 'Free perch';

  @override
  String get emptyColumn => 'Empty column';

  @override
  String nestOf(String suit) {
    return 'Nest of $suit';
  }

  @override
  String cardName(String rank, String suit) {
    return '$rank of $suit';
  }

  @override
  String get rankAce => 'Ace';

  @override
  String get rankJack => 'Jack';

  @override
  String get rankQueen => 'Queen';

  @override
  String get rankKing => 'King';

  @override
  String get suitClubs => 'clubs';

  @override
  String get suitSpades => 'spades';

  @override
  String get suitHearts => 'hearts';

  @override
  String get suitDiamonds => 'diamonds';

  @override
  String winSummary(String moves, String time) {
    return '$moves in $time';
  }

  @override
  String get yourName => 'Your name';

  @override
  String get save => 'Save';

  @override
  String get skip => 'Skip';

  @override
  String get bestGames => 'Best games';

  @override
  String get noScores => 'No games won yet.';

  @override
  String get close => 'Close';

  @override
  String get statGame => 'Game';

  @override
  String get statMoves => 'Moves';

  @override
  String get statTime => 'Time';

  @override
  String get moreOptions => 'More options';

  @override
  String get chooseGame => 'Choose a game number';

  @override
  String get howToPlay => 'How to play';

  @override
  String get about => 'About';

  @override
  String get cancel => 'Cancel';

  @override
  String get play => 'Play';

  @override
  String get howToPlayBody =>
      'Move all the cards to the four nests, from Ace to King, by suit.\n\nIn the columns, a card goes on one rank higher, of the other colour. Each perch holds one card at a time.\n\nClick a card and then its destination, or drag it. A double click sends it to the best place. Cards that are no longer needed fly to the nests on their own.\n\nThe free spaces decide how many cards can move at once.\n\nCtrl+Z undoes, Ctrl+R restarts this game and Ctrl+N starts a new one.';

  @override
  String get aboutBody =>
      'A cozy solitaire with cockatiels. No ads, no telemetry and no account.';

  @override
  String get aboutLegal =>
      'Code under the Apache 2.0 license. Card art under CC0.';
}
