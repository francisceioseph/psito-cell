#!/usr/bin/env python3
"""Turns the raw illustrations into the game's assets.

Usage: prepare_art.py <source dir>

The source dir holds figuras/{rei,dama,valete}_{paus,espadas,copas,ouros}.jpeg
and ases/as_<suit>.jpeg. Every card gets the same cream background, so that the
illustrated cards match the number cards drawn in code.
"""
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

CREAM = (246, 238, 214)
WIDTH, HEIGHT = 480, 672
ART_SCALE = 1.0
RANKS = {"rei": "king", "dama": "queen", "valete": "jack", "as": "ace"}
SUITS = {"paus": "clubs", "espadas": "spades", "copas": "hearts", "ouros": "diamonds"}
OUT = Path(__file__).resolve().parent.parent / "assets"


def background(image):
    """The median colour of the four corners."""
    w, h = image.size
    points = [(x, y) for x in (8, w - 9) for y in (8, h - 9)]
    channels = zip(*(image.getpixel(p) for p in points))
    return tuple(sorted(c)[len(points) // 2] for c in channels)


def card(path):
    image = Image.open(path).convert("RGB")
    source = background(image)
    bands = [
        band.point(lambda v: min(255, int(v * target / max(1, base))))
        for band, base, target in zip(image.split(), source, CREAM)
    ]
    art = Image.merge("RGB", bands)
    height = int(HEIGHT * ART_SCALE)
    width = int(height * art.width / art.height)
    art = art.resize((width, height), Image.LANCZOS)
    canvas = Image.new("RGB", (WIDTH, HEIGHT), CREAM)
    # A soft edge hides what is left of the original paper.
    mask = Image.new("L", (width, height), 0)
    ImageDraw.Draw(mask).rectangle((26, 26, width - 27, height - 27), fill=255)
    mask = mask.filter(ImageFilter.GaussianBlur(12))
    canvas.paste(art, ((WIDTH - width) // 2, (HEIGHT - height) // 2), mask)
    return canvas


def mascot(path):
    """Removes the background by flooding it from the corners."""
    rgb = Image.open(path).convert("RGB")
    key = (255, 0, 255)
    flooded = rgb.copy()
    w, h = rgb.size
    for corner in [(2, 2), (w - 3, 2), (2, h - 3), (w - 3, h - 3)]:
        ImageDraw.floodfill(flooded, corner, key, thresh=38)
    alpha = Image.new("L", rgb.size, 255)
    alpha.putdata([0 if p == key else 255 for p in flooded.getdata()])
    alpha = alpha.filter(ImageFilter.GaussianBlur(0.9))
    rgb.putalpha(alpha)
    rgb = rgb.crop(alpha.point(lambda v: 255 if v > 16 else 0).getbbox())
    ratio = 420 / rgb.height
    return rgb.resize((int(rgb.width * ratio), 420), Image.LANCZOS)


def main(source):
    (OUT / "cards").mkdir(parents=True, exist_ok=True)
    (OUT / "mascot").mkdir(parents=True, exist_ok=True)
    for rank in ("rei", "dama", "valete", "as"):
        folder = "ases" if rank == "as" else "figuras"
        for suit in SUITS:
            path = source / folder / f"{rank}_{suit}.jpeg"
            if not path.exists():
                print(f"missing: {path.name}")
                continue
            target = OUT / "cards" / f"{RANKS[rank]}_{SUITS[suit]}.jpg"
            card(path).save(target, quality=88, optimize=True)
    mascot(source / "ases" / "as_paus.jpeg").save(
        OUT / "mascot" / "peek.png", optimize=True
    )


if __name__ == "__main__":
    main(Path(sys.argv[1]))
