include <BOSL2/std.scad>
$fn = 64;

id1 = 114.2;
id2 = 100;
wall_thickness = 2.6;
h1 = 15;
h2 = 60;

tube(id = id1, od = id1 + wall_thickness * 2, h = h1, anchor = TOP);
tube(id1 = id1, od1 = id1 + wall_thickness * 2, id2 = id2,
     od2 = id2 + wall_thickness * 2, h = h2, anchor = BOTTOM);
