include <BOSL2/std.scad>
include <BOSL2/threading.scad>
$fn = 64;

nothing = 0.01;

test_thread = false;

// m8 screw
screw_diameter = 8;
screw_pitch = 1.25;
screw_head_height = test_thread ? 1 : 7.5;
screw_head_diameter = 11.7;

dog_diameter = 19;
dog_top_diameter = 28;
dog_height = test_thread ? 4 : 52;
dog_top_height = test_thread ? 2 : 8;
dog_top_offset = 0.5;

support_height = 0.25;
supports_height = 3 * support_height;

module bench_dog() {
  diff() {
    bench_dog_top();

    // body
    cylinder(d = dog_diameter, h = dog_height);

    tag("remove") bench_dog_thread();
    tag("remove") screw_head();
  }

  up(screw_head_height) supports();
}

module bench_dog_top() {
  linear_extrude(dog_top_height) intersection() {
    circle(d = dog_top_diameter);

    y = (dog_top_diameter - dog_diameter) / 2 - dog_top_offset;
    back(y) rect([ dog_top_diameter, dog_top_diameter ]);
  }
}

module bench_dog_thread() {
  down(nothing / 2)
      threaded_rod(d = screw_diameter, pitch = screw_pitch,
                   l = dog_height + nothing, anchor = BOTTOM, internal = true);
}

module screw_head() {
  down(nothing) cylinder(d = screw_head_diameter,
                         h = screw_head_height + 3 * support_height + nothing);
}

module supports() {
  side_supports(levels = 3);
  rotate([ 0, 0, 90 ]) up(support_height) side_supports(levels = 2);
  up(support_height * 2) tube(od = screw_head_diameter, id = screw_diameter,
                              h = support_height, anchor = BOTTOM);
}

module side_supports(levels) {
  support(levels);
  rotate([ 0, 0, 180 ]) support(levels);
}

module support(levels) {
  size = [
    screw_head_diameter, (screw_head_diameter - screw_diameter) / 2,
    support_height *
    levels
  ];

  fwd(screw_head_diameter / 2 - size.y) cube(size, anchor = BACK + BOTTOM);
}

bench_dog();
// supports();
