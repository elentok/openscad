from dataclasses import dataclass
from enum import Enum
from typing import Optional


class Side(Enum):
    TOP = 1
    BOTTOM = 2
    LEFT = 3
    RIGHT = 4


@dataclass
class Size2D:
    x: float
    y: float

    def array(self):
        return [self.x, self.y]


@dataclass
class Size3D:
    x: float
    y: float
    z: float

    def array(self):
        return [self.x, self.y, self.z]


class Radius:
    top_left: float
    top_right: float
    bottom_right: float
    bototm_left: float

    def __init__(
        self,
        top_left: float,
        top_right: Optional[float] = None,
        bottom_right: Optional[float] = None,
        bottom_left: Optional[float] = None,
    ):
        self.top_left = top_left

        if top_right is None and bottom_right is None and bottom_left is None:
            self.top_right = self.bottom_right = self.bottom_left = top_left
        elif top_right != None and bottom_right != None and bottom_left != None:
            self.top_right = top_right
            self.bottom_right = bottom_right
            self.bottom_left = bottom_left
        else:
            raise ValueError("Either provide a single value or 4 values")
