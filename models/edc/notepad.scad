$fn = 60;
include <BOSL2/std.scad>

// ------------------------------------------------------------
// Selectors:

notepad_type = "KohinorNo1-Large";
// notepad_type = "KohinorNo1-Small"; (a slightly smaller variation)

pen_holder_type = "round";
// pen_holder_type = "zebra";

// ------------------------------------------------------------
// Notepads:

notepad_size = notepad_type == "KohinorNo1-Small"   ? [ 62.7, 102, 4 ]
               : notepad_type == "KohinorNo1-Large" ? [ 62.4, 103, 4 ]
                                                    : assert(false, "Invalid notepad_type");

notepad_top_length = notepad_type == "KohinorNo1-Small"   ? 13
                     : notepad_type == "KohinorNo1-Large" ? 11
                                                          : assert(false, "Invalid notepad_type");

// ------------------------------------------------------------
// Misc Variables:
notepad_tolerance = 0.3;
thickness = 1;
bottom_thickness = 2;
rounding = 2;
keychain_hole_diameter = 5;
keychain_hole_margin = 1;
thumb_diameter = 20;

text_on_the_back = "";
text_on_the_back_font = "Arial:style=Bold";
text_on_the_back_size = 20;

subtext_on_the_back = "";
subtext_on_the_back_size = 14;

container_size = [
  notepad_size.x + notepad_tolerance + thickness * 2,
  notepad_size.y + notepad_tolerance + thickness * 2,
  notepad_size.z + bottom_thickness,
];

// ------------------------------------------------------------
// Pen Holder Variables:
pen_holder_thickness = 0.7;

// ------------------------------------------------------------
// Round pen variables.
// Narwhalco 3.35" pen (https://www.amazon.com/dp/B0776LK634)
round_pen_holder_length = 30;
round_pen_holder_dist_from_top = 10;
round_pen_diameter = 7.4;

// ------------------------------------------------------------
// Zebra Telescopic Ballpoint Pen variables.
// https://www.amazon.com/dp/B00NACZB1S
zebra_pen_cap_diameter = 5;
zebra_pen_cap_height = 9;
zebra_pen_cap_distance = 2.5;
zebra_pen_holder_length = 22;
zebra_pen_holder_dist_from_top = 10;
zebra_pen_holder_isize = [ 3, 6, 30 ];
zebra_pen_holder_osize = [
  zebra_pen_holder_isize.x + pen_holder_thickness * 2,
  zebra_pen_holder_isize.y + pen_holder_thickness * 2, zebra_pen_holder_isize.z
];

// ------------------------------------------------------------
module container() {
  r = pen_holder_type == "zebra" ? [ rounding, rounding, rounding, 0 ] : rounding;
  // outer box
  linear_extrude(container_size.z) rect([ container_size.x, container_size.y ], rounding = r);
}

module notepad_mask() {
  top_size = [
    notepad_size.x,
    notepad_top_length,
    notepad_size.z + 0.1,
  ];

  bottom_size = [
    notepad_size.x + notepad_tolerance,
    notepad_size.y + notepad_tolerance - notepad_top_length,
    notepad_size.z + 0.1,
  ];

  y = -top_size.y + (bottom_size.y + top_size.y) / 2;
  up(bottom_thickness) back(y) union() {
    cube(top_size, anchor = BOTTOM + FWD);
    cube(bottom_size, anchor = BOTTOM + BACK);
  }
}

module keychain_hole() {
  x = (notepad_size.x - keychain_hole_diameter) / 2 - keychain_hole_margin;
  y = (notepad_size.y - keychain_hole_diameter) / 2 - keychain_hole_margin;
  translate([ -x, y, -0.1 ]) cylinder(d = keychain_hole_diameter, h = bottom_thickness + 0.2);
}

module notepad_top() { up(thickness) cube(notepad_size, anchor = BOTTOM); }

module thumb_mask() {
  y = (notepad_size.y) / 2;
  translate([ 0, -y, -0.1 ]) linear_extrude(container_size.z + 0.2) circle(d = thumb_diameter);
}

module pen_holder() {
  if (pen_holder_type == "round") {
    round_pen_holder();
  } else if (pen_holder_type == "zebra") {
    zebra_pen_holder();
    zebra_pen_cap();
  }
}

module round_pen_holder() {
  od = round_pen_diameter + pen_holder_thickness * 2;

