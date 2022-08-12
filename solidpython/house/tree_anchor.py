from solid import *
from lib.scad import save_scad
from lib.arc import arc

tree_diameter = 20
opening_height = 30
hole_diameter = 5
thickness = 5
anchor_height = 40

anchor_outer_diameter = tree_diameter * 2 + thickness * 2
anchor_inner_diameter = tree_diameter * 2

tree_anchor = (
    difference()(
        circle(d=anchor_outer_diameter),
        circle(d=anchor_inner_diameter),
        square([anchor_outer_diameter / 2, opening_height], center=True).right(
            anchor_outer_diameter / 4
        ),
    )
    .offset(r=-2)
    .offset(r=2)
    .linear_extrude(anchor_height, center=True)
)

hole = cylinder(d=5, h=anchor_outer_diameter * 1.2).rotateY(90)


tree_anchor = difference()(
    tree_anchor,
    hole.rotateZ(65).up(anchor_height / 4),
    hole.rotateZ(-65).up(anchor_height / 4),
    hole.rotateZ(65).down(anchor_height / 4),
    hole.rotateZ(-65).down(anchor_height / 4),
)

save_scad(tree_anchor)
