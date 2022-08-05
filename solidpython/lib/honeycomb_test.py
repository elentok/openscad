from solid import *

from lib.honeycomb_square import honeycomb_square

SEGMENTS = 50


def honeycomb_test():
    return linear_extrude(height=4)(honeycomb_square([50, 100], hexagons=5))


scad_render_to_file(honeycomb_test(), file_header=f"$fn = {SEGMENTS};")
