from solid import *

from lib.render import render
from lib.rounded_square import RoundedSquare
from lib.types import Size2D, Radius
from lib.threed import half_sphere, Side
from dataclasses import dataclass
from typing import Optional


@dataclass
class Pegboard:
    hole_diameter: float = 4
    hole_spacing: float = 15  # 25
    wall_distance: float = 7  # 12.7
    holes_x: int = 10
    holes_y: int = 10
    border_radius: float = 10
    thickness: float = 2.5
    border_width: float = 2
    border_corner_percentage: float = 0.3

    def peg_diameter(self):
        return self.hole_diameter - 0.8

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


@dataclass
class PegboardMount:
    pegboard: Pegboard
    width: float

    def render(self):
        return union()(
            self.render_bar(),
            self.render_pegs(),
        )

    def render_pegs(self):
        p = self.pegboard
        return union()(
            self.render_top_peg().right(p.thickness / 2),
            self.render_bottom_peg().right(p.peg_diameter() / 2),
        )

    def render_bar(self):
        p = self.pegboard
        height = p.hole_spacing + p.hole_diameter * 2
        return (
            RoundedSquare(Size2D(self.width, height), Radius(p.hole_diameter / 2))
            .render()
            .linear_extrude(p.thickness, center=True)
            .rotateY(90)
        )

    def render_top_peg(self):
        p = self.pegboard
        radius = p.peg_diameter() + p.thickness
        arc = (
            circle(d=p.peg_diameter())
            .left(radius)
            .rotate_extrude(90)
            .rotateZ(90)
            .forward(radius)
        )
        end = sphere(d=p.peg_diameter()).forward(radius).right(radius)
        return union()(arc, end).forward(p.hole_spacing / 2)

    def render_bottom_peg(self):
        p = self.pegboard
        sphere1 = sphere(d=p.peg_diameter())
        sphere2 = sphere1.right(p.thickness)
        return hull()(
            sphere1,
            sphere2,
        ).back(p.hole_spacing / 2)

    def render2d(self):
        p = self.pegboard
        peg_radius = p.peg_diameter() / 2

        bar_width = p.thickness
        bar_height = 2 * p.hole_spacing + p.hole_diameter
        bar = RoundedSquare(
            Size2D(bar_width, bar_height),
            Radius(2),
        ).render()

        top_peg_width = p.thickness + p.wall_distance / 2
        # top_peg = (
        #     hull()(
        #         square([p.peg_diameter(), p.peg_diameter()], center=True),
        #         circle(d=p.peg_diameter()).right(top_peg_width - peg_radius),
        #     )
        #     .right(peg_radius + bar_width / 2)
        #     .forward(p.hole_spacing / 2)
        # )
        top_peg_part1 = RoundedSquare(
            Size2D(top_peg_width, p.peg_diameter()),
            Radius(0, 0, peg_radius, 0),
        ).render()

        top_peg_part2 = (
            RoundedSquare(
                Size2D(p.peg_diameter(), p.peg_diameter()),
                Radius(peg_radius, peg_radius, 0, 0),
            )
            .render()
            .right(top_peg_width / 2 - peg_radius)
            .forward(p.peg_diameter())
        )

        top_peg = (
            union()(top_peg_part1, top_peg_part2)
            .right(top_peg_width / 2 + bar_width / 2)
            .forward(p.hole_spacing / 2)
        )

        bottom_peg = (
            RoundedSquare(
                Size2D(p.thickness, p.peg_diameter()),
                Radius(0, peg_radius, peg_radius, 0),
            )
            .render()
            .back(p.hole_spacing / 2)
            .right(p.thickness)
        )

        return union()(bar, top_peg, bottom_peg)


class PegboardHook:
    mount: PegboardMount
    pegboard: Pegboard
    depth: float
    thickness: float

    def __init__(self, pegboard: Pegboard, depth: float, thickness: float = 5):
        self.pegboard = pegboard
        self.mount = PegboardMount(pegboard, width=thickness)
        self.depth = depth
        self.thickness = thickness

    def render(self):
        return union()(self.mount.render(), self.render_hook())

    def render_hook(self):
        sphere1 = (
            half_sphere(d=self.thickness, side=Side.LEFT)
            .left(self.pegboard.thickness / 2)
            .scale([1, 2, 1])
        ).back(self.thickness)

        sphere2 = sphere(d=self.thickness).left(self.depth)
        sphere3 = sphere(d=self.thickness).left(self.depth).forward(self.depth)
        return hull()(sphere1, sphere2) + hull()(sphere2, sphere3)


pegboard = Pegboard()
# render(Pegboard().render())
# render(PegboardMount(pegboard).render())
render(PegboardHook(pegboard, depth=10).render())
