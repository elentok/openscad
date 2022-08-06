from solid import circle, square, intersection
from .types import Side


def _mask(d: float, side: Side):
    if side == Side.TOP:
        return square([d + 0.2, d / 2 + 0.2], center=True).forward(d / 4 + 0.1)
    elif side == Side.BOTTOM:
        return square([d + 0.2, d / 2 + 0.2], center=True).back(d / 4 + 0.1)
    elif side == Side.LEFT:
        return square([d / 2 + 0.2, d + 0.2], center=True).left(d / 4 + 0.1)
    else:  # right
        return square([d / 2 + 0.2, d + 0.2], center=True).right(d / 4 + 0.1)


def half_circle(d: float, side: Side):
    return intersection()(circle(d=d), _mask(d, side))


def quarter_circle(d: float, side1: Side, side2: Side):
    return intersection()(circle(d=d), _mask(d, side1), _mask(d, side2))
