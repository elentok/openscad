from solid2 import *


def chamfered_hole(height, hole_diameter, chamfer_diameter):
    chamfer_height = (chamfer_diameter - hole_diameter) / 2
    cylinder_height = height - chamfer_height

    # Add 0.1 to make sure the union with the chamfer is perfect
    return union()(
        cylinder(h=cylinder_height + 0.1, d=hole_diameter),
        cylinder(h=chamfer_height, d1=hole_diameter, d2=chamfer_diameter).up(
            cylinder_height
        ),
    ).down(height / 2)
