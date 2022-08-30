from solid2 import *
from lib.scad import save_scad

from lib.jar import Jar

height = 30
diameter = 25
wall_width = 1.7

# The first layer expands a bit, these values account for that.
lid_hole_diameter = 11.6 + 0.5
lid_hole_width = 10.8 + 0.3

body_hole_diameter = 5


def dc_power_socket_jar_body():
    jar_body = Jar(
        diameter, height, wall_width, thread_height=0.2 * height
    ).render_body()
    hole = cylinder(d=body_hole_diameter, h=wall_width + 0.2).down(0.1)
    return jar_body - hole


def dc_power_socket_jar_lid():
    jar_lid = Jar(diameter, height, wall_width).render_lid()
    hole = (
        intersection()(
            circle(d=lid_hole_diameter),
            square([lid_hole_width, lid_hole_diameter], center=True),
        )
        .linear_extrude(wall_width + 0.2)
        .down(0.1)
    )
    return jar_lid - hole
    # return hole


lid = dc_power_socket_jar_lid()
body = dc_power_socket_jar_body()

save_scad(lid, "dc_power_socked_jar_lid.scad")
save_scad(body, "dc_power_socket_jar_body.scad")
save_scad(body + lid.up(height * 1.3), "dc_power_socket.scad")
