from solid2 import *
from lib.scad import save_scad
from solid2.extensions.bosl2 import rounding

border_radius = 1
top_radius = 2
faces = 8
d1 = 20
d2 = 30
h1 = 6
h2 = 3
h3 = 15


def flat_hectagon(d):
    return (
        circle(d=d, _fn=faces)
        .rotateZ(22.5)
        .offset(r=-border_radius)
        .offset(r=border_radius)
    )


def hectagon(d, h):
    return flat_hectagon(d).linear_extrude(h)


def rounded_hectagon(d, h, r=border_radius):
    return minkowski()(hectagon(d - r * 2, h), sphere(r=r))


diamond = hull()(
    hectagon(d1, h1),
    rounded_hectagon(d2, h2).up(h1),
    sphere(r=top_radius).up(h1 + h2 + h3),
)

# Example 1: Convenience methods
obj1 = cube(10, 10, 10).up(20)
obj2 = cube(10, 10, 10).rotateZ(20)

# Example 2: Union/Diff
obj1 = square(10, 20) + square(5, 30)
obj2 = square(10, 20) - square(5, 30)


save_scad(diamond)
