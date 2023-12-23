include <BOSL2/screws.scad>
include <BOSL2/std.scad>
$fn = 64;

nut_h = 4.5;
nut_d = 11.2;
bolt_cover_height = 6;
height_padding = 6;
desk_height = 20;
thickness = 15;
rounding = 5;

bolt = "M8";

iheight = desk_height + bolt_cover_height + height_padding;
idepth = 45;
iwidth = 50;

owidth = iwidth;
oheight = iheight + thickness * 2;
odepth = idepth + thickness;

module clamp() {
  difference() {
    clamp_base();

    // bolt thread
    down(0.01 / 2) back(odepth / 3) {
      left(owidth / 4) screw_hole(bolt, l = thickness + 0.01, thread = true,
                                  anchor = BOTTOM);
      right(owidth / 4) screw_hole(bolt, l = thickness + 0.01, thread = true,
                                   anchor = BOTTOM);
    }
  }
}

module nut_mask() {}

module clamp_base() {
  right(owidth / 2) up(oheight / 2) rotate([ 90, 0, -90 ])
      linear_extrude(owidth, convexity = 4) difference() {
    rect([ odepth, oheight ], rounding = rounding, anchor = RIGHT);
    right(0.01) rect([ idepth, iheight ],
                     rounding = [ 0, rounding, rounding, 0 ], anchor = RIGHT);
  }
}

clamp();
// clamp_with_mms();
