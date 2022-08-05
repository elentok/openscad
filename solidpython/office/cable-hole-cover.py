from solid import *


def cable_hole_cover():
    return cylinder(d=10, h=8)


cable_hole_cover().save_as_scad()
