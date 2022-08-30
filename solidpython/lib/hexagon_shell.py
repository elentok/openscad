# from dataclasses import dataclass
from solid2 import *
from lib.degrees import cos, sin
from typing import Optional
from math import sqrt

SEGMENTS = 52

# Using the pythagorean theorem:
#
#   (Width/2)^2 + (r/2)^2 = r^2
#
def calc_hexagon_width(height: float):
    return sqrt(3) * height / 2


def calc_hexagon_height(width: float):
    return width * 2 / sqrt(3)


class HexagonShell:
    height: float
    width: float
    thickness: float

    def __init__(
        self,
        height: Optional[float] = None,
        width: Optional[float] = None,
        thickness: Optional[float] = None,
    ):
        if height:
            self.height = height
            self.width = calc_hexagon_width(height)
        elif width:
            self.width = width
            self.height = calc_hexagon_height(width)
        else:
            raise ValueError("Must provide either width or height")

        self.thickness = thickness if thickness else self.width * 0.2

    def render(self):
        radius = self.height / 2 - self.thickness / 2
        parts = []
        for i in range(0, 6):
            x1 = radius * cos(i * 60)
            y1 = radius * sin(i * 60)
            circle1 = translate([x1, y1])(circle(d=self.thickness))

            x2 = radius * cos((i + 1) * 60)
            y2 = radius * sin((i + 1) * 60)
            circle2 = translate([x2, y2])(circle(d=self.thickness))
            parts.append(hull()([circle1, circle2]))
        return rotateZ(90)(union()(parts))

    def render_pattern(self, x_reps: int, y_reps: int):
        pattern_height = 1.5 * self.height

        hexagons = []

        for index_x in range(0, x_reps):
            x1 = index_x * self.width
            x2 = x1 + self.width / 2

            for index_y in range(0, y_reps):
                y1 = index_y * pattern_height
                hexagons.append(translate([x1, y1])(self.render()))
                y2 = y1 + pattern_height / 2
                hexagons.append(translate([x2, y2])(self.render()))

        return union()(hexagons)
