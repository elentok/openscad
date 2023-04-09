include <BOSL2/std.scad>
$fn = 64;

epsilon = 0.01;
card_stack_size = [
  56.3,
  87,
  30,
];

card_border_radius = 5;
thumb_rounding = 5;

thumb_width = 25;

wall_thickness = 2;
cards_tolerance_xy = 4;
cards_tolerance_z = 6;
lid_tolerance = 1;

lid_text = "TAKI";
// lid_text_font = "Arial:style=Bold";
lid_text_font = "Arial Black:style=Bold";
lid_text_size = 14;

box_inner_size = [
  card_stack_size.x + cards_tolerance_xy,
  card_stack_size.y + cards_tolerance_xy,
  card_stack_size.z + cards_tolerance_z,
];

box_outer_size = [
  box_inner_size.x + wall_thickness * 2,
  box_inner_size.y + wall_thickness * 2,
  box_inner_size.z + wall_thickness,
];

lid_inner_size = add_scalar(box_outer_size, lid_tolerance);
lid_outer_size = [
  lid_inner_size.x + wall_thickness * 2,
  lid_inner_size.y + wall_thickness * 2,
  lid_inner_size.z + wall_thickness,
];

module box(inner_size = box_inner_size, outer_size = box_outer_size) {
  difference() {
    base_box(inner_size, outer_size);
    up(outer_size.z + epsilon) {
      thumb_rounded_corner_mask();
      mirror([ 1, 0, 0 ]) thumb_rounded_corner_mask();
    }
    down(epsilon) linear_extrude(wall_thickness / 2, convexity = 4)
        back(outer_size.y / 2) mirror([ 1, 0, 0 ])
            text(lid_text, halign = "center", valign = "center",
                 size = lid_text_size, font = lid_text_font);
  }
}

module base_box(inner_size, outer_size) {
  // floor
  linear_extrude(wall_thickness, convexity = 4)
      rect(outer_size, rounding = card_border_radius, anchor = FWD);

  // walls
  linear_extrude(outer_size.z, convexity = 4) {
    difference() {
      rect(outer_size, rounding = card_border_radius, anchor = FWD);
      back(wall_thickness)
          rect(inner_size, rounding = card_border_radius, anchor = FWD);
      rect([ thumb_width, wall_thickness ], anchor = FWD);
    }
  }
}

module thumb_rounded_corner_mask() {
  down(thumb_rounding) right(thumb_rounding + thumb_width / 2 - epsilon)
      back(wall_thickness + epsilon) rotate([ 90, 0, 0 ])
          linear_extrude(wall_thickness + epsilon * 2, convexity = 4)
              difference() {
    rect([ thumb_rounding, thumb_rounding ], anchor = RIGHT + FWD);
    circle(r = thumb_rounding);
  }
}

module lid() { box(lid_inner_size, lid_outer_size); }

module demo(spacing) {
  back(wall_thickness + lid_tolerance) box();
  up(lid_outer_size.z + spacing) rotate([ 0, 180, 0 ]) lid();
}

// thumb_rounded_corner_mask();
// box();
// lid();
demo((1 - $t) * 50);
