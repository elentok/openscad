from solid import *
from lib.scad import save_scad
from lib.rounded_polyline import rounded_polyline


class Scope:
    thickness: float
    crosshair_thickness: float
    length: float
    r1: float
    r2: float
    r3: float
    l1: float
    l1to2: float
    l2: float
    l2to3: float
    l3: float

    def __init__(
        self, thickness: float, length: float, r1: float, r2: float, r3: float
    ):
        self.thickness = thickness
        self.crosshair_thickness = thickness / 2
        self.length = length
        self.r1 = r1
        self.r2 = r2
        self.r3 = r3
        self.l1 = self.length * 0.2
        self.l1to2 = self.length * 0.1
        self.l2 = self.length * 0.3
        self.l2to3 = self.length * 0.1

    def render(self):
        return union()(
            self.render2d().rotate_extrude(),
            self.render_crosshair(self.r2).up(
                self.l1 + self.l1to2 + self.thickness * 2
            ),
            self.render_crosshair(self.r2).up(self.l1 + self.l1to2 + self.l2),
        ).down(self.l1 + self.l1to2 + self.thickness / 2)

    def render2d(self):
        return rounded_polyline(
            thickness=2,
            points=[
                (0, self.r1),
                (self.l1, self.r1),
                (self.l1 + self.l1to2, self.r2),
                (self.l1 + self.l1to2 + self.l2, self.r2),
                (self.l1 + self.l1to2 + self.l2 + self.l2to3, self.r3),
                (self.length, self.r3),
            ],
        ).rotateZ(90)

    def render_crosshair(self, radius: float):
        return cube(
            [self.crosshair_thickness, radius * 2, self.crosshair_thickness],
            center=True,
        ) + cube(
            [radius * 2, self.crosshair_thickness, self.crosshair_thickness],
            center=True,
        )


class Grip:
    scope: Scope
    distance: float  # Distance between the largest part of the scope to the toy
    height: float  # Scope max height + distance
    width: float
    screw_diameter: float
    screwdriver_diameter: float

    def __init__(
        self,
        scope: Scope,
        width: float,
        distance: float,
        screw_diameter: float = 4,
        screwdriver_diameter: float = 7.5,
    ):
        self.scope = scope
        self.distance = distance
        self.width = width
        self.size_z = self.scope.l2 - 0.1  # - self.scope.thickness / 2
        self.size_y = self.scope.r3 + distance
        self.triangle_height = self.size_y
        self.screw_diameter = screw_diameter
        self.screwdriver_diameter = screwdriver_diameter

    def render(self):
        return self.render2d().linear_extrude(self.size_z) - self.triangle_mask()

    def holes_mask(self):
        return union()(
            self.hole().up(self.scope.l2 - self.screwdriver_diameter * 0.7),
            self.hole().up(self.triangle_height - self.screwdriver_diameter * 0.6),
        )

    def triangle_mask(self):
        return (
            polygon(
                [
                    [0, 0],
                    [0, self.triangle_height + 0.1],
                    [self.size_y / 2, self.triangle_height + 0.1],
                ]
            )
            .linear_extrude(self.width, center=True)
            .rotateY(90 * 3)
        )

    def hole(self):
        screw_hole = (
            cylinder(d=self.screw_diameter, h=self.size_y + 0.2, center=True)
            .rotateY(90)
            .rotateZ(90)
            .forward(self.size_y / 2)
        )

        screwdriver_hole = (
            cylinder(
                d=self.screwdriver_diameter,
                h=self.size_y * 2,
                center=True,
            )
            .rotateY(90)
            .rotateZ(90)
            .back(4)  # screw height
        )

        return screw_hole + screwdriver_hole

    def render2d(self):
        return square([self.width, self.size_y]).left(self.width / 2) - circle(
            r=self.scope.r2
        )


if __name__ == "__main__":
    scope = Scope(length=100, thickness=2, r1=10, r2=7, r3=14)
    grip = Grip(scope, width=10, distance=5)
    save_scad(scope.render() + grip.render() - grip.holes_mask())
    # render(grip.render())
