from solid2 import *

from lib.scad import save_scad
from lib.honeycomb_square import honeycomb_square

SEGMENTS = 50


def honeycomb_test():
    return linear_extrude(height=4)(honeycomb_square([50, 100], hexagons=5))


save_scad(honeycomb_test())
