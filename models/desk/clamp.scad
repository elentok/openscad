include <BOSL2/std.scad>
$fn = 64;

bolt_cover_height = 6;
height_padding = 6;
desk_height = 20;
thickness = 15;
rounding = 5;

iheight = desk_height + bolt_cover_height + height_padding;
idepth = 45;
iwidth = 50;

owidth = iwidth;
oheight = iheight + thickness * 2;
odepth = idepth + thickness;

// MMS (Modular Mounting System)
mms_thickness = 3.1;
mms_height = 16.5;
mms_width = 15;
mms_hole_d = 5;
mms_nut_d = 9;
mms_nut_h = 3;

module mms3() {
  up(mms_thickness * 2.5) mms_nut_wrapper();
  up(mms_thickness * 2) mms1();
  mms1();
  down(mms_thickness * 2) mms1();
}

module mms_nut_wrapper() {
  back(mms_height - mms_width / 2) linear_extrude(mms_nut_h, convexity = 4)
      difference() {
    circle(d = mms_width);
    hexagon(d = mms_nut_d);
  }
}

module mms1(t = mms_thickness) {
  r = mms_width / 2;

  linear_extrude(t, convexity = 4, center = true) difference() {
    rect([ mms_width, mms_height ], rounding = [ r, r, 0, 0 ], anchor = FWD);
    back(mms_height - r) circle(d = mms_hole_d);
  }
}

module clamp_with_mms() {
  clamp();
  left(odepth - 0.01) up(mms_width / 2) rotate([ 90, -90, 0 ]) mms3();
}

module clamp() {
  linear_extrude(owidth, convexity = 4) difference() {
    rect([ odepth, oheight ], rounding = rounding, anchor = RIGHT);
    right(0.01) rect([ idepth, iheight ],
                     rounding = [ 0, rounding, rounding, 0 ], anchor = RIGHT);
  }
}

// mms3();
// clamp();
clamp_with_mms();
