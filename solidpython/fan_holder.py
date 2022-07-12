from solid import *

# from solid.extensions.bosl2 import *

from lib.chamfer import chamfered_hole

# Settings for a 92mm fan
fan_hole_distance = 82.5
fan_screw_hole_diameter = 4.4
chamfer_diameter = 9
plate_thickness = 2
padding = 3.1
grip_padding = 2
grip_diameter = fan_screw_hole_diameter + grip_padding * 2
width = 16.3
wall_hole_distance = (fan_hole_distance - grip_diameter / 2) / 2 * 0.75


def fan_holder():
    return (
        flat_fan_holder()
        .linear_extrude(width, center=True)
        .forward(fan_screw_hole_diameter / 2 + padding * 2)
        - hole().left(wall_hole_distance)
        - hole().right(wall_hole_distance)
    )


def hole():
    return (
        chamfered_hole(padding + 0.2, fan_screw_hole_diameter, chamfer_diameter)
        .rotateX(-90)
        .forward(padding / 2)
    )


def flat_fan_holder():
    return (
        grip().left(fan_hole_distance / 2)
        + grip().right(fan_hole_distance / 2)
        + square([fan_hole_distance + grip_diameter, padding], center=True).back(
            padding * 1.5 + fan_screw_hole_diameter / 2
        )
    )


def grip():
    return hull()(
        debug()(
            square(size=[grip_diameter, padding], center=True).back(
                padding / 2 + fan_screw_hole_diameter / 2
            )
        )
        + circle(d=grip_diameter)
    ) - circle(d=fan_screw_hole_diameter)


scad_render_to_file(fan_holder(), file_header=f"$fn = 50;")
