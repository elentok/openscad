from solid2 import circle, hull, union, debug
from lib.scad import save_scad
from lib.degrees import cos, sin
from enum import Enum


class ArcAlign(Enum):
    START = 1
    END = 2


def arc(
    outer_radius: float,
    from_angle: float,
    to_angle: float,
    thickness: float,
    align: ArcAlign = ArcAlign.START,
    fn: int = 32,
):
    step = abs(to_angle - from_angle) / fn
    r = outer_radius - thickness / 2

    xys = []
    angle = from_angle
    while angle <= to_angle:
        x = round(r * cos(angle), 4)
        y = round(r * sin(angle), 4)
        xys.append((x, y))
        angle += step

    circles = []
    for (x, y) in xys:
        circles.append(circle(d=thickness).right(x).forward(y))

    arc = union()(circles)
    if align == ArcAlign.START:
        x, y = xys[0]
    else:
        x, y = xys[len(xys) - 1]

    print(align)
    print(x, y)

    return arc.right(x).back(y)


if __name__ == "__main__":
    save_scad(arc(outer_radius=20, from_angle=-90, to_angle=30, thickness=5))
