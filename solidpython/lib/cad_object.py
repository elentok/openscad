from abc import ABC, abstractmethod

from .scad import save_scad
from solid import circle, difference, square, union, OpenSCADObject
from typing import Union, List

numeric = Union[int, float]


class Coordinate:
    x: numeric
    y: numeric
    z: numeric

    def __init__(self, x: numeric, y: numeric, z: numeric = 0):
        self.x = x
        self.y = y
        self.z = z


class CadObject(ABC):
    @abstractmethod
    def render(self) -> OpenSCADObject:
        pass

    @abstractmethod
    def corner(self) -> Coordinate:
        pass

    @abstractmethod
    def bounding_box(self) -> Coordinate:
        pass

    def add(self, object: "CadObject") -> "CadObject":
        return CadUnion(self, object)

    def remove(self, object: "CadObject") -> "CadObject":
        return CadDiff(self, object)

    def export(self):
        save_scad(self.render())


class Circle(CadObject):
    d: numeric
    faces: int

    def __init__(self, d: numeric, faces: int = 64):
        self.d = d
        self.faces = faces

    def render(self):
        return circle(d=self.d, _fn=self.faces)

    def corner(self):
        return Coordinate(-self.d / 2, -self.d / 2, 0)

    def bounding_box(self):
        return Coordinate(self.d, self.d, 0)


class Square(CadObject):
    size: Coordinate

    def __init__(self, size: Coordinate):
        self.size = size

    def render(self):
        return square([self.size.x, self.size.y])

    def corner(self):
        return Coordinate(0, 0, 0)

    def bounding_box(self):
        return self.size


class CadUnion(CadObject):
    children: List[CadObject]

    def __init__(self, *children: CadObject):
        self.children = list(children)

    def render(self):
        openscad_objects = [child.render() for child in self.children]
        return union()(openscad_objects)

    def corner(self):
        pass

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

    def remove(self, object: "CadObject") -> "CadObject":
        self.children.append(object)
        return self


if __name__ == "__main__":
    Circle(d=20).remove(Circle(d=10)).add(Circle(d=2)).export()
