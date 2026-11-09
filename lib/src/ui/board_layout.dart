import 'dart:math';

import 'package:flutter/widgets.dart';

import '../game/game_state.dart';

/// Where everything goes for a given window size.
class BoardLayout {
  BoardLayout._(this.size, this.cardWidth, this.cardHeight, this.gap, this.left);

  factory BoardLayout.fit(Size size) {
    final gap = (size.width * .012).clamp(6.0, 16.0);
    final byWidth = (size.width - pad * 2 - gap * 7) / 8;
    final byHeight = (size.height - pad * 2 - gap * 2) / 4.3 / aspect;
    final width = max(24.0, min(byWidth, byHeight));
    final height = width * aspect;
    final left = (size.width - (width * 8 + gap * 7)) / 2;
    return BoardLayout._(size, width, height, gap, left);
  }

  static const pad = 12.0;
  static const aspect = 1.4;

  final Size size;
  final double cardWidth;
  final double cardHeight;
  final double gap;
  final double left;

  double get _tableauTop => pad + cardHeight + gap * 2;

  double _columnX(int column) => left + column * (cardWidth + gap);

  /// The distance between cards of a column. It shrinks when the column would
  /// not fit in the window.
  double stepFor(int count) {
    final full = cardHeight * .205;
    if (count <= 1) return full;
    final room = size.height - _tableauTop - pad - cardHeight;
    return max(cardHeight * .1, min(full, room / (count - 1)));
  }

  Offset slot(Pile pile) => switch (pile.kind) {
    PileKind.cell => Offset(_columnX(pile.index), pad),
    PileKind.foundation => Offset(_columnX(pile.index + 4), pad),
    PileKind.column => Offset(_columnX(pile.index), _tableauTop),
  };

  Offset position(Pile pile, int index, int count) {
    final base = slot(pile);
    if (pile.kind != PileKind.column) return base;
    return base + Offset(0, index * stepFor(count));
  }

  /// The place under a point, if there is one.
  Pile? pileAt(Offset point) {
    final column = ((point.dx - left + gap / 2) / (cardWidth + gap)).floor();
    if (column < 0 || column > 7) return null;
    if (point.dy >= _tableauTop - gap) return Pile.column(column);
    return column < 4 ? Pile.cell(column) : Pile.foundation(column - 4);
  }
}
