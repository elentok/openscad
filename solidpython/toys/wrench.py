# from solid2 import *
from solid2 import hull, debug
from solid2.extensions.bosl2 import circle, square, difference
from lib.scad import save_scad
from lib.hexagon_shell import calc_hexagon_height


class Wrench:
    handle_d1: float
    handle_d2: float
    handle_dist_between_circles: float
    head_diameter: float
    hexagon_diameter: float
    thickness: float

    def __init__(
        self,
        handle_d1,
        handle_d2,
        handle_dist_between_circles,
        head_diameter,
        hexagon_width,
        thickness,
    ):
        self.handle_d1 = handle_d1
        self.handle_d2 = handle_d2
        self.handle_dist_between_circles = handle_dist_between_circles
        self.head_diameter = head_diameter
        self.hexagon_width = hexagon_width
        self.thickness = thickness

    def render(self):
        return self.render_flat().linear_extrude(self.thickness)

    def render_flat(self):
        return self.render_head() + self.render_handle()

    def render_head(self):
        hexagon_diameter = calc_hexagon_height(self.hexagon_width)
        head = difference()(
            circle(d=self.head_diameter),
            circle(d=hexagon_diameter, _fn=6),
            # Remove the area from the hexagon to the right (so it can fit over
            # the screw head).
            square([self.head_diameter / 2, self.hexagon_width]).back(
                self.hexagon_width / 2
            ),
            # Remove the sharp corners the remain after removing the center.
            circle(d=self.head_diameter * 1.2, _fn=6)
            .scale([0.8, 1])
            .right(self.head_diameter * 1.2 / 2),
        )

        # Round the corners.
        return head.offset(r=-3).offset(r=3)

    def render_handle(self):
        return difference()(
            hull()(
                circle(d=self.handle_d1).left(self.handle_dist_between_circles)
                + circle(d=self.handle_d2)
            ),
            # Make sure not to exceed the head of the wrench.
            circle(d=self.head_diameter * 0.8, _fn=6),
            # Make a hole at the base of the handle.
            circle(d=self.handle_d1 * 0.7).left(self.handle_dist_between_circles),
        )


wrench = Wrench(
    handle_d1=20,
    handle_d2=15,
    handle_dist_between_circles=70,
    head_diameter=37,
    hexagon_width=19.1,
    thickness=5,
)

save_scad(wrench.render())
