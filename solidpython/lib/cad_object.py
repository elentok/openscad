from abc import ABC, abstractmethod

from .scad import save_scad
from solid import (
    circle,
    cube,
    cylinder,
    difference,
    square,
    translate,
    union,
    OpenSCADObject,
)
from typing import Union, List
from dataclasses import dataclass

numeric = Union[int, float]
numeric_or_string = Union[int, float, str]


class Coordinate:
    x: numeric
    y: numeric
    z: numeric

    def __init__(self, x: numeric, y: numeric, z: numeric = 0):
        self.x = x
        self.y = y
        self.z = z

    def add(self, c: "Coordinate") -> "Coordinate":
        return Coordinate(self.x + c.x, self.y + c.y + self.z + c.z)

    def to_list(self):
        return [self.x, self.y, self.z]


class DynamicCoordinate:
    x: numeric_or_string
    y: numeric_or_string
    z: numeric_or_string

    def __init__(
        self, x: numeric_or_string, y: numeric_or_string, z: numeric_or_string = 0
    ):
        self.x = x
        self.y = y
        self.z = z

    def to_coordinate(self, size: Coordinate) -> Coordinate:
        return Coordinate(
            x=self._add(size.x, self.x),
            y=self._add(size.y, self.y),
            z=self._add(size.z, self.z),
        )

    def _add(self, ref: numeric, value: numeric_or_string) -> numeric:
        if type(value) == int or type(value) == float:
            return float(value)
        else:
            value = str(value)
            if value.endswith("%"):
                percentage = float(value.rstrip("%"))
                return ref * percentage / 100
            raise ValueError(f"Unsupported value: {value}")


@dataclass
class BoundingBox:
    corner: Coordinate
    size: Coordinate


class CadObject(ABC):
    @abstractmethod
    def render(self) -> OpenSCADObject:
        pass

    @abstractmethod
    def bounding_box(self) -> BoundingBox:
        pass

    def add(self, object: "CadObject") -> "CadUnion":
        return CadUnion(self, object)

    def cut(self, object: "CadObject") -> "CadDiff":
        return CadDiff(self, object)

    def move(
        self,
        x: numeric_or_string = 0,
        y: numeric_or_string = 0,
        z: numeric_or_string = 0,
    ) -> "CadTranslate":
        return CadTranslate(DynamicCoordinate(x, y, z), self)

    def export(self):
        save_scad(self.render())


class CadTranslate(CadObject):
    offset: DynamicCoordinate

    def __init__(self, offset: DynamicCoordinate, object: CadObject):
        self.offset = offset
        self.object = object

    def render(self):
        o = self.offset.to_coordinate(self.object.bounding_box().size)
        return translate(o.x, o.y, o.z)(self.object.render())

    def bounding_box(self):
        box = self.object.bounding_box()
        offset = self.offset.to_coordinate(box.size)
        return BoundingBox(corner=box.corner.add(offset), size=box.size)


class Circle(CadObject):
    d: numeric
    faces: int

    def __init__(self, d: numeric, faces: int = 64):
        self.d = d
        self.faces = faces

    def render(self):
        return circle(d=self.d, _fn=self.faces)

    def bounding_box(self):
        return BoundingBox(
            corner=Coordinate(-self.d / 2, -self.d / 2, 0),
            size=Coordinate(self.d, self.d, 0),
        )


class Cylinder(CadObject):
    d1: numeric
    d2: numeric
    h: numeric
    faces: int

    def __init__(
        self,
        h: numeric,
        d: numeric = 0,
        d1: numeric = 0,
        d2: numeric = 0,
        faces: int = 64,
    ):
        assert d != 0 or d1 != 0 or d2 != 0, "Must provide either d, d1 or d2"

        self.h = h
        self.faces = faces
        if d == 0:
            self.d1 = d1
            self.d2 = d2
        else:
            self.d1 = d
            self.d2 = d

    def render(self):
        return cylinder(d1=self.d1, d2=self.d2, h=self.h, _fn=self.faces, center=True)

    def bounding_box(self):
        d = max(self.d1, self.d2)
        return BoundingBox(
            corner=Coordinate(-d / 2, -d / 2, self.h / 2),
            size=(Coordinate(d, d, self.h)),
        )


class Cube(CadObject):
    size: Coordinate

    def __init__(self, size: Coordinate):
        self.size = size

    def render(self):
        return cube(self.size.to_list(), center=True)

    def bounding_box(self):
        s = self.size
        return BoundingBox(
            corner=Coordinate(-s.x / 2, -s.y / 2, -s.z / 2), size=self.size
        )


class Square(CadObject):
    size: Coordinate

    def __init__(self, size: Coordinate):
        self.size = size

    def render(self):
        return square([self.size.x, self.size.y], center=True)

    def bounding_box(self):
        s = self.size
        return BoundingBox(corner=Coordinate(-s.x / 2, -s.y / 2, 0), size=self.size)


class CadUnion(CadObject):
    children: List[CadObject]

    def __init__(self, *children: CadObject):
        self.children = list(children)

    def render(self):
        openscad_objects = [child.render() for child in self.children]
        return union()(openscad_objects)

    def bounding_box(self):
        pass

    def add(self, object: "CadObject") -> "CadObject":
        self.children.append(object)
        return self


class CadDiff(CadObject):
    children: List[CadObject]

    def __init__(self, *children: CadObject):
        self.children = list(children)

    def render(self):
        openscad_objects = [child.render() for child in self.children]
        return difference()(openscad_objects)

    def corner(self):
        pass

    def bounding_box(self):
        pass

    def cut(self, object: "CadObject") -> "CadObject":
        self.children.append(object)
        return self


if __name__ == "__main__":
    Cylinder(d1=5, d2=15, h=30).add(Cube(Coordinate(15, 15, 15))).export()
    # Circle(d=20).cut(Square(Coordinate(x=10, y=10)).move(x="50%")).export()
    # Circle(d=20).cut(Circle(d=10).move(x="50%", y="50%")).cut(Circle(d=5)).export()
    # Circle(d=20).cut(Circle(d=10).move(x="50%")).add(
    #     Circle(d=2).move(x="50%", y="50%")
    # ).export()
