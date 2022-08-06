from solid import *
from .pegboard import Pegboard
from dataclasses import dataclass
from lib.rounded_square import RoundedSquare
from lib.types import Size2D, Radius
from lib.scad import save_scad


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
        # radius = p.peg_diameter() + p.thickness
        radius = p.wall_distance
        arc = (
            circle(d=p.peg_diameter())
            .left(radius)
            .rotate_extrude(90)
            .rotateZ(90)
            .forward(radius)
        )
        end = sphere(d=p.peg_diameter()).forward(radius).right(radius)
        return union()(arc, end).forward(p.hole_spacing / 2 - 0.2)

    def render_bottom_peg(self):
        p = self.pegboard
        sphere1 = sphere(d=p.peg_diameter())
        sphere2 = sphere1.right(p.thickness)
        sphere3 = sphere2.scale([0.5, 1, 1]).right(p.peg_diameter() * 0.75).back(1)
        line1 = hull()(sphere1, sphere2)
        line2 = hull()(sphere2, sphere3)
        return union()(
            line1,
            line2,
        ).back(p.hole_spacing / 2 - 0.2)

    def render2d(self):
        p = self.pegboard
        peg_radius = p.peg_diameter() / 2

        bar_width = p.thickness
        bar_height = 2 * p.hole_spacing + p.hole_diameter
        bar = RoundedSquare(
            Size2D(bar_width, bar_height),
            Radius(2),
        ).render()

        top_peg_width = p.thickness + p.wall_distance / 2 + 20
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


if __name__ == "__main__":
    pegboard = Pegboard()
    save_scad(PegboardMount(pegboard, width=10).render())
