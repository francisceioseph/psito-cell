import 'package:flutter/foundation.dart';

/// The four suits. Clubs and spades are black; hearts and diamonds are red.
enum Suit {
  clubs,
  spades,
  hearts,
  diamonds;

  bool get isRed => this == hearts || this == diamonds;
}

@immutable
class PlayingCard {
  const PlayingCard(this.suit, this.rank) : assert(rank >= 1 && rank <= 13);

  final Suit suit;

  /// 1 is the ace, 11 the jack, 12 the queen and 13 the king.
  final int rank;

  /// A number from 0 to 51 that identifies the card.
  int get id => suit.index * 13 + rank - 1;

  bool canStackOn(PlayingCard other) =>
      suit.isRed != other.suit.isRed && rank == other.rank - 1;

  @override
  bool operator ==(Object other) =>
      other is PlayingCard && other.suit == suit && other.rank == rank;

  @override
  int get hashCode => id;

  @override
  String toString() => '$rank${suit.name[0]}';
}

enum PileKind { column, cell, foundation }

/// A place on the table where cards can be.
@immutable
class Pile {
  const Pile.column(this.index) : kind = PileKind.column;
  const Pile.cell(this.index) : kind = PileKind.cell;
  const Pile.foundation(this.index) : kind = PileKind.foundation;

  final PileKind kind;
  final int index;

  @override
  bool operator ==(Object other) =>
      other is Pile && other.kind == kind && other.index == index;

  @override
  int get hashCode => Object.hash(kind, index);

  @override
  String toString() => '${kind.name}[$index]';
}

/// Shuffles the deck for a game number. The same number always gives the same
/// deal, on every platform, because the generator is written here.
List<List<PlayingCard>> dealColumns(int number) {
  final deck = [
    for (final suit in Suit.values)
      for (var rank = 1; rank <= 13; rank++) PlayingCard(suit, rank),
  ];
  var seed = number & 0x7fffffff;
  int next(int bound) {
    seed = (seed * 1103515245 + 12345) & 0x7fffffff;
    return (seed >> 8) % bound;
  }

  for (var i = deck.length - 1; i > 0; i--) {
    final j = next(i + 1);
    final swap = deck[i];
    deck[i] = deck[j];
    deck[j] = swap;
  }
  final columns = List.generate(8, (_) => <PlayingCard>[]);
  for (var i = 0; i < deck.length; i++) {
    columns[i % 8].add(deck[i]);
  }
  return columns;
}

/// The table at one moment. It never changes: a move gives a new state.
@immutable
class GameState {
  const GameState({
    required this.columns,
    required this.cells,
    required this.foundations,
  });

  factory GameState.deal(int number) => GameState(
    columns: dealColumns(number),
    cells: const [null, null, null, null],
    foundations: const [0, 0, 0, 0],
  );

  final List<List<PlayingCard>> columns;
  final List<PlayingCard?> cells;

  /// The highest rank collected for each suit, by [Suit.index].
  final List<int> foundations;

  bool get isWon => foundations.every((rank) => rank == 13);
  int get freeCells => cells.where((card) => card == null).length;
  int get emptyColumns => columns.where((column) => column.isEmpty).length;

  /// How many cards fit in one move, given the free spaces.
  int maxMovable({required bool toEmptyColumn}) {
    final empty = emptyColumns - (toEmptyColumn ? 1 : 0);
    return (freeCells + 1) << empty;
  }

  /// Whether the last [count] cards of a column form a valid sequence.
  bool isRun(int column, int count) {
    final cards = columns[column];
    if (count < 1 || count > cards.length) return false;
    for (var i = cards.length - count; i < cards.length - 1; i++) {
      if (!cards[i + 1].canStackOn(cards[i])) return false;
    }
    return true;
  }

