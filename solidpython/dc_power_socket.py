from solid import *
from lib.render import render

from jar import Jar

height = 30
diameter = 25
wall_width = 1.7

hole_diameter = 11.6
hole_width = 10.8


def dc_power_socket_jar_body():
    jar_body = Jar(diameter, height, wall_width).render_body()
    hole = (
        intersection()(
            circle(d=hole_diameter), square([hole_width, hole_diameter], center=True)
        )
        .linear_extrude(wall_width + 0.2)
        .down(0.1)
    )
    return jar_body - hole
    # return hole


def dc_power_socket_jar_lid():
    jar_lid = Jar(diameter, height, wall_width).render_lid()
    hole = (
        intersection()(
            circle(d=hole_diameter), square([hole_width, hole_diameter], center=True)
        )
        .linear_extrude(wall_width + 0.2)
        .down(0.1)
    )
    return jar_lid - hole
    # return hole


def both():
    # jar = dc_power_socket_jar_body()
    jar = dc_power_socket_jar_lid()
    return jar


render(both())
