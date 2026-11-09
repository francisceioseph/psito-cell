import 'dart:math';

import 'package:flutter/material.dart';

import '../game/game_state.dart';

abstract final class PsitoColors {
  static const felt = Color(0xFF426854);
  static const feltDark = Color(0xFF34543F);
  static const feltLight = Color(0xFF6F9480);
  static const cream = Color(0xFFF6EED6);
  static const red = Color(0xFFB2261E);
  static const black = Color(0xFF26262C);
  static const edge = Color(0xFF78694F);
  static const accent = Color(0xFFFFC107);
  static const onFelt = Color(0xFFF3EFE0);
}

/// The suits are drawn as shapes so that they look the same on every system,
/// whatever fonts it has.
abstract final class SuitShape {
  static final Path _heart = Path()
    ..moveTo(.5, .96)
    ..cubicTo(.15, .66, 0, .46, 0, .28)
    ..cubicTo(0, .12, .13, 0, .28, 0)
    ..cubicTo(.38, 0, .46, .05, .5, .15)
    ..cubicTo(.54, .05, .62, 0, .72, 0)
    ..cubicTo(.87, 0, 1, .12, 1, .28)
    ..cubicTo(1, .46, .85, .66, .5, .96)
    ..close();

  static final Path _diamond = Path()
    ..moveTo(.5, 0)
    ..quadraticBezierTo(.68, .28, .9, .5)
    ..quadraticBezierTo(.68, .72, .5, 1)
    ..quadraticBezierTo(.32, .72, .1, .5)
    ..quadraticBezierTo(.32, .28, .5, 0)
    ..close();

  static final Path _stem = Path()
    ..moveTo(.46, .55)
    ..quadraticBezierTo(.44, .86, .3, 1)
    ..lineTo(.7, 1)
    ..quadraticBezierTo(.56, .86, .54, .55)
    ..close();

  static final Path _spade = Path()
    ..addPath(
      _heart,
      Offset.zero,
      matrix4: (Matrix4.identity()
            ..translateByDouble(0, .8, 0, 1)
            ..scaleByDouble(1, -.8, 1, 1))
          .storage,
    )
    ..addPath(_stem, Offset.zero);

  static final Path _club = Path()
    ..addOval(Rect.fromCircle(center: const Offset(.5, .25), radius: .24))
    ..addOval(Rect.fromCircle(center: const Offset(.24, .56), radius: .24))
    ..addOval(Rect.fromCircle(center: const Offset(.76, .56), radius: .24))
    ..addOval(Rect.fromCircle(center: const Offset(.5, .46), radius: .14))
    ..addPath(_stem, Offset.zero);

  static void draw(Canvas canvas, Suit suit, Rect rect, Color color) {
    final path = switch (suit) {
      Suit.clubs => _club,
      Suit.spades => _spade,
      Suit.hearts => _heart,
      Suit.diamonds => _diamond,
    };
    canvas.save();
    canvas.translate(rect.left, rect.top);
    canvas.scale(rect.width, rect.height);
    canvas.drawPath(path, Paint()..color = color);
    canvas.restore();
  }
}

String rankLabel(int rank) => switch (rank) {
  1 => 'A',
  11 => 'J',
  12 => 'Q',
  13 => 'K',
  _ => '$rank',
};

const _rankNames = {1: 'ace', 11: 'jack', 12: 'queen', 13: 'king'};
const _illustratedAces = {Suit.clubs, Suit.spades};

/// The illustration of a card, or null for the ones drawn only in code.
String? cardArt(PlayingCard card) {
  final name = _rankNames[card.rank];
  if (name == null) return null;
  if (card.rank == 1 && !_illustratedAces.contains(card.suit)) return null;
  return 'assets/cards/${name}_${card.suit.name}.jpg';
}

Iterable<String> allCardArt() sync* {
  for (final suit in Suit.values) {
    for (final rank in const [1, 11, 12, 13]) {
      final path = cardArt(PlayingCard(suit, rank));
      if (path != null) yield path;
    }
  }
}

class CardFace extends StatelessWidget {
  const CardFace({super.key, required this.card, this.selected = false});

