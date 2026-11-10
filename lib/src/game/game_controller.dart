import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:psito_games_ui/psito_games_ui.dart';

import 'game_state.dart';

/// What the player is holding after a click.
@immutable
class Selection {
  const Selection(this.pile, this.count);

  final Pile pile;
  final int count;
}

/// A game in progress: the table, the selection and the undo history.
class GameController extends ChangeNotifier {
  GameController({
    int? number,
    this.collectDelay = const Duration(milliseconds: 130),
    SoundBoard? sounds,
  }) : number = number ?? _randomNumber(),
       state = GameState.deal(number ?? 1),
       sounds = sounds ?? GameSounds.shared {
    state = GameState.deal(this.number);
  }

  static int _randomNumber() => Random().nextInt(999999) + 1;

  /// The pause between cards collected on their own. Zero collects at once.
  final Duration collectDelay;

  /// Where the sounds of the table go.
  final SoundBoard sounds;

  /// When a moved card reaches its place, a little before the end of its
  /// flight.
  static const landing = Duration(milliseconds: 240);

  int number;
  GameState state;
  int moves = 0;
  Selection? selected;

  /// The cards of the latest move, drawn above the others while they travel.
  Set<int> lastMoved = const {};

  /// The cards of the latest refused move. [rejectTick] tells them to shake.
  Set<int> rejected = const {};
  int rejectTick = 0;

  final List<GameState> _history = [];
  final List<int> _movesHistory = [];
  final Stopwatch _clock = Stopwatch();
  Timer? _collectTimer;

  bool get canUndo => _history.isNotEmpty;

  /// The time played, from the first move until the win.
  int get seconds => _clock.elapsed.inSeconds;

  /// Lands the cards of a move from [before], and ends the game when it is
  /// won.
  void _landed(GameState before) {
    sounds.play(GameSound.place, delay: landing);
    if (state.isWon && !before.isWon) {
      _clock.stop();
      sounds.play(GameSound.victory, delay: landing * 2);
    }
  }

  void newGame([int? number]) {
    this.number = number ?? _randomNumber();
    _restart();
  }

  void restart() => _restart();

  void _restart() {
    _collectTimer?.cancel();
    _clock
      ..stop()
      ..reset();
    state = GameState.deal(number);
    moves = 0;
    selected = null;
    lastMoved = const {};
    rejected = const {};
    _history.clear();
    _movesHistory.clear();
    sounds.play(GameSound.shuffle);
    notifyListeners();
  }

  void undo() {
    if (_history.isEmpty) return;
    _collectTimer?.cancel();
    state = _history.removeLast();
    moves = _movesHistory.removeLast();
    selected = null;
    lastMoved = const {};
    sounds.play(GameSound.place);
    notifyListeners();
  }

  void clearSelection() {
    if (selected == null) return;
    selected = null;
    notifyListeners();
  }

  List<PlayingCard> _cards(Pile pile, int count) => switch (pile.kind) {
    PileKind.column => state.columns[pile.index].sublist(
      state.columns[pile.index].length - count,
    ),
    PileKind.cell => [state.cells[pile.index]!],
    PileKind.foundation => const [],
  };

  void _reject(Iterable<PlayingCard> cards) {
    sounds.play(GameSound.refuse);
    rejected = {for (final card in cards) card.id};
    rejectTick++;
    selected = null;
    notifyListeners();
  }

  /// Refuses a pick up: the cards from [index] down are not a sequence.
  void rejectPick(Pile pile, int index) {
    if (pile.kind != PileKind.column) return;
    _reject(state.columns[pile.index].sublist(index));
  }

  /// Moves the cards, or makes them shake if the rules do not allow it.
  bool moveCards(Pile from, int count, Pile to) {
    final next = state.move(from, count, to);
    if (next == null) {
      if (state.canPick(from, count)) _reject(_cards(from, count));
      return false;
    }
    final moved = {for (final card in _cards(from, count)) card.id};
    _history.add(state);
    _movesHistory.add(moves);
    final before = state;
    state = next;
    moves++;
    selected = null;
    lastMoved = moved;
    rejected = const {};
    _clock.start();
    _landed(before);
    notifyListeners();
    _collect();
    return true;
  }

  /// A click on the card at [index] of [pile].
  void tapCard(Pile pile, int index) {
    final held = selected;
    if (held != null) {
      if (held.pile == pile) {
        clearSelection();
      } else {
        moveCards(held.pile, held.count, pile);
      }
      return;
    }
    if (pile.kind == PileKind.foundation) return;
    final count = pile.kind == PileKind.column
        ? state.columns[pile.index].length - index
        : 1;
    if (!state.canPick(pile, count)) {
      rejectPick(pile, index);
      return;
    }
    selected = Selection(pile, count);
    notifyListeners();
  }

  /// A click on an empty place.
  void tapEmpty(Pile pile) {
    final held = selected;
    if (held != null) moveCards(held.pile, held.count, pile);
  }

  /// A double click: sends the cards to the best place there is.
  void sendAway(Pile pile, int index) {
    selected = null;
    final count = pile.kind == PileKind.column
        ? state.columns[pile.index].length - index
        : 1;
    final target = state.bestDestination(pile, count);
    if (target == null) {
      if (pile.kind == PileKind.column) {
        rejectPick(pile, index);
      } else if (state.cells[pile.index] case final card?) {
        _reject([card]);
      }
      return;
    }
    moveCards(pile, count, target);
  }

  void _collect() {
    _collectTimer?.cancel();
    if (collectDelay == Duration.zero) {
      while (_collectOne()) {}
      return;
    }
    if (state.nextSafe() == null) return;
    _collectTimer = Timer(collectDelay, () {
      if (_collectOne()) _collect();
    });
  }

  bool _collectOne() {
    final from = state.nextSafe();
    if (from == null) return false;
    final card = _cards(from, 1).single;
    final before = state;
    state = state.move(from, 1, Pile.foundation(card.suit.index))!;
    lastMoved = {card.id};
    _landed(before);
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    _collectTimer?.cancel();
    super.dispose();
  }
}
