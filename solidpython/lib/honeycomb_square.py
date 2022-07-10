from .hexagon_shell import HexagonShell
from typing import Tuple
from math import ceil
from solid import square


def honeycomb_square(size: Tuple[float, float], hexagons: int):
    hexagon = HexagonShell(width=size[0] / hexagons)
    pattern_height = hexagon.height * 1.5

    x_reps = ceil(size[0] / hexagon.width) + 1
    y_reps = ceil(size[1] / pattern_height) + 1

    return square(size) & hexagon.render_pattern(x_reps, y_reps).back(
        pattern_height / 2
    )
