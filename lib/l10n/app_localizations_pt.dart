// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Psito Cell';

  @override
  String get newGame => 'Novo jogo';

  @override
  String get restart => 'Recomeçar este jogo';

  @override
  String get undo => 'Desfazer';

  @override
  String gameNumber(int number) {
    return 'Jogo $number';
  }

  @override
  String moves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jogadas',
      one: '1 jogada',
      zero: '0 jogadas',
    );
    return '$_temp0';
  }

  @override
  String get youWon => 'Você venceu!';

  @override
  String get playAgain => 'Jogar de novo';

  @override
  String get freePerch => 'Poleiro livre';

  @override
  String get emptyColumn => 'Coluna vazia';

  @override
  String nestOf(String suit) {
    return 'Ninho de $suit';
  }

  @override
  String cardName(String rank, String suit) {
    return '$rank de $suit';
  }

  @override
  String get rankAce => 'Ás';

  @override
  String get rankJack => 'Valete';

  @override
  String get rankQueen => 'Dama';

  @override
  String get rankKing => 'Rei';

  @override
  String get suitClubs => 'paus';

  @override
  String get suitSpades => 'espadas';

  @override
  String get suitHearts => 'copas';

  @override
  String get suitDiamonds => 'ouros';
}
