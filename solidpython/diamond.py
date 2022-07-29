from solid import *
from lib.render import render
from solid.extensions.bosl2 import rounding

border_radius = 1
faces = 8
d1 = 10
d2 = 20
h1 = 5
h2 = 3
h3 = 20


def flat_hectagon(d):
    return (
        circle(d=d, _fn=faces)
        .rotateZ(22.5)
        .offset(r=-border_radius)
        .offset(r=border_radius)
    )


def hectagon(d, h):
    return flat_hectagon(d).linear_extrude(h)


diamond = hull()(
    hectagon(d1, h1),
    hectagon(d2, h2).up(h1),
    sphere(r=border_radius).up(h1 + h2 + h3),
)

render(diamond)
