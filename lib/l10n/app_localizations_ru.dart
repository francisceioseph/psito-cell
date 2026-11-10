// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Psito Cell';

  @override
  String moves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ходов',
      few: '$count хода',
      one: '$count ход',
    );
    return '$_temp0';
  }

  @override
  String get youWon => 'Вы выиграли!';

  @override
  String get freePerch => 'Свободная жёрдочка';

  @override
  String get emptyColumn => 'Пустой столбец';

  @override
  String nestOf(String suit) {
    return 'Гнездо $suit';
  }

  @override
  String cardName(String rank, String suit) {
    return '$rank $suit';
  }

  @override
  String get rankAce => 'Туз';

  @override
  String get rankJack => 'Валет';

  @override
  String get rankQueen => 'Дама';

  @override
  String get rankKing => 'Король';

  @override
  String get suitClubs => 'треф';

  @override
  String get suitSpades => 'пик';

  @override
  String get suitHearts => 'червей';

  @override
  String get suitDiamonds => 'бубен';

  @override
  String winSummary(String moves, String time) {
    return '$moves за $time';
  }

  @override
  String get statMoves => 'Ходы';

  @override
  String get howToPlayBody =>
      'Переложите все карты в четыре гнезда, от туза до короля, по мастям.\n\nВ столбцах карта кладётся на карту на ранг старше и другого цвета. На каждой жёрдочке помещается одна карта.\n\nЩёлкните по карте, а затем по месту, куда её положить, или перетащите её. Двойной щелчок отправляет карту в лучшее место. Карты, которые больше не нужны, сами улетают в гнёзда.\n\nОт свободных мест зависит, сколько карт можно переложить за раз.\n\nCtrl+Z отменяет ход, Ctrl+R начинает эту партию заново, а Ctrl+N начинает новую.';

  @override
  String get aboutBody =>
      'Уютный пасьянс с кореллами. Без рекламы, без телеметрии и без учётной записи.';

  @override
  String get aboutLegal =>
      'Код под лицензией Apache 2.0. Рисунки карт под CC0.';
}
