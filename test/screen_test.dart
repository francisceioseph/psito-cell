import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psito_games_ui/psito_games_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:psito_cell/l10n/app_localizations.dart';
import 'package:psito_cell/src/game/game_controller.dart';
import 'package:psito_cell/src/game/game_state.dart';
import 'package:psito_cell/src/game/scores.dart';
import 'package:psito_cell/src/ui/organisms/board.dart';
import 'package:psito_cell/src/ui/atoms/card_face.dart';
import 'package:psito_cell/src/ui/pages/game_screen.dart';

Future<void> pumpGame(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    const MaterialApp(
      locale: Locale('pt'),
      localizationsDelegates: [
        ...AppLocalizations.localizationsDelegates,
        GamesUiLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: GameScreen(number: 3),
    ),
  );
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> finish(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump();
}

/// A board with a red 7 in the first column and a black 8 in the second.
Future<GameController> pumpBoard(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1280, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final game = GameController(number: 1, collectDelay: Duration.zero);
  addTearDown(game.dispose);
  game.state = GameState(
    columns: [
      [const PlayingCard(Suit.hearts, 7)],
      [const PlayingCard(Suit.spades, 8)],
      for (var i = 2; i < 8; i++) <PlayingCard>[],
    ],
    cells: const [null, null, null, null],
    foundations: const [0, 0, 0, 0],
  );
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('pt'),
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        GamesUiLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Board(game: game)),
    ),
  );
  await tester.pump();
  return game;
}

Finder faceOf(int rank) => find.byWidgetPredicate(
  (widget) => widget is CardFace && widget.card.rank == rank,
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('the winner saves a name and sees the best games', (tester) async {
    final game = await pumpBoard(tester);
    game.state = const GameState(
      columns: [
        [PlayingCard(Suit.diamonds, 13), PlayingCard(Suit.hearts, 13)],
        [PlayingCard(Suit.spades, 13)],
        [PlayingCard(Suit.clubs, 13)],
        [], [], [], [], [],
      ],
      cells: [null, null, null, null],
      foundations: [12, 12, 12, 12],
    );
    game.sendAway(const Pile.column(1), 0);
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(game.state.isWon, isTrue);
    expect(find.text('Você venceu!'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Ana');
    await tester.pump();
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle(const Duration(milliseconds: 100), EnginePhase.sendSemanticsUpdate, const Duration(seconds: 12));

    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Melhores partidas'), findsOneWidget);
    final saved = await const ScoreStore().load();
    expect(saved.single.name, 'Ana');
    expect(saved.single.moves, 1);
    expect(await const ScoreStore().lastName(), 'Ana');
    await finish(tester);
  });

  testWidgets('the victory panel fits a small window', (tester) async {
    final game = await pumpBoard(tester);
    tester.view.physicalSize = const Size(480, 300);
    game.state = const GameState(
      columns: [
        [PlayingCard(Suit.diamonds, 13), PlayingCard(Suit.hearts, 13)],
        [PlayingCard(Suit.spades, 13)],
        [PlayingCard(Suit.clubs, 13)],
        [], [], [], [], [],
      ],
      cells: [null, null, null, null],
      foundations: [12, 12, 12, 12],
    );
    game.sendAway(const Pile.column(1), 0);
    await tester.pump(const Duration(seconds: 2));
    expect(tester.takeException(), isNull);
    await finish(tester);
  });

  testWidgets('the menu starts a game by its number', (tester) async {
    await pumpGame(tester, const Size(1280, 800));
    await tester.tap(find.byIcon(Icons.more_vert_rounded));
    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    await tester.tap(find.text('Escolher número do jogo'));
    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    await tester.enterText(find.byType(TextField), '42');
    await tester.pump();
    await tester.tap(find.text('Jogar'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('42'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('the bar shows the new game button in wide windows', (tester) async {
    await pumpGame(tester, const Size(1280, 800));
    expect(find.text('Novo jogo'), findsOneWidget);
    await finish(tester);
    await pumpGame(tester, const Size(700, 500));
    expect(find.text('Novo jogo'), findsNothing);
    expect(tester.takeException(), isNull);
    await finish(tester);
  });

  testWidgets('dragging a card drops it on a column', (tester) async {
    final game = await pumpBoard(tester);
    final from = tester.getCenter(faceOf(7));
    final to = tester.getCenter(faceOf(8));
    await tester.dragFrom(from, to - from + const Offset(0, 40));
    await tester.pump(const Duration(milliseconds: 300));
    expect(game.state.columns[1].length, 2);
    expect(game.state.columns[0], isEmpty);
    expect(game.moves, 1);
    await finish(tester);
  });

  testWidgets('a drop that the rules refuse keeps the card', (tester) async {
    final game = await pumpBoard(tester);
    final from = tester.getCenter(faceOf(8));
    final to = tester.getCenter(faceOf(7));
    final tick = game.rejectTick;
    await tester.dragFrom(from, to - from);
    await tester.pump(const Duration(milliseconds: 400));
    expect(game.state.columns[1].length, 1);
    expect(game.rejectTick, tick + 1);
    await finish(tester);
  });

  testWidgets('a double click sends the card away', (tester) async {
    final game = await pumpBoard(tester);
    await tester.tap(faceOf(7));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(faceOf(7));
    await tester.pump(const Duration(milliseconds: 300));
    expect(game.state.columns[1].length, 2);
    await finish(tester);
  });

  testWidgets('shows the table and counts a move', (tester) async {
    await pumpGame(tester, const Size(1280, 800));
    expect(find.text('Psito Cell'), findsOneWidget);
    expect(find.text('JOGADAS'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.casino_outlined));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('3'), findsNothing);
    await finish(tester);
  });

  testWidgets('fits small and large windows without overflowing', (tester) async {
    for (final size in const [Size(480, 360), Size(1920, 1080), Size(800, 1200)]) {
      await pumpGame(tester, size);
      expect(tester.takeException(), isNull);
    }
    await finish(tester);
  });
}
