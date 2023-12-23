// vim: foldmethod=marker

include <BOSL2/std.scad>

$fn = 64;

nothing = 0.1;

// Alignment Pin {{{1

alignment_pin_size = [ 2, 4, 8 ];
alignment_pin_tolerance = 0.2;
alignment_pin_socket_size = add_scalar(alignment_pin_size, alignment_pin_tolerance);
