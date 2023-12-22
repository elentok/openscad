include <./vars.scad>
include <BOSL2/screws.scad>
include <BOSL2/std.scad>
$fn = 64;

foot_adapter_h = 6;
foot_d = 18;
foot_bottom_extra_h = 0;  // 3;
sticker_d = 13;
extender_mid_h = 2;
thread_spec = "M14";
thread_h_tolerance = 3;

// Connects the foot to the keyboard case
module foot_adapter() {
  difference() {
    // cyl(d = foot_d, h = foot_adapter_h, anchor = BOTTOM);
    screw("M14", l = foot_adapter_h, anchor = BOTTOM, bevel = false);

    // bolt hole
    down(epsilon / 2)
        cyl(d = bolt_hole_d, h = foot_adapter_h + epsilon, anchor = BOTTOM);

    // bolt head hole
    down(epsilon / 2)
        cyl(d = bolt_head_d, h = bolt_head_h + epsilon, anchor = BOTTOM);
  }
}

module foot_extender(h) {
  male_thread_h = foot_adapter_h;
  female_thread_h = foot_adapter_h + thread_h_tolerance;

  extender_tube_h = h - male_thread_h - female_thread_h - extender_mid_h;

  assert(extender_tube_h > 0,
         "Foot extender is too small, no height left for the threading");

  down(female_thread_h) union() {
    difference() {
      cyl(d = foot_d, h = female_thread_h, anchor = BOTTOM);
      down(epsilon / 2) screw_hole("M14", l = female_thread_h + epsilon,
                                   thread = true, anchor = BOTTOM);
    }

    if (extender_tube_h > 0) {
      tube(od = foot_d, id = 14, h = extender_tube_h, anchor = TOP);
    }

    down(extender_tube_h) cyl(d = foot_d, h = extender_mid_h, anchor = TOP);

    down(extender_mid_h + extender_tube_h)
        screw("M14", l = male_thread_h, anchor = TOP, bevel2 = false);
  }
}

module foot_bottom() {
  thread_h = foot_adapter_h + thread_h_tolerance + foot_bottom_extra_h;
  up(thread_h / 2) difference() {
    cyl(d = foot_d, h = thread_h);
    screw_hole("M14", l = thread_h + epsilon, thread = true);
  }

  cyl(d = foot_d, h = 2, anchor = BOTTOM);
  down(1) tube(od = foot_d, id = sticker_d, h = 1, anchor = BOTTOM);

  // support
  down(1) cyl(d = 1, h = 1, anchor = BOTTOM);
}

module demo() {
  up(5) foot_adapter();
  foot_extender(h = 20);
  down(foot_adapter_h + 30) foot_bottom();
}

// demo();
//
// rotate([ 180, 0, 0 ]) foot_adapter();
// rotate([ 180, 0, 0 ]) foot_extender(h = 15);
foot_bottom();
