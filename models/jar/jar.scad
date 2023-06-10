include <BOSL2/std.scad>
include <BOSL2/threading.scad>
$fn = 64;

epsilon = 0.01;

// Configurable parameters:
od = 105; // Outer diameter
jar_height = 30;
lid_height = 14;
jar_wall = 2;
jar_rounding = 3;

// Threading-related parameters (took me a few test prints to get to these,
// chagne with caution)
thread_wall = 3;
thread_pitch = 2.5;
thread_tolerance = 0.6; // You might have to change this to fit your printer

lid_wall = jar_wall - thread_tolerance / 2;
jar_thread_height = 8;
jar_base_height = jar_height - jar_thread_height;
lid_base_height = lid_height - jar_thread_height;
jar_id = od - jar_wall * 2 - thread_wall * 2;

echo("Jar inner diameter", jar_id);

module jar()
{
    jar_base();
    threaded_neck(od = od - jar_wall * 2, id = jar_id, l = jar_thread_height, pitch = thread_pitch, anchor = BOTTOM);
}

module jar_base()
{
    difference()
    {
        cyl(d = od, h = jar_base_height, rounding1 = jar_rounding, anchor = TOP);
        up(epsilon) cyl(d = jar_id, h = jar_base_height - jar_wall, rounding1 = jar_rounding, anchor = TOP);
    }
}

module threaded_neck(od, id, l, pitch, anchor, spin, orient)
{
    attachable(anchor, spin, orient, d = od, l = l)
    {
        difference()
        {
            threaded_rod(d = od, l = l, pitch = pitch, end_len = 1);
            cyl(d = id, l = l + epsilon);
        }
        children();
    }
}

module lid()
{
    difference()
    {
        cyl(d = od, h = lid_base_height, rounding2 = jar_rounding, anchor = BOTTOM);
        down(epsilon)
            cyl(d = od - lid_wall * 2, h = lid_base_height - lid_wall, rounding2 = jar_rounding, anchor = BOTTOM);
    }

    threaded_ring(od = od, wall = lid_wall, l = jar_thread_height, pitch = thread_pitch, anchor = TOP);
}

module threaded_ring(od, wall, l, pitch, anchor, spin, orient)
{
    attachable(anchor, spin, orient, d = od, l = l)
    {
        intersection()
        {
            cyl(d = od, h = l + epsilon);
            threaded_nut(nutwidth = od * 2, id = od - wall * 2, h = l, pitch = pitch, bevel = false, ibevel = false,
                         end_len = 0.5);
        }
        children();
    }
}

module demo(spacing = 5)
{
    down(spacing + jar_thread_height) jar();
    up(spacing + jar_thread_height) lid();
}

// demo();

// jar();
lid();
// threaded_ring();
