
include <BOSL2/std.scad>

$fn = 60;

// Variables

monitor_thickness = 18.6;  //  includes 0.4mm margin
monitor_top_padding = 7.5;
headphone_thickness = 60;  // includes 20mm margin;
headphone_diameter = 120;
holder_thickness = 5;
holder_width = 40;
holder_height = 40;
holder_back_height = 30;
tolerance = 0.2;

// Grip

module grip() {
  grip_path = [
    [ -headphone_thickness - holder_thickness, holder_back_height ],
    [ -headphone_thickness - holder_thickness, 0 ],
    [ 0, 0 ],
    [ 0, holder_height ],
    [ monitor_thickness + holder_thickness, holder_height ],
    [ monitor_thickness + holder_thickness, holder_height - monitor_top_padding ],
  ];

  grip_supports_path = [
    [ 0, 0 ],
    [ -headphone_thickness / 2, 0 ],
    [ 0, -headphone_thickness / 2 ],
    [ 0, 0 ],
  ];

  linear_extrude(holder_width) union() {
    stroke(grip_path, width = holder_thickness);
    stroke(grip_supports_path, width = holder_thickness);
  }
}

// Curved Stand

module curved_stand() {
  linear_extrude(headphone_thickness - tolerance) diff("outer-remove") {
    round2d(3) diff() circle(d = headphone_diameter) {
      tag("remove") attach(FRONT, FRONT) fwd(headphone_diameter * 0.85)
          square([ headphone_diameter, headphone_diameter * 0.85 ]);

      tag("remove") circle(d = headphone_diameter - 15);
    };

    tag("outer-remove") square([ holder_width, headphone_diameter - 14 ], anchor = [ 0, 0 ]);
  }
}

grip();
curved_stand();
