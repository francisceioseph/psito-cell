// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Psito Cell';

  @override
  String moves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 步',
    );
    return '$_temp0';
  }

  @override
  String get youWon => '你赢了！';

  @override
  String get freePerch => '空栖木';

  @override
  String get emptyColumn => '空列';

  @override
  String nestOf(String suit) {
    return '$suit的鸟巢';
  }

  @override
  String cardName(String rank, String suit) {
    return '$suit$rank';
  }

  @override
  String get rankAce => 'A';

  @override
  String get rankJack => 'J';

  @override
  String get rankQueen => 'Q';

  @override
  String get rankKing => 'K';

  @override
  String get suitClubs => '梅花';

  @override
  String get suitSpades => '黑桃';

  @override
  String get suitHearts => '红桃';

  @override
  String get suitDiamonds => '方块';

  @override
  String winSummary(String moves, String time) {
    return '用时 $time，$moves';
  }

  @override
  String get statMoves => '步数';

  @override
  String get howToPlayBody =>
      '按花色把所有的牌从 A 到 K 移到四个鸟巢里。\n\n在列中，一张牌可以放在比它大一点、颜色不同的牌上。每根栖木一次只能放一张牌。\n\n单击一张牌，再单击它要去的地方，或者直接拖动它。双击会把牌送到最合适的位置。不再需要的牌会自己飞进鸟巢。\n\n空位的多少决定了一次能移动几张牌。\n\nCtrl+Z 撤销，Ctrl+R 重新开始本局，Ctrl+N 开始新的一局。';

  @override
  String get aboutBody => '与玄凤鹦鹉一起玩的温馨纸牌游戏。没有广告，没有遥测，也不需要账号。';

  @override
  String get aboutLegal => '代码采用 Apache 2.0 许可证。牌面美术采用 CC0。';
}
