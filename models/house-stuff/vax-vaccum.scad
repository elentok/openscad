$fn = 60;

include <BOSL2/std.scad>

tolerance = 0.2;
small_connector_outer_d1 = 31.9;
small_connector_outer_d2 = 31.1;
small_connector_h = 36;
thickness = 2;

hose_h = 20;

tool_connector_outer_d1 = small_connector_outer_d1 + thickness * 2 + tolerance;
tool_connector_outer_d2 = small_connector_outer_d2 + thickness * 2 + tolerance;
tool_connector_h = small_connector_h;

large_connector_inner_d1 = 34;
large_connector_inner_d2 = 32.2;
large_connector_h = 40;

large_connector_outer_d1 = large_connector_inner_d1 + thickness * 2;
large_connector_outer_d2 = large_connector_inner_d2 + thickness * 2;

rail_cleaner_height = 110;
rail_cleaner_top_width = 9;
rail_cleaner_side_diameter = 50;

module large_connector() {
  up(large_connector_h / 2) cylinder_shell(h = large_connector_h, d1 = large_connector_outer_d1,
                                           d2 = large_connector_outer_d2, thickness = thickness);
}

module small_connector() {
  up(small_connector_h / 2) cylinder_shell(h = small_connector_h, d1 = small_connector_outer_d1,
                                           d2 = small_connector_outer_d2, thickness = thickness);
}

module hose() {
  up(hose_h / 2) cylinder_shell(h = hose_h, d1 = large_connector_outer_d2,
                                d2 = small_connector_outer_d1, thickness = thickness);
}

module cylinder_shell(h, d1, d2, thickness) {
  difference() {
    cylinder(h = h, d1 = d1, d2 = d2, center = true);
    cylinder(h = h + 0.2, d1 = d1 - thickness * 2, d2 = d2 - thickness * 2, center = true);
  }
}

module adapter() {
  large_connector();
  up(large_connector_h) union() {
    hose();
    up(hose_h) small_connector();
  }
}

module tool_connector() {
  up(tool_connector_h / 2) cylinder_shell(h = tool_connector_h, d1 = tool_connector_outer_d1,
                                          d2 = tool_connector_outer_d2, thickness = thickness);
}

module rail_cleaner_tool() {
  difference() {
    rail_cleaner_tool1();
    rail_cleaner_tool1(offset = 2);
  }
}

module rail_cleaner_tool1(offset = 0) {
  x = rail_cleaner_side_diameter / 2 + rail_cleaner_top_width / 2 - offset;
  down(offset / 2) difference() {
    cylinder(d = tool_connector_outer_d2 - offset * 2, h = rail_cleaner_height);

    down(offset) {
      right(x) rail_cleaner_tool_side_mask();
      left(x) rail_cleaner_tool_side_mask();
    }
    up(offset) rail_cleaner_tool_top_mask();
  }
}

module rail_cleaner_tool_side_mask() {
  y = tool_connector_outer_d2 + 10;
  up(rail_cleaner_side_diameter) union() {
    rotate([ 90, 0, 0 ]) cylinder(d = rail_cleaner_side_diameter, h = y, center = true);
    up(rail_cleaner_height / 2 + 0.1)
        cube([ rail_cleaner_side_diameter, y, rail_cleaner_height ], center = true);
  }
}

module rail_cleaner_tool_top_mask() {
  up(rail_cleaner_height) fwd(5) rotate([ 45, 0, 0 ])
      cube([ rail_cleaner_top_width + 0.2, tool_connector_outer_d2 * 2, tool_connector_outer_d2 ],
           center = true);
}

// adapter();
rail_cleaner_tool();
// up(100) cube([ 10, 20, 20 ], center = true);
