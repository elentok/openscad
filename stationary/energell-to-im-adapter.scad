include <BOSL2/std.scad>
$fn = 64;

/*
 * ========================================
 * Energell to IM refill adapter
 * ========================================
 *
 * To adapt this to your printer you might have to play with the
 * `extender_diameter_tolerance` and the `sleeve_{i,o}d{1,2}` variables.
 *
 */

// ========================================
// Variables
// ========================================

extender_diameter_tolerance = 0.2;

energel_d = 5.8;
energel_l = 98;
im_d = 7;
im_l = 115;

// reducing 2mm because the tip isn't aligned with the pen cover's tip
// extender_bottom_l = im_l - energel_l - 2;
// extender_sleeve_l = 15;
// extender_od1 = 5.4;
// extender_od2 = im_d;
// extender_id = energel_d + extender_diameter_tolerance;

extender_l1 = 5;
extender_d1 = 4.7;
extender_l2 = 2.5;
extender_d2 = 6;
extender_d3 = 4;

sleeve_l = 9;
sleeve_id1 = 3.6;
sleeve_id2 = 3.6;
sleeve_od1 = 6;
sleeve_od2 = 4;

// ========================================
// Modules
// ========================================

module extender() {
  difference() {
    union() {
      cyl(d=extender_d1, h=extender_l1, anchor=BOTTOM, rounding2=0.5);
      cyl(d1=extender_d3, d2=extender_d2, h=extender_l2, anchor=TOP, rounding1=0.5);
    }

    up(0.01) cyl(d=1.5, h=extender_l1, anchor=BOTTOM, rounding2=-0.5);
  }

  // cyl(
  //   d1=extender_od1, d2=extender_od2, h=extender_bottom_l, anchor=TOP,
  //   rounding1=1
  // );
  // tube(
  //   od=extender_od2, id=extender_id, l=extender_sleeve_l,
  //   anchor=BOTTOM
  // );
}

module sleeve() {
  tube(
    od1=sleeve_od1, od2=sleeve_od2, id1=sleeve_id1, id2=sleeve_id2,
    irounding1=0.5,
    orounding2=0.2,
    h=sleeve_l
  );
}

extender();
// sleeve();
