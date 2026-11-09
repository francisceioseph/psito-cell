import 'package:flutter_test/flutter_test.dart';
import 'package:psito_cell/src/game/game_controller.dart';
import 'package:psito_cell/src/game/game_state.dart';

const _c = Suit.clubs;
const _s = Suit.spades;
const _h = Suit.hearts;
const _d = Suit.diamonds;

GameState table({
  List<List<PlayingCard>> columns = const [],
  List<PlayingCard?> cells = const [null, null, null, null],
  List<int> foundations = const [0, 0, 0, 0],
}) => GameState(
  columns: [
    ...columns,
    for (var i = columns.length; i < 8; i++) <PlayingCard>[],
  ],
  cells: cells,
  foundations: foundations,
);

void main() {
  group('deal', () {
    test('has 52 different cards in the right columns', () {
      final columns = dealColumns(42);
      expect(columns.map((c) => c.length), [7, 7, 7, 7, 6, 6, 6, 6]);
      expect(columns.expand((c) => c).map((c) => c.id).toSet().length, 52);
    });

    test('is the same for the same number and differs between numbers', () {
      expect(dealColumns(7), dealColumns(7));
      expect(dealColumns(7), isNot(dealColumns(8)));
    });
  });

  group('moves', () {
    test('a column takes a lower card of the other colour', () {
      final state = table(
        columns: [
          [const PlayingCard(_h, 7)],
          [const PlayingCard(_s, 8)],
          [const PlayingCard(_c, 8)],
        ],
      );
      expect(state.move(const Pile.column(0), 1, const Pile.column(1)), isNotNull);
      final black = table(
        columns: [
          [const PlayingCard(_s, 7)],
          [const PlayingCard(_c, 8)],
        ],
      );
      expect(black.move(const Pile.column(0), 1, const Pile.column(1)), isNull);
    });

    test('a cell holds one card', () {
      final state = table(
        columns: [
          [const PlayingCard(_h, 7), const PlayingCard(_s, 6)],
        ],
      );
      final next = state.move(const Pile.column(0), 1, const Pile.cell(2))!;
      expect(next.cells[2], const PlayingCard(_s, 6));
      expect(next.move(const Pile.column(0), 1, const Pile.cell(2)), isNull);
    });

    test('the foundation goes up from the ace, whatever nest is chosen', () {
      final state = table(
        columns: [
          [const PlayingCard(_d, 2), const PlayingCard(_d, 1)],
        ],
      );
      expect(state.move(const Pile.column(0), 1, const Pile.foundation(0))!
          .foundations[_d.index], 1);
      final two = table(
        columns: [
          [const PlayingCard(_d, 2)],
        ],
      );
      expect(two.move(const Pile.column(0), 1, const Pile.foundation(3)), isNull);
    });

    test('a sequence must alternate colours and go down', () {
      final state = table(
        columns: [
          [const PlayingCard(_s, 9), const PlayingCard(_h, 8), const PlayingCard(_c, 7)],
        ],
      );
      expect(state.isRun(0, 3), isTrue);
      final broken = table(
        columns: [
          [const PlayingCard(_s, 9), const PlayingCard(_c, 8)],
        ],
      );
      expect(broken.isRun(0, 2), isFalse);
    });

    test('the free spaces limit how many cards move together', () {
      final full = [
        for (var i = 0; i < 4; i++) const PlayingCard(_c, 2),
      ];
      final filled = [
        for (var i = 2; i < 8; i++) [PlayingCard(_c, 13 - i)],
      ];
      final state = table(
        columns: [
          [const PlayingCard(_s, 9), const PlayingCard(_h, 8)],
          [const PlayingCard(_d, 10)],
          ...filled,
        ],
        cells: full,
      );
      expect(state.maxMovable(toEmptyColumn: false), 1);
      expect(state.move(const Pile.column(0), 2, const Pile.column(1)), isNull);

      final roomy = table(
        columns: [
          [const PlayingCard(_s, 9), const PlayingCard(_h, 8)],
          [const PlayingCard(_d, 10)],
        ],
      );
      // 5 free spots, doubled for each of the 6 empty columns.
      expect(roomy.maxMovable(toEmptyColumn: false), 320);
      expect(roomy.maxMovable(toEmptyColumn: true), 160);
      expect(roomy.move(const Pile.column(0), 2, const Pile.column(1)), isNotNull);
    });

    test('nothing leaves the foundation', () {
      final state = table(foundations: const [3, 0, 0, 0]);
      expect(state.canPick(const Pile.foundation(0), 1), isFalse);
    });
  });

  group('double click', () {
    test('prefers the foundation, then a column, then a cell', () {
      final ace = table(columns: [[const PlayingCard(_h, 1)]]);
      expect(ace.bestDestination(const Pile.column(0), 1),
          Pile.foundation(_h.index));

      final seven = table(
        columns: [
          [const PlayingCard(_h, 7)],
          [const PlayingCard(_s, 8)],
        ],
      );
      expect(seven.bestDestination(const Pile.column(0), 1), const Pile.column(1));

      final lonely = table(columns: [[const PlayingCard(_h, 7)]]);
      expect(lonely.bestDestination(const Pile.column(0), 1), const Pile.cell(0));
    });
  });

  group('collecting on its own', () {
    test('takes aces and twos, and keeps cards that may still be needed', () {
      expect(
        table(columns: [[const PlayingCard(_c, 1)]]).nextSafe(),
        const Pile.column(0),
      );
      expect(
        table(
          columns: [[const PlayingCard(_h, 3)]],
          foundations: [0, 0, 2, 0],
        ).nextSafe(),
        isNull,
      );
      expect(
        table(
          columns: [[const PlayingCard(_h, 3)]],
          foundations: [2, 2, 2, 0],
        ).nextSafe(),
        const Pile.column(0),
      );
    });
  });

  group('controller', () {
    GameController controller() =>
        GameController(number: 5, collectDelay: Duration.zero);

    test('undo brings the table and the count back', () {
      final game = controller();
      final before = game.state;
      final pile = const Pile.column(0);
      final index = game.state.columns[0].length - 1;
      game.sendAway(pile, index);
      expect(game.moves, 1);
      game.undo();
      expect(game.state, same(before));
      expect(game.moves, 0);
      expect(game.canUndo, isFalse);
    });

    test('click on a card and then on a place moves it', () {
      final game = controller();
      final index = game.state.columns[0].length - 1;
      final card = game.state.columns[0].last;
      game.tapCard(const Pile.column(0), index);
      expect(game.selected?.count, 1);
      game.tapEmpty(const Pile.cell(1));
      final moved = game.state.cells[1] == card ||
          game.state.foundations[card.suit.index] >= card.rank;
      expect(moved, isTrue);
      expect(game.selected, isNull);
    });

    test('a refused move makes the cards shake', () {
      final game = controller();
      final tick = game.rejectTick;
      game.state = table(
        columns: [
          [const PlayingCard(_s, 9), const PlayingCard(_c, 8)],
        ],
      );
      game.tapCard(const Pile.column(0), 0);
      expect(game.selected, isNull);
      expect(game.rejectTick, tick + 1);
      expect(game.rejected.length, 2);
    });

    test('the last card wins the game and the rest collects itself', () {
      final game = controller();
      game.state = table(
        columns: [
          [const PlayingCard(_d, 13), const PlayingCard(_h, 13)],
          [const PlayingCard(_s, 13)],
          [const PlayingCard(_c, 13)],
        ],
        foundations: const [12, 12, 12, 12],
      );
      game.sendAway(const Pile.column(1), 0);
      expect(game.state.isWon, isTrue);
    });
  });
}
