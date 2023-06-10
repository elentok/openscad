include <../../lib/bin.scad>
include <../../lib/screw-hole-mask.scad>
include <BOSL2/std.scad>
$fn = 64;

// Configurable parameters:
shelf_size = [ 170, 72, 70 ];
wall_thickness = 2.5;
rounding = 10;
screw_hole_diameter = 4.2;
screw_hole_distance_from_top = 15;
screw_hole_distance_from_side = 25;

module shelf()
{
    diff()
    {
        bin(shelf_size, wall_thickness, [ 0, 0, rounding, rounding ], anchor = BOTTOM + BACK)
        {
            tag("remove") down(screw_hole_distance_from_top) right(screw_hole_distance_from_side)
                position(LEFT + BACK + TOP) shelf_screw_hole_mask();
            tag("remove") down(screw_hole_distance_from_top) left(screw_hole_distance_from_side)
                position(RIGHT + BACK + TOP) shelf_screw_hole_mask();
        }
    }
}

module shelf_screw_hole_mask()
{
    screw_hole_mask(axis = BACK, anchor = BACK, d_screw = screw_hole_diameter, l_wall = wall_thickness,
                    l_screwdriver = shelf_size.y, l_countersink = wall_thickness * 2 / 3);
}

shelf();
