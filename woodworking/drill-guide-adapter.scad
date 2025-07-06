include <BOSL2/std.scad>
$fn = 64;

id = 6.3;
od = 6.8;

tube(od = od, id = id, h = 30, anchor = BOTTOM);
tube(od = 18, id = id, h = 3, anchor = TOP, rounding1 = 1);
