include <BOSL2/std.scad>
$fn = 64;

head_w = 60;
rnd = 1;

head_h = head_w * 0.8;

torso_h = head_h * 1.4;
torso_w = head_w * 0.7;

arm_w = head_w / 2.5;
arm_h = torso_h * 0.5;
arm_angle = 30;

leg_space = torso_w * 0.3;
leg_w = (torso_w - leg_space) / 2;
leg_h = torso_h * 0.6;

eye_w = head_w / 5;
eye_spacing = head_w / 4;
eye_h = head_h / 5;
eye_top_margin = head_h / 5;

buckle_w = torso_w / 4;
buckle_h = buckle_w * 0.8;

pencil_d = 1.5;

module minecraft_person() {
  difference() {
    union() {
      // head
      rect([ head_w, head_h ], rounding = rnd, anchor = FWD);

      // torso
      rect([ torso_w, torso_h ], anchor = BACK);

      arm();
      mirror([ 1, 0 ]) arm();

      // legs
      leg();
      mirror([ 1, 0 ]) leg();
    }

    // eyes
    eye();
    mirror([ 1, 0 ]) eye();

    belt();

    smile();
  }
}

module arm() {
  left(torso_w / 2) rotate(-arm_angle) right(arm_w / 2)
      rect([ arm_w, arm_h ], rounding = [ 0, 0, rnd, 0 ], anchor = BACK);

  fwd(arm_h * 1.1) left(torso_w / 1.7) circle(d = arm_w * 0.7);
}

module leg() {
  leg_x = leg_w / 2 + leg_space / 2;
  left(leg_x) fwd(torso_h)
      rect([ leg_w, leg_h ], rounding = [ 0, 0, rnd, rnd ], anchor = BACK);
}

module eye() {
  left(eye_spacing / 2) back(head_h - eye_top_margin)
      rect([ eye_w, eye_h ], anchor = BACK + RIGHT);
}

module belt() {
  margin = 3;
  margin_top = 1;
  line_w = (torso_w - buckle_w - margin * 4) / 2;
  fwd(torso_h * 0.8) {
    // buckle
    rect([ buckle_w, buckle_h ]);

    // belt lines
    belt_x = torso_w / 2 - line_w / 2 - margin;
    belt_y = buckle_h / 2 - pencil_d / 2 - margin_top;
    back(belt_y) {
      left(belt_x) rect([ line_w, pencil_d ]);
      right(belt_x) rect([ line_w, pencil_d ]);
    }
    fwd(belt_y) {
      left(belt_x) rect([ line_w, pencil_d ]);
      right(belt_x) rect([ line_w, pencil_d ]);
    }
  }
}

module smile() {
  w = head_w / 3;
  h = w / 2.7;
  back(h + head_w / 6)
      stroke(arc(points = [ [ -w / 2, 0 ], [ 0, -h ], [ w / 2, 0 ] ]),
             width = pencil_d);
}

linear_extrude(2) minecraft_person();
