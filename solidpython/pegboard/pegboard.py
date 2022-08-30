from solid2 import *

from lib.scad import save_scad
from lib.rounded_square import RoundedSquare
from lib.types import Size2D, Radius
from dataclasses import dataclass
from typing import Optional


@dataclass
class Pegboard:
    hole_diameter: float = 4
    hole_spacing: float = 15  # 25
    wall_distance: float = 5  # 12.7
    holes_x: int = 10
    holes_y: int = 10
    border_radius: float = 10
    thickness: float = 2.5
    border_width: float = 2
    border_corner_percentage: float = 0.3

    def peg_diameter(self):
        return self.hole_diameter - 1

    def width(self):
        return (
            (self.holes_x - 1) * self.hole_spacing
            + self.hole_diameter
            + self.padding() * 2
        )

    def height(self):
        return (
            (self.holes_y - 1) * self.hole_spacing
            + self.hole_diameter
            + self.padding() * 2
        )

    def size(self):
        return Size2D(self.width(), self.height())

    def padding(self):
        return self.hole_spacing / 2

    def render(self):
        return union()(
            self.render2d().linear_extrude(self.thickness), self.render_wall_distance()
        )

    def render_wall_distance(self):
        inner_size = Size2D(
            self.width() - 2 * self.border_width, self.height() - 2 * self.border_width
        )
        corner_width = self.width() * self.border_corner_percentage
        corner_height = self.height() * self.border_corner_percentage
        shell = difference()(
            self.render_board(),
            RoundedSquare(inner_size, Radius(self.border_radius)).render(),
            square([self.width(), self.height() - corner_height], center=True),
            square([self.width() - corner_width, self.height()], center=True),
        )
        return shell.linear_extrude(self.wall_distance).up(self.thickness)

    def render2d(self):
        print(self.size())
        board = self.render_board()
        holes = self.render_holes()
        return difference()(board, holes)

    def render_board(self):
        return RoundedSquare(self.size(), Radius(self.border_radius)).render()

    def render_holes(self):
        x0 = self.width() / 2 - self.padding() - self.hole_diameter / 2
        y0 = self.height() / 2 - self.padding() - self.hole_diameter / 2
        holes = []
        for ix in range(self.holes_x):
            for iy in range(self.holes_y):
                x = ix * self.hole_spacing - x0
                y = iy * self.hole_spacing - y0
                hole = circle(d=self.hole_diameter).right(x).forward(y)
                holes.append(hole)
        return union()(holes)


if __name__ == "__main__":
    save_scad(Pegboard(holes_x=3, holes_y=3).render())
