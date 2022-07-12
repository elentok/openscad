from solid import *

# from solid.extensions.bosl2 import *

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
    return (
        flat_fan_holder().linear_extrude(width, center=True)
        - hole().left(hole_distance)
        - hole().right(hole_distance)
    )


def hole():
    return (
        chamfered_hole(padding + 0.2, screw_hole_diameter, chamfer_diameter)
        .rotateX(-90)
        .back(grip_diameter / 2 - padding / 2)
    )


def flat_fan_holder():
    return (
        grip().left(distance_between_holes / 2)
        + grip().right(distance_between_holes / 2)
        + square([distance_between_holes, padding], center=True).back(
            grip_diameter / 2 - padding / 2
        )
    )


def grip():
    return hull()(
        square(size=[grip_diameter, padding], center=True).back(
            grip_diameter / 2 - padding / 2
        )
        + circle(d=grip_diameter)
    ) - circle(d=screw_hole_diameter)


scad_render_to_file(fan_holder(), file_header=f"$fn = 50;")
