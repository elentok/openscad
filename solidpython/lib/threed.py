from solid import sphere, cube, difference
from .types import Side


def half_sphere(d: float, side: Side):
    if side == Side.TOP:
        mask = cube([d + 0.2, d / 2 + 0.2, d + 0.2], center=True).down(d / 2 + 0.1)
    elif side == Side.BOTTOM:
        mask = cube([d + 0.2, d / 2 + 0.1, d + 0.2], center=True).up(d / 2 + 0.1)
    elif side == Side.LEFT:
        mask = cube([d / 2 + 0.1, d + 0.2, d + 0.2], center=True).left(d / 2 + 0.1)
    else:  # right
        mask = cube([d / 2 + 0.1, d + 0.2, d + 0.2], center=True).right(d / 2 + 0.1)

    return difference()(sphere(d=d), mask)
