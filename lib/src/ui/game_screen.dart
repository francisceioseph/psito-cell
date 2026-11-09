import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';
import '../game/game_controller.dart';
import 'board.dart';
import 'card_face.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, this.number});

  /// A fixed game number. Without one, the deal is random.
  final int? number;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const _idle = Duration(seconds: 45);
  static const _peekTime = Duration(milliseconds: 3200);

  late final GameController _game = GameController(number: widget.number);
  Timer? _timer;
  bool _peeking = false;
  bool _precached = false;

  @override
  void initState() {
    super.initState();
    _waitIdle();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precached) return;
    _precached = true;
    for (final path in allCardArt()) {
      precacheImage(AssetImage(path), context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _game.dispose();
    super.dispose();
  }

  void _waitIdle() {
    _timer?.cancel();
    _timer = Timer(_idle, _peek);
  }

  void _peek() {
    setState(() => _peeking = true);
    _timer = Timer(_peekTime, () {
      setState(() => _peeking = false);
      _waitIdle();
    });
  }

  void _activity() {
    if (_peeking) setState(() => _peeking = false);
    _waitIdle();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: PsitoColors.felt,
      body: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyZ, control: true):
              _game.undo,
          const SingleActivator(LogicalKeyboardKey.keyN, control: true):
              _game.newGame,
          const SingleActivator(LogicalKeyboardKey.keyR, control: true):
              _game.restart,
        },
        child: Focus(
          autofocus: true,
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => _activity(),
            child: Column(
              children: [
                ListenableBuilder(
                  listenable: _game,
                  builder: (context, _) => _Toolbar(game: _game, l10n: l10n),
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Board(game: _game),
                      _Peek(visible: _peeking),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.game, required this.l10n});

  final GameController game;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    const light = TextStyle(color: PsitoColors.onFelt);
    return ColoredBox(
      color: PsitoColors.feltDark,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            Flexible(
              child: Text(
                l10n.appTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: light.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                l10n.gameNumber(game.number),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: light,
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                l10n.moves(game.moves),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: light,
              ),
            ),
            const Spacer(),
            IconButton(
              tooltip: l10n.undo,
              color: PsitoColors.onFelt,
              disabledColor: PsitoColors.feltLight,
              onPressed: game.canUndo ? game.undo : null,
              icon: const Icon(Icons.undo),
            ),
            IconButton(
              tooltip: l10n.restart,
              color: PsitoColors.onFelt,
              onPressed: game.restart,
              icon: const Icon(Icons.replay),
            ),
            IconButton(
              tooltip: l10n.newGame,
              color: PsitoColors.onFelt,
              onPressed: game.newGame,
              icon: const Icon(Icons.casino_outlined),
            ),
          ],
        ),
      ),
    );
  }
}

/// A cockatiel that peeks from the corner when nothing happens for a while.
class _Peek extends StatelessWidget {
  const _Peek({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) => Positioned(
    right: 24,
    bottom: 0,
    height: 190,
    child: IgnorePointer(
      child: ExcludeSemantics(
        child: ClipRect(
          child: AnimatedSlide(
            offset: visible ? const Offset(0, .12) : const Offset(0, 1.1),
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOutBack,
            child: Transform.rotate(
              angle: -.16,
              child: Image.asset('assets/mascot/peek.png'),
            ),
          ),
        ),
      ),
    ),
  );
}