  final PlayingCard card;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final art = cardArt(card);
    return LayoutBuilder(
      builder: (context, box) {
        final radius = BorderRadius.circular(box.maxWidth * .07);
        return DecoratedBox(
          decoration: BoxDecoration(
            color: PsitoColors.cream,
            borderRadius: radius,
            boxShadow: const [
              BoxShadow(
                color: Color(0x55000000),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (art != null)
                  Image.asset(
                    art,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                    gaplessPlayback: true,
                  ),
                CustomPaint(painter: _FacePainter(card, art == null)),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    border: Border.all(
                      color: selected ? PsitoColors.accent : PsitoColors.edge,
                      width: selected ? 3 : 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

const _pips = <int, List<Offset>>{
  2: [Offset(.5, .27), Offset(.5, .73)],
  3: [Offset(.5, .27), Offset(.5, .5), Offset(.5, .73)],
  4: [Offset(.3, .27), Offset(.7, .27), Offset(.3, .73), Offset(.7, .73)],
  5: [
    Offset(.3, .27), Offset(.7, .27), Offset(.5, .5),
    Offset(.3, .73), Offset(.7, .73),
  ],
  6: [
    Offset(.3, .27), Offset(.7, .27), Offset(.3, .5),
    Offset(.7, .5), Offset(.3, .73), Offset(.7, .73),
  ],
  7: [
    Offset(.3, .27), Offset(.7, .27), Offset(.5, .385), Offset(.3, .5),
    Offset(.7, .5), Offset(.3, .73), Offset(.7, .73),
  ],
  8: [
    Offset(.3, .27), Offset(.7, .27), Offset(.5, .385), Offset(.3, .5),
    Offset(.7, .5), Offset(.5, .615), Offset(.3, .73), Offset(.7, .73),
  ],
  9: [
    Offset(.3, .27), Offset(.7, .27), Offset(.3, .43), Offset(.7, .43),
    Offset(.5, .5), Offset(.3, .57), Offset(.7, .57),
    Offset(.3, .73), Offset(.7, .73),
  ],
  10: [
    Offset(.3, .27), Offset(.7, .27), Offset(.5, .35), Offset(.3, .43),
    Offset(.7, .43), Offset(.3, .57), Offset(.7, .57), Offset(.5, .65),
    Offset(.3, .73), Offset(.7, .73),
  ],
};

class _FacePainter extends CustomPainter {
  const _FacePainter(this.card, this.drawCenter);

  final PlayingCard card;
  final bool drawCenter;

  Color get _color => card.suit.isRed ? PsitoColors.red : PsitoColors.black;

  void _index(Canvas canvas, Size size) {
    final text = TextPainter(
      text: TextSpan(
        text: rankLabel(card.rank),
        style: TextStyle(
          color: _color,
          fontSize: size.width * .16,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final x = size.width * .07;
    final y = size.width * .07;
    text.paint(canvas, Offset(x, y));
    final side = size.width * .135;
    SuitShape.draw(
      canvas,
      card.suit,
      Rect.fromLTWH(
        x + text.width + size.width * .02,
        y + (text.height - side) / 2,
        side,
        side,
      ),
      _color,
    );
  }

  void _pip(Canvas canvas, Size size, Offset at, double side) {
    final center = Offset(at.dx * size.width, at.dy * size.height);
    final flip = at.dy > .5;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    if (flip) canvas.rotate(pi);
    SuitShape.draw(
      canvas,
      card.suit,
      Rect.fromCenter(center: Offset.zero, width: side, height: side),
      _color,
    );
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (drawCenter) {
      if (card.rank == 1) {
        _pip(canvas, size, const Offset(.5, .5), size.width * .5);
      } else {
        for (final at in _pips[card.rank]!) {
          _pip(canvas, size, at, size.width * (card.rank >= 9 ? .15 : .19));
        }
      }
    }
    _index(canvas, size);
    canvas.save();
    canvas.translate(size.width, size.height);
    canvas.rotate(pi);
    _index(canvas, size);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_FacePainter old) =>
      old.card != card || old.drawCenter != drawCenter;
}

/// An empty place on the table: a perch for the free cells, a nest for the
/// foundations. Simple drawings until the illustrated ones arrive.
class SlotView extends StatelessWidget {
  const SlotView.perch({super.key}) : suit = null;
  const SlotView.nest(Suit this.suit, {super.key});

  final Suit? suit;

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _SlotPainter(suit));
}

class _SlotPainter extends CustomPainter {
  const _SlotPainter(this.suit);

  final Suit? suit;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final shape = RRect.fromRectAndRadius(
      rect.deflate(1),
      Radius.circular(size.width * .07),
    );
    canvas.drawRRect(shape, Paint()..color = PsitoColors.feltDark);
    final line = Paint()
      ..color = PsitoColors.feltLight
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = max(1.5, size.width * .025);
    canvas.drawRRect(shape, line);

    final w = size.width;
    final h = size.height;
    if (suit case final suit?) {
      for (var i = 0; i < 3; i++) {
        final y = h * (.66 + i * .05);
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(w / 2, y - h * .08),
            width: w * (.72 - i * .08),
            height: h * .26,
          ),
          .15,
          pi - .3,
          false,
          line,
        );
      }
      final side = w * .36;
      SuitShape.draw(
        canvas,
        suit,
        Rect.fromCenter(center: Offset(w / 2, h * .36), width: side, height: side),
        PsitoColors.feltLight,
      );
    } else {
      final branch = Path()
        ..moveTo(w * .16, h * .56)
        ..quadraticBezierTo(w * .5, h * .46, w * .84, h * .52);
      canvas.drawPath(branch, line);
      final twig = Path()
        ..moveTo(w * .64, h * .5)
        ..quadraticBezierTo(w * .7, h * .42, w * .78, h * .38);
      canvas.drawPath(twig, line);
    }
  }

  @override
  bool shouldRepaint(_SlotPainter old) => old.suit != suit;
}
