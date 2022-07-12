from solid import *

from solid.extensions.bosl2 import threading


class Jar:
    diameter: float
    height: float

    def __init__(self, diameter, height, wall_width, thread_height=None):
        self.diameter = diameter
        self.height = height
        self.wall_width = wall_width
        self.thread_height = thread_height or 0.2 * self.height

    def render_body(self):
        return cylinder(d=self.diameter, h=self.height) - threading.threaded_rod(
            d=self.diameter - self.wall_width, l=self.thread_height
        )


jar = Jar(diameter=25, height=30, wall_width=2)
scad_render_to_file(jar.render_body(), file_header="$fn=60;\n")
