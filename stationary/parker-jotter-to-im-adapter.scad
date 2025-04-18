include <BOSL2/std.scad>
$fn = 64;

jotter_d = 5.8;
jotter_l = 98;
im_d = 7;
im_l = 115;

// reducing 2mm because the tip isn't aligned with the pen cover's tip
extender_bottom_l = im_l - jotter_l - 2;
extender_sleeve_l = 15;
extender_od1 = 5.4;
extender_od2 = im_d;
extender_id = jotter_d + 0.2;

sleeve_l = 17;  // 20;
sleeve_id1 = 3.3;
sleeve_id2 = 3.2;  // 2.5 + 0.5;
sleeve_od1 = 5.5;
sleeve_od2 = 4;

module extender() {
  cyl(d1 = extender_od1, d2 = extender_od2, h = extender_bottom_l, anchor = TOP,
      rounding1 = 1);
  tube(od = extender_od2, id = extender_id, l = extender_sleeve_l,
       anchor = BOTTOM);
}

module sleeve() {
  tube(od1 = sleeve_od1, od2 = sleeve_od2, id1 = sleeve_id1, id2 = sleeve_id2,
       h = sleeve_l);
}

// extender();
sleeve();
