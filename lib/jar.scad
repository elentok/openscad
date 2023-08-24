include <BOSL2/std.scad>
include <BOSL2/structs.scad>
include <BOSL2/threading.scad>
$fn = 64;

epsilon = 0.01;

jar_defaults = [
  // Outer diameter
  [ "od", 105 ],
  [ "jar_height", 30 ],
  [ "lid_height", 14 ],
  [ "jar_wall", 2 ],
  [ "jar_rounding", 3 ],
  [ "jar_thread_height", 8 ],

  // Threading-related parameters (took me a few test prints to get to these,
  // chagne with caution)
  [ "thread_wall", 3 ],
  [ "thread_pitch", 2.5 ],
  // You might have to change this to fit your printer
  [ "thread_tolerance", 0.6 ],
];

function create_jar_props(key_value_pairs) = struct_set(jar_defaults,
                                                        key_value_pairs);

function jar_height(props) = struct_val(props, "jar_height");
function jar_rounding(props) = struct_val(props, "jar_rounding");
function jar_thread_height(props) = struct_val(props, "jar_thread_height");
function jar_thread_pitch(props) = struct_val(props, "thread_pitch");
function jar_wall(props) = struct_val(props, "jar_wall");
function jar_od(props) = struct_val(props, "od");
function jar_id(props) = jar_od(props) - jar_wall(props) * 2 -
                         struct_val(props, "thread_wall") * 2;

// Usage:
//
//   jar_body(jar_props(["jar_height", 40]))
//
module jar_body(props, anchor = BOTTOM) {
  attachable(d = jar_od(props), h = jar_height(props), anchor) {
    up((jar_height(props) / 2 - jar_thread_height(props))) {
      jar_base(props);

      echo("Jar inner diameter", jar_id(props));

      // thread
      od = jar_od(props) - jar_wall(props) * 2;
      threaded_neck(od = jar_od(props), id = jar_id(props),
                    l = jar_thread_height(props),
                    pitch = jar_thread_pitch(props), anchor = BOTTOM);
    }
    children();
  }
}

module jar_base(props) {
  od = struct_val(props, "od");
  jar_base_height = jar_height(props) - jar_thread_height(props);
  difference() {
    cyl(d = od, h = jar_base_height, rounding1 = jar_rounding(props),
        anchor = TOP);
    up(epsilon) cyl(d = jar_id(props), h = jar_base_height - jar_wall(props),
                    rounding1 = jar_rounding(props), anchor = TOP);
  }
}

module threaded_neck(od, id, l, pitch, anchor, spin, orient) {
  attachable(anchor, spin, orient, d = od, l = l) {
    difference() {
      threaded_rod(d = od, l = l, pitch = pitch, end_len = 1);
      cyl(d = id, l = l + epsilon);
    }
    children();
  }
}

module jar_lid(props, anchor = TOP) {
  lid_height = struct_val(props, "lid_height");
  attachable(d = jar_od(props), h = lid_height, anchor) {
    lid_base_height = lid_height - jar_thread_height(props);
    lid_wall = jar_wall(props) - struct_val(props, "thread_tolerance") / 2;

    up(jar_thread_height(props) - lid_height / 2) union() {
      difference() {
        cyl(d = jar_od(props), h = lid_base_height,
            rounding2 = jar_rounding(props), anchor = BOTTOM);
        down(epsilon) cyl(d = jar_od(props) - lid_wall * 2,
                          h = lid_base_height - lid_wall,
                          rounding2 = jar_rounding(props), anchor = BOTTOM);
      }

      threaded_ring(od = jar_od(props), wall = lid_wall,
                    l = jar_thread_height(props),
                    pitch = jar_thread_pitch(props), anchor = TOP);
    }
    children();
  }
}

module threaded_ring(od, wall, l, pitch, anchor, spin, orient) {
  attachable(anchor, spin, orient, d = od, l = l) {
    intersection() {
      cyl(d = od, h = l + epsilon);
      threaded_nut(nutwidth = od * 2, id = od - wall * 2, h = l, pitch = pitch,
                   bevel = false, ibevel = false, end_len = 0.5);
    }
    children();
  }
}

// Demo:
module jar_demo(jar_props, spacing = 5) {
  jar_thread_height = struct_val(jar_props, "jar_thread_height");
  down(spacing + jar_thread_height) jar_body(jar_props);
  up(spacing + jar_thread_height) jar_lid(jar_props);
}
jar_demo(create_jar_props([]));
