from dataclasses import dataclass


@dataclass
class HexagonShell:
    height: int
    thickness: int


# def hexagon_shell():

# module hexagon_shell(height, thickness) {
#   radius = height / 2 - thickness / 2;
#   rotate([ 0, 0, 90 ]) for (i = [0:5]) {
#     hull() {
#       x1 = radius * cos(i * 60);
#       y1 = radius * sin(i * 60);
#       translate([ x1, y1 ]) circle(d = thickness);
#
#       x2 = radius * cos((i + 1) * 60);
#       y2 = radius * sin((i + 1) * 60);
#       translate([ x2, y2 ]) circle(d = thickness);
#     }
#   }
# }
#
