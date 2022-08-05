from solid import *
from lib.threed import half_sphere, Side
from lib.types import Size2D, Radius
from lib.render import render
from .pegboard import Pegboard
from .mount import PegboardMount


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


if __name__ == "__main__":
    pegboard = Pegboard()
    render(PegboardHook(pegboard, depth=20).render())
