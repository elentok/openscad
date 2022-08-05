from solid import *
from lib.scad import save_scad

from solid.extensions.bosl2 import threading


class Jar:
    diameter: float
    height: float
    wall_width: float
    thread_height: float
    non_thread_height: float
    thread_pitch: float

    # The lid thread is slightly smaller so that it fits in the jar thread
    gap: float

    def __init__(self, diameter, height, wall_width, thread_height=None, gap=0.3):
        self.diameter = diameter
        self.height = height
        self.wall_width = wall_width
        self.thread_height = thread_height or 0.2 * self.height
        self.non_thread_height = self.height - self.thread_height
        self.thread_pitch = 1
        self.gap = gap

    def render_body(self):
        bottom = cylinder(d=self.diameter, h=self.wall_width)
        wall = hollow_cylinder(
            self.diameter, self.non_thread_height, self.wall_width
        ).up(self.non_thread_height / 2)
        thread = self.jar_thread().up(self.non_thread_height)

        return bottom + wall + thread

    def render_lid(self):
        bottom = cylinder(d=self.diameter, h=self.wall_width)
        return bottom + self.lid_thread().up(self.wall_width)

    def lid_thread(self):
        thread = threading.threaded_rod(
            d=self.diameter - self.wall_width - self.gap * 2,
            l=self.thread_height,
            pitch=self.thread_pitch,
        )

        hole = cylinder(
            d=self.diameter - 3 * self.wall_width,
            h=self.thread_height + 0.1,
            center=True,
        )

        return (thread - hole).up(self.thread_height / 2)

    def jar_thread(self):
        return (
            cylinder(d=self.diameter, h=self.thread_height, center=True)
            - threading.threaded_rod(
                d=self.diameter - self.wall_width,
                l=self.thread_height + 0.1,
                pitch=self.thread_pitch,
                internal=True,
            )
        ).up(self.thread_height / 2)


def hollow_cylinder(d: float, h: float, thickness: float):
    return cylinder(d=d, h=h, center=True) - cylinder(
        d=d - thickness * 2, h=h + 0.2, center=True
    )


if __name__ == "__main__":
    jar = Jar(diameter=25, height=30, wall_width=2)
    save_scad(jar.render_body() + jar.render_lid().up(50))
