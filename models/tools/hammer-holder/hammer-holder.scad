include <BOSL2/std.scad>
// include <../../lib/chamfer.scad>
$fn = 64;

// This model allows hanging a hammer from the bottom of a shelf

epsilon = 0.01;

// The size required so the hammer's handle will fit.
handle_width = 42;
handle_height = 45;

bottom_thickness = 8;
inner_triangle_width = 5;
outer_triangle_width = 20;

rounding = 2;

screw_diameter = 4;
screw_head_diameter = 8;
screw_head_height = 3.5;
// The height of the part of the screw's body that's inside the handle screw
// hole.
screw_body_height_in_handle = 9;

holder_depth = 25;
holder_height = handle_height + bottom_thickness;

echo(holder_height = holder_height);

module holder() {
  difference() {
    linear_extrude(holder_depth, convexity = 4, center = true)
        holder_section_2d();

    x = handle_width / 2 + (inner_triangle_width + outer_triangle_width) / 2;
    left(x) screw_hole_mask();
    right(x) screw_hole_mask();
  }
}

module screw_hole_mask() {
  rotate([ -90, 0, 0 ])
      cylinder(d = screw_diameter, h = holder_height + epsilon);

  rotate([ -90, 0, 0 ]) cylinder(
      d = screw_head_diameter, h = holder_height - screw_body_height_in_handle);
}

module holder_section_2d() {
  holder_section_half_2d();
  mirror([ 1, 0 ]) holder_section_half_2d();
}

module holder_section_half_2d() {
  round2d(r = rounding) {
    // this is added to avoid rounding the connection between the two halves.
    rect([ rounding * 2, bottom_thickness ], anchor = RIGHT + FWD);

    rect([ handle_width / 2 + inner_triangle_width, bottom_thickness ],
         anchor = LEFT + FWD);

    back(bottom_thickness) right(handle_width / 2 + inner_triangle_width)
        mirror([ 1, 0 ])
            right_triangle([ inner_triangle_width, handle_height ]);

    right(handle_width / 2 + inner_triangle_width) back(holder_height)
        mirror([ 0, 1 ])
            right_triangle([ outer_triangle_width, holder_height ]);
  }
}

holder();
