from solid import *
from lib.threed import half_sphere
from lib.twod import half_circle
from lib.types import Size2D, Radius, Side
from lib.scad import save_scad
from .pegboard import Pegboard
from .mount import PegboardMount


class PegboardHook:
    mount: PegboardMount
    pegboard: Pegboard
    depth: float
    height: float
    thickness: float

    def __init__(
        self, pegboard: Pegboard, depth: float, height: float, thickness: float = 4
    ):
        self.pegboard = pegboard
        self.mount = PegboardMount(pegboard, width=thickness)
        self.depth = depth
        self.height = height
        self.thickness = thickness

    def render(self):
        # return self.render_hook2d().linear_extrude(self.thickness)
        return union()(self.mount.render(), self.render_hook())

    def render_hook(self):
        return self.render_hook2d().linear_extrude(self.thickness, center=True)
        # sphere1 = (
        #     half_sphere(d=self.thickness, side=Side.TOP)
        #     .left(self.pegboard.thickness / 2)
        #     .scale([1, 2, 1])
        # ).back(self.thickness)
        #
        # sphere2 = sphere(d=self.thickness).left(self.depth)
        # sphere3 = sphere(d=self.thickness).left(self.depth).forward(self.height)
        # return hull()(sphere1, sphere2) + hull()(sphere2, sphere3)

    def render_hook2d(self):
        circle1 = (
            half_circle(d=self.thickness, side=Side.LEFT)
            .left(self.pegboard.thickness / 2)
            .scale([1, 2, 1])
        ).back(self.thickness)

        circle2 = circle(d=self.thickness).left(self.depth)
        circle3 = circle(d=self.thickness).left(self.depth).forward(self.height)
        return hull()(circle1, circle2) + hull()(circle2, circle3)


if __name__ == "__main__":
    pegboard = Pegboard()
    save_scad(PegboardHook(pegboard, height=10, depth=20).render())
