from solid import *

from lib.chamfer import chamfered_hole

# Settings for a 92mm fan
distance_between_holes = 82.5
screw_hole_diameter = 4.4
chamfer_diameter = 9
padding = 3
grip_diameter = screw_hole_diameter + padding * 2
width = 16.3
hole_distance = (distance_between_holes - grip_diameter / 2) / 2 * 0.75


def fan_holder():
    hole = back(grip_diameter / 2 - padding / 2)(
        rotateX(-90)(
            chamfered_hole(padding + 0.2, screw_hole_diameter, chamfer_diameter)
        )
    )
    return (
        linear_extrude(width, center=True)(flat_fan_holder())
        - left(hole_distance)(hole)
        - right(hole_distance)(hole)
    )


def flat_fan_holder():
    return (
        left(distance_between_holes / 2)(grip())
        + right(distance_between_holes / 2)(grip())
        + back(grip_diameter / 2 - padding / 2)(
            square([distance_between_holes, padding], center=True)
        )
    )


def grip():
    return hull()(
        back(grip_diameter / 2 - padding / 2)(
            square(size=[grip_diameter, padding], center=True)
        )
        + circle(d=grip_diameter)
    ) - circle(d=screw_hole_diameter)


scad_render_to_file(fan_holder(), file_header=f"$fn = 50;")