  /// Whether [count] cards can be picked up from [pile].
  bool canPick(Pile pile, int count) => switch (pile.kind) {
    PileKind.column =>
      isRun(pile.index, count) &&
          count <= maxMovable(toEmptyColumn: false),
    PileKind.cell => count == 1 && cells[pile.index] != null,
    PileKind.foundation => false,
  };

  bool canCollect(PlayingCard card) =>
      foundations[card.suit.index] == card.rank - 1;

  PlayingCard? _top(Pile pile) => switch (pile.kind) {
    PileKind.column =>
      columns[pile.index].isEmpty ? null : columns[pile.index].last,
    PileKind.cell => cells[pile.index],
    PileKind.foundation => null,
  };

  /// The state after the move, or null if the rules do not allow it.
  GameState? move(Pile from, int count, Pile to) {
    if (from == to || !canPick(from, count)) return null;
    final moving = from.kind == PileKind.column
        ? columns[from.index].sublist(columns[from.index].length - count)
        : [cells[from.index]!];
    final lead = moving.first;

    switch (to.kind) {
      case PileKind.foundation:
        if (count != 1 || !canCollect(lead)) return null;
      case PileKind.cell:
        if (count != 1 || cells[to.index] != null) return null;
      case PileKind.column:
        final target = columns[to.index];
        if (target.isNotEmpty && !lead.canStackOn(target.last)) return null;
        if (count > maxMovable(toEmptyColumn: target.isEmpty)) return null;
    }

    final newColumns = [for (final column in columns) [...column]];
    final newCells = [...cells];
    final newFoundations = [...foundations];

    if (from.kind == PileKind.column) {
      newColumns[from.index].removeRange(
        newColumns[from.index].length - count,
        newColumns[from.index].length,
      );
    } else {
      newCells[from.index] = null;
    }

    switch (to.kind) {
      case PileKind.foundation:
        newFoundations[lead.suit.index] = lead.rank;
      case PileKind.cell:
        newCells[to.index] = lead;
      case PileKind.column:
        newColumns[to.index].addAll(moving);
    }

    return GameState(
      columns: newColumns,
      cells: newCells,
      foundations: newFoundations,
    );
  }

  /// Where a double click sends the cards: the foundation, then a column with
  /// cards, then a free cell, then an empty column.
  Pile? bestDestination(Pile from, int count) {
    if (!canPick(from, count)) return null;
    final lead = from.kind == PileKind.column
        ? columns[from.index][columns[from.index].length - count]
        : cells[from.index]!;
    if (count == 1 && canCollect(lead)) {
      return Pile.foundation(lead.suit.index);
    }
    bool accepts(Pile pile) => move(from, count, pile) != null;
    for (var i = 0; i < columns.length; i++) {
      final pile = Pile.column(i);
      if (columns[i].isNotEmpty && accepts(pile)) return pile;
    }
    if (count == 1 && from.kind != PileKind.cell) {
      final free = cells.indexOf(null);
      if (free >= 0) return Pile.cell(free);
    }
    for (var i = 0; i < columns.length; i++) {
      final pile = Pile.column(i);
      if (columns[i].isEmpty && accepts(pile)) return pile;
    }
    return null;
  }

  /// A card that can go to its foundation without ever being needed on the
  /// table: every lower card of the other colour has already been collected.
  bool _isSafe(PlayingCard card) {
    if (!canCollect(card)) return false;
    if (card.rank <= 2) return true;
    for (final suit in Suit.values) {
      if (suit.isRed != card.suit.isRed &&
          foundations[suit.index] < card.rank - 1) {
        return false;
      }
    }
    return true;
  }

  /// The next card that can be collected on its own, if there is one.
  Pile? nextSafe() {
    for (var i = 0; i < columns.length; i++) {
      final top = _top(Pile.column(i));
      if (top != null && _isSafe(top)) return Pile.column(i);
    }
    for (var i = 0; i < cells.length; i++) {
      final top = _top(Pile.cell(i));
      if (top != null && _isSafe(top)) return Pile.cell(i);
    }
    return null;
  }
}
