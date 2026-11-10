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

  @override
  String winSummary(String moves, String time) {
    return '$moves em $time';
  }

  @override
  String get statMoves => 'Jogadas';

  @override
  String get howToPlayBody =>
      'Leve todas as cartas para os quatro ninhos, do Ás ao Rei, por naipe.\n\nNas colunas, a carta vai sobre outra um número acima, de cor diferente. Cada poleiro guarda uma carta por vez.\n\nClique em uma carta e depois no destino, ou arraste. O duplo clique manda a carta para o melhor lugar. As cartas que não fazem mais falta voam sozinhas para os ninhos.\n\nOs espaços livres decidem quantas cartas podem se mover de uma vez.\n\nCtrl+Z desfaz, Ctrl+R recomeça este jogo e Ctrl+N começa um novo.';

  @override
  String get aboutBody =>
      'Uma paciência aconchegante com calopsitas. Sem anúncios, sem telemetria e sem conta.';

  @override
  String get aboutLegal =>
      'Código sob a licença Apache 2.0. Arte das cartas sob CC0.';
}
