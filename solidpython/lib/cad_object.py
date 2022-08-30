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
    hull,
    OpenSCADObject,
)
from typing import Union, List, cast, Optional
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

    def add(
        self,
        c: Optional["Coordinate"] = None,
        x: numeric = 0,
        y: numeric = 0,
        z: numeric = 0,
    ) -> "Coordinate":
        if c != None:
            return Coordinate(self.x + c.x, self.y + c.y + self.z + c.z)
        else:
            return Coordinate(self.x + x, self.y + y, self.z + z)

    def to_list(self):
        return [self.x, self.y, self.z]


coordinate = Union[
    Coordinate, tuple[numeric, numeric], tuple[numeric, numeric, numeric]
]


def build_coordinate(c: coordinate) -> Coordinate:
    if type(c) == Coordinate:
        return cast(Coordinate, c)
    else:
        t = cast(tuple, c)
        if len(t) == 2:
            return Coordinate(t[0], t[1])
        return Coordinate(t[0], t[1], t[2])


ZERO = Coordinate(0, 0, 0)


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
    center: Coordinate
    size: Coordinate

    def half(self, which) -> "BoundingBox":
        if which == "top":
            center = self.center
            size = self.size
            return BoundingBox(
                center=center.add(y=size.y / 4), size=size.add(y=-size.y / 2)
            )


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

    def linear_extrude(self, height: numeric) -> "LinearExtrude":
        return LinearExtrude(self, height)

    def debug(self) -> "CadDebug":
        return CadDebug(self)

    def round_corners(self, radius: numeric) -> "RoundCorners":
        return RoundCorners(self, radius)

    # def crop(self, half: str) -> CadDiff:
    #     return self.cut()


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
        return BoundingBox(center=box.center.add(offset), size=box.size)


class Circle(CadObject):
    d: numeric
    faces: int

    def __init__(self, d: numeric, faces: int = 64):
        self.d = d
        self.faces = faces

    def render(self):
        return circle(d=self.d, _fn=self.faces)

    def bounding_box(self):
        return BoundingBox(center=ZERO, size=Coordinate(self.d, self.d, 0))


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
        return BoundingBox(center=ZERO, size=(Coordinate(d, d, self.h)))


class Cube(CadObject):
    size: Coordinate

    def __init__(self, size: Coordinate):
        self.size = size

    def render(self):
        return cube(self.size.to_list(), center=True)

    def bounding_box(self):
        s = self.size
        return BoundingBox(center=ZERO, size=self.size)


class Square(CadObject):
    size: Coordinate

    def __init__(self, size: coordinate):
        self.size = build_coordinate(size)

    def render(self):
        return square([self.size.x, self.size.y], center=True)

    def bounding_box(self):
        return BoundingBox(center=ZERO, size=self.size)


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

    def bounding_box(self):
        pass

    def cut(self, object: "CadObject") -> "CadObject":
        self.children.append(object)
        return self


class Hull(CadObject):
    children: list[CadObject]

    def __init__(self, children: list[CadObject]):
        self.children = children

    def render(self):
        openscad_objects = [child.render() for child in self.children]
        return hull()(openscad_objects)

    def bounding_box(self):
        pass


class LinearExtrude(CadObject):
    object: CadObject
    height: numeric

    def __init__(self, object: CadObject, height: numeric):
        self.object = object
        self.height = height

    def render(self):
        return self.object.render().linear_extrude(self.height)

    def bounding_box(self):
        pass


class RoundedPolyline(CadObject):
    thickness: numeric
    points: list[tuple[numeric, numeric]]

    def __init__(self, thickness: numeric, points: list[tuple[numeric, numeric]]):
        self.thickness = thickness
        self.points = points

    def render(self):
        lines = []
        for i in range(len(self.points) - 1):
            (x1, y1) = self.points[i]
            (x2, y2) = self.points[i + 1]
            line = hull()(
                circle(d=self.thickness).right(x1).forward(y1),
                circle(d=self.thickness).right(x2).forward(y2),
            )
            lines.append(line)
        return union()(lines)

    def bounding_box(self):
        pass


class CadDebug(CadObject):
    object: CadObject

    def __init__(self, object: CadObject):
        self.object = object

    def render(self):
        return self.object.render().debug()

    def bounding_box(self):
        return self.object.bounding_box()


class RoundCorners(CadObject):
    object: CadObject
    radius: numeric

    def __init__(self, object: CadObject, radius: numeric):
        self.object = object
        self.radius = radius

    def render(self):
        return self.object.render().offset(r=-self.radius).offset(r=self.radius)

    def bounding_box(self):
        return self.object.bounding_box()


if __name__ == "__main__":
    # Cylinder(d1=5, d2=15, h=30).add(Cube(Coordinate(15, 15, 15)).move(y="50%")).export()
    RoundedPolyline(thickness=4, points=[(0, 0), (15, 0), (15, 15)]).linear_extrude(
        5
    ).export()
    # Circle(d=20).cut(Square(Coordinate(x=10, y=10)).move(x="50%")).export()
    # Circle(d=20).cut(Circle(d=10).move(x="50%", y="50%")).cut(Circle(d=5)).export()
    # Circle(d=20).cut(Circle(d=10).move(x="50%")).add(
    #     Circle(d=2).move(x="50%", y="50%")
    # ).export()
