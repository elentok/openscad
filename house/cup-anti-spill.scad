include <BOSL2/std.scad>
$fn = 64;

// mark 1:
// id_bottom = 59;
// id_top = 64;
// od_bottom = 100;
// od_top = 70;

id_bottom = 61;
id_top = 66;
od_bottom = 110;
od_top = 70;
h = 30;

tube(od1 = od_bottom, od2 = od_top, id1 = id_bottom, id2 = id_top, h = h,
     anchor = BOTTOM);
