from solid import circle, square, difference, debug
from .types import Side


def half_circle(d: float, side: Side):
    if side == Side.TOP:
        mask = square([d + 0.2, d / 2 + 0.2], center=True).back(d / 4 + 0.1)
    elif side == Side.BOTTOM:
        mask = square([d + 0.2, d / 2 + 0.2], center=True).forward(d / 4 + 0.1)
    elif side == Side.LEFT:
        mask = square([d / 2 + 0.2, d + 0.2], center=True).right(d / 4 + 0.1)
    else:  # right
        mask = square([d / 2 + 0.2, d + 0.2], center=True).left(d / 4 + 0.1)

    return difference()(circle(d=d), mask)
