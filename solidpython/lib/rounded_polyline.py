from typing import List, Tuple
from solid2 import *


def rounded_polyline(thickness: float, points: List[Tuple[float, float]]):
    lines = []
    for i in range(len(points) - 1):
        (x1, y1) = points[i]
        (x2, y2) = points[i + 1]
        line = hull()(
            circle(d=thickness).right(x1).forward(y1),
            circle(d=thickness).right(x2).forward(y2),
        )
        lines.append(line)

    return union()(lines).right(thickness / 2)
