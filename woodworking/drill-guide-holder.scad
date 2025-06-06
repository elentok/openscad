include <BOSL2/std.scad>
$fn = 64;

padding = 4;
guide_id = 69;
guide_od = 80.5;
guide_inset_h = 8;
guide_thickness = 15;

holder_od = guide_od + padding * 2;

screw_d1 = 16;
screw_h1 = 10;
screw_d2 = 18.5;
screw_h2 = 8.5;

module screw_mask() {
  up(0.01) cyl(d=screw_d1, h=screw_h1, anchor=TOP);
}

module holder() {
  difference() {

    // base
    cyl(d=holder_od, h=15, rounding=2, anchor=TOP);

    // inset
    up(0.01) tube(id=guide_id, od=guide_od, h=guide_inset_h, anchor=TOP);

    screw_mask();
    dist = screw_d2 * 0.8;
    back(dist) left(dist) screw_mask();
    back(dist) right(dist) screw_mask();
    fwd(dist) left(dist) screw_mask();
    fwd(dist) right(dist) screw_mask();
  }
}

holder();
