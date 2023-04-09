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

module box() {
  difference() {
    base_box();
    up(box_outer_size.z + epsilon) {
      thumb_rounded_corner_mask();
      mirror([ 1, 0, 0 ]) thumb_rounded_corner_mask();
    }
    down(epsilon) linear_extrude(wall_thickness / 2) back(box_outer_size.y / 2)
        mirror([ 1, 0, 0 ]) text(lid_text, halign = "center", valign = "center",
                                 size = lid_text_size, font = lid_text_font);
  }
}

module base_box() {
  // floor
  linear_extrude(wall_thickness)
      rect(box_outer_size, rounding = card_border_radius, anchor = FWD);

  // walls
  linear_extrude(box_outer_size.z) {
    difference() {
      rect(box_outer_size, rounding = card_border_radius, anchor = FWD);
      back(wall_thickness)
          rect(box_inner_size, rounding = card_border_radius, anchor = FWD);
      rect([ thumb_width, wall_thickness ], anchor = FWD);
    }
  }
}

module thumb_rounded_corner_mask() {
  down(thumb_rounding) right(thumb_rounding + thumb_width / 2 - epsilon)
      back(wall_thickness + epsilon) rotate([ 90, 0, 0 ])
          linear_extrude(wall_thickness + epsilon * 2) difference() {
    rect([ thumb_rounding, thumb_rounding ], anchor = RIGHT + FWD);
    circle(r = thumb_rounding);
  }
}

// thumb_rounded_corner_mask();
box();
