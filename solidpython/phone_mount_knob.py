from solid import *
from lib.render import render

d1 = 12
d2 = 8.9
d3 = 15

h1 = 2.2
h1to2 = 1
h2 = 3
h3 = 1.7

handle_height = 8
handle_d1 = d3
handle_d2 = d3 * 0.3
handle_width = 25

hexagon_diameter = 5.55
hexagon_height = 7.8
screw_tight_hole_dist = 4.5
screw_tight_hole_diameter = 1.75

handle = hull()(
    circle(d=handle_d1),
    circle(d=handle_d2).left(handle_width / 2),
    circle(d=handle_d2).right(handle_width / 2),
).linear_extrude(handle_height)

rounded_handle = minkowski()(handle, sphere(d=2))

bottom = union()(
    cylinder(d=d1, h=h1),
    cylinder(d1=d1, d2=d2, h=h1to2).up(h1),
    cylinder(d=d2, h=h2).up(h1 + h1to2),
    cylinder(d=d3, h=h3).up(h1 + h1to2 + h2),
)

hexagon = cylinder(d=hexagon_diameter, h=hexagon_height + 0.1, _fn=6).down(0.1)
tight_hole = cylinder(d=screw_tight_hole_diameter, h=d2 + 0.2, center=True).rotateX(90)

knob = (
    bottom
    + rounded_handle.up(h1 + h1to2 + h2 + h3)
    - hexagon
    - tight_hole.up(screw_tight_hole_dist)
)

render(knob)
