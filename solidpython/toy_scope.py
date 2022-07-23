from solid import *
from lib.render import render
from lib.rounded_polyline import rounded_polyline


class Scope:
    length: float
    r1: float
    r2: float
    r3: float

    def __init__(self, length: float, r1: float, r2: float, r3: float):
        self.length = length
        self.r1 = r1
        self.r2 = r2
        self.r3 = r3

    def render(self):
        return self.render2d().rotateZ(90).rotate_extrude()

    def render2d(self):
        l1 = self.length * 0.2
        l1to2 = self.length * 0.1
        l2 = self.length * 0.3
        l2to3 = self.length * 0.1
        return rounded_polyline(
            thickness=2,
            points=[
                (0, self.r1),
                (l1, self.r1),
                (l1 + l1to2, self.r2),
                (l1 + l1to2 + l2, self.r2),
                (l1 + l1to2 + l2 + l2to3, self.r3),
                (self.length, self.r3),
            ],
        )


if __name__ == "__main__":
    render(Scope(length=100, r1=10, r2=8, r3=15).render())
