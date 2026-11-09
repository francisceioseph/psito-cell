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
  String gameNumber(int number) {
    return 'Game $number';
  }

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
}