  x = container_size.x / 2 + od / 2;
  y = container_size.y / 2 - round_pen_holder_dist_from_top;
  z = od / 2;
  translate([ x, y, z ]) rotate([ 90, 0, 0 ]) linear_extrude(round_pen_holder_length) union() {
    shell2d(pen_holder_thickness) circle(d = round_pen_diameter);
    difference() {
      left(od / 2) fwd(od / 2) square([ od / 2, od / 2 ]);
      circle(d = od);
    }
  }
}

// Holder for the telescopic zebra pen
module zebra_pen_holder() {
  rounding = zebra_pen_holder_isize.x / 2;
  x = (container_size.x / 2 + zebra_pen_holder_osize.x / 2 - thickness);
  y = container_size.y / 2 - zebra_pen_holder_osize.z / 2 - zebra_pen_holder_dist_from_top;
  z = zebra_pen_holder_osize.y / 2;
  translate([ x, y, z ]) rotate([ 90, 0, 0 ]) union() {
    linear_extrude(zebra_pen_holder_isize.z, center = true) union() {
      shell2d(thickness = pen_holder_thickness) rect(zebra_pen_holder_isize, rounding = rounding);

      r = zebra_pen_holder_osize.x / 2;

      // quarter circle in the corner
      back(r - zebra_pen_holder_osize.y / 2) rotate([ 0, 0, 180 ]) difference() {
        square([ r, r ]);
        circle(r = r);
      }
    }

    // zebra_pen_holder_notch(rounding);
  }
}

module zebra_pen_cap() {
  t = pen_holder_thickness;
  h = zebra_pen_cap_height;
  id = zebra_pen_cap_diameter;
  od = zebra_pen_cap_diameter + t * 2;

  x = (container_size.x / 2 + od / 2 + zebra_pen_cap_distance);
  y = -container_size.y / 2 + h / 2;
  z = od / 2;

  translate([ x, y, z ]) rotate([ -90, 0, 0 ]) difference() {
    hull() {
      left(od / 2 + zebra_pen_cap_distance) back((od - container_size.z) / 2)
          cube([ thickness, container_size.z, h ], center = true);
      cylinder(h = h, d = od, center = true);
    }

    up(t / 2) cylinder(h = h - t + 0.1, d = id, center = true);
  }

  // !union() {
  //   down(h / 2) cylinder(h = pen_holder_thickness, d = od);
  //   tube(h = h, od = od, id = id);
  //
  //   // quarter circle in the top corner
  //   linear_extrude(h, center = true) difference() {
  //     left(od / 2) square([ od / 2, od / 2 ]);
  //     circle(d = od);
  //   }
  //
  //   // quarter circle in the bottom corner
  //   linear_extrude(h, center = true) difference() {
  //     fwd(od / 2) left(od / 2) square([ od / 2, od / 2 ]);
  //     circle(d = od);
  //   }

  // back(od / 4) right(od / 2 + zebra_pen_cap_diameter / 2)
  //     cube([ zebra_pen_cap_distance, od / 2, zebra_pen_cap_height ], center = true);
  //     }
}

// notch to prevent from shaking (not working well)
module zebra_pen_holder_notch(rounding) {
  notch_size_x = 1;
  notch_size_z = 2;
  size = [ pen_holder_thickness + notch_size_x, zebra_pen_holder_isize.y ];

  down(zebra_pen_holder_osize.z / 2 - notch_size_z / 2) linear_extrude(notch_size_z, center = true)
      left(zebra_pen_holder_osize.x / 2 - size.x / 2) #rect(
          size, rounding = [ 0, rounding, rounding, 0 ]);
}

module notepad_case() {
  difference() {
    container();
    notepad_mask();
    keychain_hole();
    thumb_mask();
    if (text_on_the_back != "") {
      text_on_the_back_mask();
    }
  }

  pen_holder();
}

module text_on_the_back_mask() {
  y = subtext_on_the_back != "" ? (text_on_the_back_size - subtext_on_the_back_size) : 0;

  back(y) down(0.1) linear_extrude(bottom_thickness + 0.2) offset(r = 1)
      mirror([ 1, 0, 0 ]) union() {
    text(text_on_the_back, halign = "center", valign = "center", size = text_on_the_back_size,
         font = text_on_the_back_font);

    if (subtext_on_the_back != "") {
      offset(r = -1) fwd(subtext_on_the_back_size * 1.4)
          text(subtext_on_the_back, halign = "center", valign = "center",
               font = text_on_the_back_font, size = subtext_on_the_back_size);
    }
  }
}

notepad_case();
