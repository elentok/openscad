include <BOSL2/std.scad>
use <../../lib/grill.scad>
$fn = 64;

thickness = 2;
depth = 20;

tube_od = 112;
tube_thickness = 2.5;

id = tube_od + tube_thickness;
od = id + thickness;

difference() {
  union() {
    tube(od = od, id = id, h = depth + thickness, anchor = BOTTOM);
    tube(od = id, id = tube_od, h = thickness, anchor = BOTTOM);
    grill(d = tube_od, h = thickness);
  }

  up(depth / 2) rotate([ 0, 90, 0 ]) cyl(d = 4.2, h = od + 10);
  up(depth / 2) rotate([ 0, 90, 90 ]) cyl(d = 4.2, h = od + 10);
}
