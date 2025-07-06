include <BOSL2/std.scad>
$fn = 64;

/*
 * ========================================
 * Parker Jotter to IM refill adapter
 * ========================================
 *
 * The adapter has two parts:
 *
 * 1. Extender - attaches to the back of the jotter refill (wraps around it)
 * 2. Sleeve - attaches to the tip of the jotter refill (so it doesn't extend
 * too far out of the cover)
 *
 * To adapt this to your printer you might have to play with the
 * `extender_diameter_tolerance` and the `sleeve_{i,o}d{1,2}` variables.
 *
 */

// ========================================
// Variables
// ========================================

extender_diameter_tolerance = 0.2;

jotter_d = 5.8;
jotter_l = 98;
im_d = 7;
im_l = 115;

// reducing 2mm because the tip isn't aligned with the pen cover's tip
extender_bottom_l = im_l - jotter_l - 2;
extender_sleeve_l = 15;
extender_od1 = 5.4;
extender_od2 = im_d;
extender_id = jotter_d + extender_diameter_tolerance;

sleeve_l = 17;
sleeve_id1 = 3.6;
sleeve_id2 = 3.6;
sleeve_od1 = 5.5;
sleeve_od2 = 4;

// ========================================
// Modules
// ========================================

module extender() {
  cyl(
    d1=extender_od1, d2=extender_od2, h=extender_bottom_l, anchor=TOP,
  );
  tube(
    od=extender_od2, id=extender_id, l=extender_sleeve_l,
    anchor=BOTTOM
  );
}

module sleeve() {
  tube(
    od1=sleeve_od1, od2=sleeve_od2, id1=sleeve_id1, id2=sleeve_id2,
    h=sleeve_l
  );
}

// extender();
sleeve();
