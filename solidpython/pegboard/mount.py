from solid import *
from .pegboard import Pegboard
from dataclasses import dataclass
from lib.rounded_square import RoundedSquare
from lib.types import Size2D, Radius, Side
from lib.scad import save_scad
from lib.twod import quarter_circle
from lib.arc import arc


@dataclass
class PegboardMount:
    pegboard: Pegboard
    width: float

    def render(self):
        return self.render2d().linear_extrude(self.pegboard.peg_diameter())
        # return union()(
        #     self.render_bar(),
        #     self.render_pegs(),
        # )

    def bar_size(self) -> Size2D:
        p = self.pegboard
        peg_d = p.peg_diameter()
        return Size2D(peg_d, p.hole_spacing + peg_d)

    def render_bar2d(self):
        r = self.pegboard.thickness / 2
        return RoundedSquare(self.bar_size(), Radius(r, 0, 0, r)).render()

    def render2d(self):
        bar = self.render_bar2d()
        top_peg = self.render_top_peg2d()
        bottom_peg = self.render_bottom_peg2d()
        return union()(bar, top_peg, bottom_peg)

    def render_top_peg2d(self):
        p = self.pegboard
        peg_d = p.peg_diameter()

        extension_width = p.thickness / 2
        peg_extension = square([extension_width, peg_d], center=True).right(
            self.bar_size().x / 2 + extension_width / 2
        )
        peg_arc = arc(
            outer_radius=p.wall_distance,
            from_angle=-90,
            to_angle=0,
            thickness=peg_d,
            fn=16,
        ).right(peg_d / 2 + extension_width)

        return union()(peg_extension, peg_arc).forward(p.hole_spacing / 2)

    def render_bottom_peg2d(self):
        p = self.pegboard
        peg_d = p.peg_diameter()

        knob_size = Size2D(3, 0.7)
        peg_size = Size2D(p.thickness + 0.2 + knob_size.x, peg_d)
        peg = (
            RoundedSquare(peg_size, Radius(0, p.thickness / 2, 0, 0))
            .render()
            .right(peg_size.x / 2 + self.bar_size().x / 2)
        )
        knob = (
            square([knob_size.x, knob_size.y])
            .right(self.bar_size().x / 2 + peg_size.x - knob_size.x)
            .back(peg_size.y / 2 + knob_size.y)
        )
        return union()(peg, knob).back(p.hole_spacing / 2)

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

    def render2dx(self):
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
