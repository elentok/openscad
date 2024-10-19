include <BOSL2/std.scad>
$fn = 64;

border_radius = 20;
owidth = 233;
odepth = 97;
joystick_height = 7;
joystick_tolerance = 1;

panel_thickness = 2;
sides_thickness = 3;

// grip
// grip_id = 3;
grip_thickness = 4;
grip_width = 20;
grip_band_space = 5;
grip_rounding = 3;
grip_edge_width = 2;
grip_margin = 38;

// calculated
iwidth = owidth - sides_thickness * 2;
idepth = odepth - sides_thickness * 2;
oheight = joystick_height + joystick_tolerance + panel_thickness;
iheight = oheight - panel_thickness;
grip_od = oheight;  // grip_id + grip_thickness * 2;
grip_id = grip_od - grip_thickness * 2;

grip_oh = oheight;
grip_ih = grip_oh - grip_thickness * 2;
grip_odepth = oheight * 1.5;
grip_idepth = grip_odepth - grip_thickness * 2;

grip_hook_radius = grip_rounding / 2;
grip_hook_d = (grip_oh - grip_id) / 2;
grip_hook_w = grip_width - grip_band_space * 2 + grip_rounding;
grip_hook_h = grip_hook_radius + grip_hook_d;

module cover() {
  // panel
  difference() {
    cuboid([ owidth, odepth, oheight ], rounding = oheight, except = BOTTOM,
           anchor = BOTTOM);

    down(0.01) cuboid([ iwidth, idepth, iheight ], rounding = iheight,
                      except = BOTTOM, anchor = BOTTOM);

    grips(is_mask = true);
  }

  grips(is_mask = false);
}

module grips(is_mask) {
  grip_y = odepth / 2 - grip_odepth / 2;
  grip_x = owidth / 2 - grip_margin;

  fwd(grip_y) {
    left(grip_x) grip(opening = 2, is_mask = is_mask);
    right(grip_x) grip(opening = 3, is_mask = is_mask);
  }

  mirror([ 0, 1, 0 ]) fwd(grip_y) {
    left(grip_x) grip(opening = 5, is_mask = is_mask);
    right(grip_x) grip(opening = 5, is_mask = is_mask);
  }
}

module grip(opening, is_mask = false) {
  difference() {
    up(grip_oh / 2) rotate([ 90, 0, 90 ]) linear_extrude(
        grip_width + (is_mask ? grip_edge_width * 2 : 0), convexity = 4,
        center = true) round2d(r = 1 / 2) difference() {
      rect([ grip_odepth, grip_oh ], rounding = [ 0, 0, 0, grip_oh / 4 ]);
      if (!is_mask) {
        rect([ grip_idepth, grip_ih ], rounding = [ 0, 0, 0, grip_id / 4 ]);
        rect([ opening, grip_odepth + 1 ], anchor = FWD);
      }
    }

    if (!is_mask) {
      fwd(0.01) left(grip_width / 2 + 0.01) up(grip_oh + 0.01)
          cuboid([ grip_width + 0.02, grip_odepth / 2, grip_oh / 2 ],
                 anchor = TOP + BACK + LEFT);
      // fwd(0.01) left(grip_width / 2 + 0.01) up(grip_oh + 0.01)
      //     cuboid([ grip_band_space, grip_odepth / 2, grip_oh / 2 ],
      //            anchor = TOP + BACK + LEFT);

      // fwd(0.01) right(grip_width / 2 + 0.01) up(grip_oh + 0.01)
      //     cuboid([ grip_band_space, grip_odepth / 2, grip_oh / 2 ],
      //            anchor = TOP + BACK + RIGHT);
    }
  }

  fwd(grip_thickness / 2) up(grip_oh - grip_hook_h) grip_hook();

  // up(grip_oh / 2) linear_extrude(grip_oh / 2) fwd(grip_odepth / 2) rect(
  //     [
  //       grip_width - grip_band_space * 2 + grip_rounding,
  //       (grip_oh - grip_id) / 2
  //     ],
  //     rounding = grip_rounding / 2, anchor = FWD);

  left(grip_width / 2 + grip_edge_width / 2) grip_edge();
  right(grip_width / 2 + grip_edge_width / 2) grip_edge();
}

module grip_edge() {
  up(grip_oh / 2) rotate([ 0, 90, 0 ])
      linear_extrude(grip_edge_width, center = true) round2d(r = 1 / 3)
          rect([ grip_oh, grip_odepth ],
               rounding = [ grip_oh / 4, 0, grip_oh / 2, 0 ]);
}

module grip_hook() {
  mirror([ 0, 1, 0 ]) union() {
    rotate([ 90, 0, 90 ]) rotate_extrude(angle = 90) right(grip_hook_radius)
        rect(
            [
              grip_hook_d,
              grip_hook_w,
            ],
            anchor = LEFT, rounding = grip_rounding / 2);

    up(grip_hook_d / 2 + grip_hook_radius) rotate([ 0, 0, 90 ])
        cuboid([ grip_hook_d / 2, grip_hook_w, grip_hook_d ],
               rounding = grip_rounding / 2, except = RIGHT, anchor = RIGHT);
  }
}

// grip_hook();

grip(opening = 3);

// cover();
