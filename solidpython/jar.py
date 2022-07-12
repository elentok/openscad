from solid import *
from lib.render import render

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
        jar = cylinder(d=self.diameter, h=self.wall_width) + hollow_cylinder(
            self.diameter, self.height, self.wall_width
        )

        return jar

        # thread = cylinder(
        #     d=self.diameter, h=self.thread_height, center=True
        # ) - threading.threaded_rod(
        #     d=self.diameter - self.wall_width,
        #     l=self.thread_height + 0.1,
        #     pitch=self.thread_height / 5,
        #     internal=True,
        # )
        # return jar + thread
        # return jar - thread


def hollow_cylinder(d: float, h: float, thickness: float):
    return cylinder(d=d, h=h, center=True) - cylinder(
        d=d - thickness * 2, h=h + 0.2, center=True
    )


jar = Jar(diameter=25, height=30, wall_width=2)
render(jar.render_body())
