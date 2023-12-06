// vim: foldmethod=marker

epsilon = 0.01;

// Bolt {{{1
bolt = "M5";
bolt_hole_d = 5.1;
bolt_h_with_head = 19;
bolt_head_h = 3.5;
bolt_head_d = 9.4;

// Nut (with tolerances) {{{1
nut_d = 9;
nut_w = 7.8;
nut_h = 4;

// Case {{{1
mid_layer_h = 12.8;
case_left_depth = 104.5;

// Bolt Holder {{{1
bolt_holder_size = [ 15, 12, mid_layer_h - bolt_head_h ];
bolt_holder_tolerance = 0.2;
// bolt_holder_d = 12;
// bolt_holder_h = mid_layer_h - bolt_head_h;

// Bolts {{{1
// Center of the bolts
bolt_b1 = [ 60, -bolt_holder_size.y / 2 ];          // 60
bolt_b2 = [ 18, -bolt_holder_size.y / 2 ];          // 22
bolt_b3 = [ 100, -22.9 - bolt_holder_size.y / 2 ];  // 22
bolt_b3_angle = -15;
bolt_b4 = [ 136.3, -31 ];

// Asserts {{{1
assert(bolt_holder_size.x > bolt_head_d,
       "bolt_holder_size.x must be wider than the bolt head");
assert(bolt_holder_size.y > bolt_head_d,
       "bolt_holder_size.y must be wider than the bolt head");
