include <BOSL2/std.scad>
include <BOSL2/threading.scad>
$fn = 64;

nothing = 0.01;

led_ring_diameter = 26;
led_ring_height = 3;
led_ring_screw_hole_dist = 21;
led_ring_screw_hole_diameter = 1.9;

base_od = 80;
base_height = 30;
// base_size = [ 60, 60, 30 ];
base_rounding = 4;
base_thickness = 1.5;
base_id = base_od - base_thickness * 2;

// The rod that connects the base to the sphere
connector_od = 30;
connector_id = connector_od - base_thickness * 2;
connector_hexagon_padding = 5;
connector_thread_height = 8;
connector_thread_pitch = 2;
connector_thread_tolerance = 0.6;  // diameter-wise (includes both sides)
base_to_connector_tolerance = 0.2;

nodemcu_size = [ 50, 26, 30 ];
// nodemcu_radius^2 = (x/2)^2 + (y/2)^2
nodemcu_radius = sqrt((nodemcu_size.x / 2) ^ 2 + (nodemcu_size.y / 2) ^ 2);

lamp_shade_diameter = 70;
lamp_shade_thickness = 2;

sphere_od = base_od;
sphere_thickness = 1.3;
sphere_id = sphere_od - sphere_thickness;
sphere_opening = connector_od + base_thickness * 2;  // TODO

// lamp_base_thickness = 2;
// lamp_base_id = round(nodemcu_radius * 2.4);
// lamp_base_od = lamp_base_id + lamp_shade_thickness * 2;

// echo("Lamp base outer diameter: ", lamp_base_od);

module diffuser() {
  // Half sphere
  top_half() difference() {
    sphere(d = sphere_od);
    sphere(d = sphere_id);
  }

  // Bottom
  tube(od = sphere_od + nothing, id = sphere_opening, h = base_thickness, anchor = BOTTOM);

  // nut
  difference() {
    cylinder(h = connector_thread_height - nothing, d = sphere_opening);
    down(nothing / 2) connector_threaded_rod(mask = true);
  }
}

module diffuser_mark1() {
  // o = sphere_opening / 2;
  // r = h_keep + h_cut
  // r^2 = h_keep^2 + o^2
  //
  // => h_keep = sqrt(r^2 - o^2);
  // => h_cut = r - h_keep
  //          = r - sqrt(r^2 - o^2)
  o = sphere_opening / 2;
  r = sphere_od / 2;
  h_keep = sqrt(r ^ 2 - o ^ 2);
  h_cut = r - h_keep;

  down(h_cut) difference() {
    sphere(d = sphere_od, anchor = BOTTOM);
    sphere(d = sphere_id, anchor = BOTTOM);
    cube([ sphere_od, sphere_od, h_cut + nothing ], anchor = BOTTOM);
  }

  // nut
  difference() {
    cylinder(h = connector_thread_height - nothing, d = sphere_opening);
    down(nothing / 2) connector_threaded_rod(mask = true);
  }
}

// module lamp_shade() {
//   top_half() difference() {
//     sphere(d = lamp_shade_diameter);
//     sphere(d = lamp_shade_diameter - lamp_shade_thickness * 2);
//   }
// }

module base() { rotate_extrude() base_cut_2d(); }

module base_cut_2d() {
  difference() {
    // outer part
    rect([ base_od / 2, base_height ], rounding = [ 0, base_rounding, 0, 0 ],
         anchor = BACK + RIGHT);

    // inner part
    right(nothing) fwd(base_thickness)
        rect([ base_id / 2 + nothing, base_height ], rounding = [ 0, base_rounding - 1, 0, 0 ],
             anchor = BACK + RIGHT);

    // hole for connector
    rect([ connector_od / 2 + base_to_connector_tolerance / 2, base_thickness * 2 + nothing ],
         anchor = RIGHT);
  }
}

module bottom_lid() {
  tolerance = 0.2;
  cylinder(d = base_od, h = base_thickness, anchor = BOTTOM);
  up(base_thickness - nothing)
      tube(od = base_id - tolerance * 2, wall = base_thickness, h = 5, anchor = BOTTOM);
}

module connector() {
  // hexagon and padding
  linear_extrude(base_thickness) difference() {
    hexagon(od = connector_od + connector_hexagon_padding * 2);
    circle(d = connector_id);
  }

  // border
  up(base_thickness - nothing)
      tube(od = connector_od, id = connector_id, h = base_thickness, anchor = BOTTOM);

  // thread
  up(base_thickness * 2 - nothing * 2) difference() {
    connector_threaded_rod();
    down(nothing / 2)
        cylinder(d = connector_id, h = connector_thread_height + nothing, anchor = BOTTOM);
  }

  // led ring screw nuts
  connector_led_ring_right_holder();
  mirror([ 1, 0, 0 ]) connector_led_ring_right_holder();
}

module connector_threaded_rod(mask = false) {
  d = mask ? connector_od + connector_thread_tolerance : connector_od;
  threaded_rod(d = connector_od, l = connector_thread_height, pitch = connector_thread_pitch,
               anchor = BOTTOM, internal = mask);
}

module connector_led_ring_right_holder() {
  x = led_ring_screw_hole_dist / 2 - led_ring_screw_hole_diameter / 2 - base_thickness * 2;
  width = connector_od / 2 - x;
  height = led_ring_screw_hole_diameter + base_thickness * 4;

  // The lip that extrudes from sides of the connector bottom plate.
  linear_extrude(base_thickness) difference() {
    right(x) rect([ width, height ], rounding = [ 0, height / 2, height / 2, 0 ], anchor = LEFT);
    right(led_ring_screw_hole_dist / 2) circle(d = led_ring_screw_hole_diameter);
  }

  tube_height = connector_thread_height - led_ring_height + base_thickness;
  // Tube into which to thread the screw.
  up(base_thickness) right(led_ring_screw_hole_dist / 2) tube(
      id = led_ring_screw_hole_diameter, od = led_ring_screw_hole_diameter + base_thickness * 2,
      h = tube_height, anchor = BOTTOM);

  // Tube support
  support_x = led_ring_screw_hole_dist / 2 + led_ring_screw_hole_diameter;
  support_size = [
    connector_id / 2 - support_x,
    base_thickness,
    tube_height,
  ];
  right(support_x) up(base_thickness) cube(support_size, anchor = BOTTOM + LEFT);
}

module all() {
  space = 0;
  up(space) diffuser();
  color("#ff6600aa") base();
  color("#0066ffaa") down(base_thickness * 2 + space) connector();
  color("#00ff99aa") down(base_height + base_thickness + space * 2) bottom_lid();
}

// all();
// base();
// bottom_lid();
// connector();
diffuser();
