from solid import hull, circle, square
from typing import Tuple
from .types import Radius, Size2D
from dataclasses import dataclass


# ------------------------------------------------------------
# Rounded Square
# ------------------------------------------------------------
#
# Uses 4 corners and a hull() to connect them to a rectangle.
# Rounded corners are circles while straight corners are squares.
#
# Arguments:
#
# - size: [x, y]
# - radius: r or [r_top_left, r_top_right, r_bottom_right, r_bottom_left]
#
@dataclass
class RoundedSquare:
    size: Size2D
    radius: Radius

    def max_radius(self):
        return min(self.size.x / 2, self.size.y / 2)

    def render(self):
        return hull()(
            self.render_top_left(),
            self.render_top_right(),
            self.render_bottom_right(),
            self.render_bottom_left(),
        )

    def render_top_left(self):
        r_top_left = min(self.radius.top_left, self.max_radius())
        if r_top_left == 0:
            return square([1, 1]).left(self.size.x / 2).forward(self.size.y / 2 - 1)
        else:
            x = self.size.x / 2 - r_top_left
            y = self.size.y / 2 - r_top_left
            return circle(r=r_top_left).left(x).forward(y)

    def render_top_right(self):
        r_top_right = min(self.radius.top_right, self.max_radius())
        if r_top_right == 0:
            return (
                square([1, 1]).right(self.size.x / 2 - 1).forward(self.size.y / 2 - 1)
            )
        else:
            x = self.size.x / 2 - r_top_right
            y = self.size.y / 2 - r_top_right
            return circle(r=r_top_right).right(x).forward(y)

    def render_bottom_right(self):
        r_bottom_right = min(self.radius.bottom_right, self.max_radius())
        if r_bottom_right == 0:
            return square([1, 1]).right(self.size.x / 2 - 1).back(self.size.y / 2)
        else:
            x = self.size.x / 2 - r_bottom_right
            y = self.size.y / 2 - r_bottom_right
            return circle(r=r_bottom_right).right(x).back(y)

    def render_bottom_left(self):
        r_bottom_left = min(self.radius.bottom_left, self.max_radius())
        if r_bottom_left == 0:
            return square([1, 1]).left(self.size.x / 2).back(self.size.y / 2)
        else:
            x = self.size.x / 2 - r_bottom_left
            y = self.size.y / 2 - r_bottom_left
            return circle(r=r_bottom_left).left(x).back(y)
