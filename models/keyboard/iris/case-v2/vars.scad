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

// Bolt Holder {{{1
bolt_holder_d = 12;
bolt_holder_h = mid_layer_h - bolt_head_h;

// Bolts {{{1
// Center of the bolts
bolt_bl = [ 60, -bolt_holder_d / 2 ];  // 60
bolt_br = [ 20, -bolt_holder_d / 2 ];  // 22

// Asserts {{{1
assert(bolt_holder_d > bolt_head_d, "Bolt holder must be wider than the bolt
head");
