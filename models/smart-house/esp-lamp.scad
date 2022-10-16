include <./esp.scad>
include <./screws.scad>
include <BOSL2/std.scad>
include <BOSL2/threading.scad>
$fn = 64;

nothing = 0.01;

// leds_type = "ring";
leds_type = "bar";

// Base
base_od = 70;
base_height = 30;
// base_size = [ 60, 60, 30 ];
base_rounding = 4;
base_thickness = 1.5;
base_id = base_od - base_thickness * 2;
base_screw_center_dist_from_edge = 10;
base_screw_center_dist_from_center =
    base_od / 2 - base_screw_center_dist_from_edge;

nodemcu_feet_height = 5.5;

// Led Ring
led_ring_diameter = 26;
led_ring_height = 3;
led_ring_screw_hole_dist = 21;
led_ring_screw_hole_diameter = 1.9;

// Led Bar
led_bar_dist_to_screw = 14.9;
led_bar_size = [ 11, 3.2, 57.2 ];
led_bar_diffuser_height = 70;
led_bar_diffuser_rounding = base_rounding;

// The rod that connects the base to the sphere
connector_od = 30;
connector_thickness = 2;
connector_id = connector_od - connector_thickness * 2;
connector_hexagon_padding = 5;
connector_thread_height = 7;
connector_thread_pitch = 3;
connector_thread_tolerance = 0.8; // diameter-wise (includes both sides)
base_to_connector_tolerance = 0.4;

lamp_shade_diameter = 70;
lamp_shade_thickness = 2;

sphere_od = base_od;
sphere_thickness = 1.3;
sphere_id = sphere_od - sphere_thickness;
sphere_opening = connector_od + connector_thickness * 2; // TODO

bottom_lid_z_offset = base_height + base_thickness;
bottom_lid_usb_z_offset = nodemcu_feet_height + base_thickness - 2;

// lamp_base_thickness = 2;
// lamp_base_id = round(nodemcu_radius * 2.4);
// lamp_base_od = lamp_base_id + lamp_shade_thickness * 2;

// echo("Lamp base outer diameter: ", lamp_base_od);

module diffuser() {
  if (leds_type == "ring") {
    sphere_diffuser();
  } else if (leds_type == "bar") {
    tall_diffuser();
  }
}

module tall_diffuser() {
  connector_nut();

  r = led_bar_diffuser_rounding;
  up(connector_thread_height) rotate_extrude() difference() {
    rect([ sphere_opening / 2, led_bar_diffuser_height ],
         rounding = [ r, 0, 0, 0 ], anchor = LEFT + FWD);

    left(base_thickness) fwd(base_thickness)
        rect([ sphere_opening / 2, led_bar_diffuser_height ],
             rounding = [ r, 0, 0, 0 ], anchor = LEFT + FWD);
  }

  // tube(od = sphere_opening, id = connector_od, h = led_bar_diffuser_height,
  // anchor = BOTTOM);
}

module sphere_diffuser() {
  // Half sphere
  top_half() difference() {
    sphere(d = sphere_od);
    sphere(d = sphere_id);
  }

  // Bottom
  tube(od = sphere_od + nothing, id = sphere_opening, h = base_thickness,
       anchor = BOTTOM);

  // nut
  connector_nut();
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

  connector_nut();
}

// module lamp_shade() {
//   top_half() difference() {
//     sphere(d = lamp_shade_diameter);
//     sphere(d = lamp_shade_diameter - lamp_shade_thickness * 2);
//   }
// }

module base() {
  diff() {
    rotate_extrude() base_cut_2d();
    tag("remove") up(bottom_lid_usb_z_offset - nothing)
        down(bottom_lid_z_offset) nodemcu_usb_opening_mask(base_thickness * 20);
  }

  base_screw_tube(angle = 90);
  base_screw_tube(angle = -90);
}

module base_screw_tube(angle) {
  support = base_screw_center_dist_from_edge - base_thickness;
  h = base_height - base_thickness;

  down(h + base_thickness - nothing)
      screw_tube(h, support = support, support_rounding = [ 2, 0, 0, 0 ],
                 distance_from_center = base_screw_center_dist_from_center,
                 angle = angle, container_circle_diameter = base_od);
}

module base_cut_2d() {
  difference() {
    // outer part
    rect([ base_od / 2, base_height ], rounding = [ 0, base_rounding, 0, 0 ],
         anchor = BACK + RIGHT);

    // inner part
    right(nothing) fwd(base_thickness)
        rect([ base_id / 2 + nothing, base_height ],
             rounding = [ 0, base_rounding - 1, 0, 0 ], anchor = BACK + RIGHT);

    // hole for connector
    rect(
        [
          connector_od / 2 + base_to_connector_tolerance / 2,
          base_thickness * 2 +
          nothing
        ],
        anchor = RIGHT);
  }
}

module bottom_lid() {
  tolerance = 0.3;

  diff() {
    // Bottom plate
    cylinder(d = base_od, h = base_thickness, anchor = BOTTOM);

    // Border
    up(base_thickness - nothing)
        tube(od = base_id - tolerance * 2, wall = base_thickness, h = 5,
             anchor = BOTTOM);

    // Feet
    up(base_thickness - nothing) nodemcu_feet(nodemcu_feet_height);

    tag("remove") up(bottom_lid_usb_z_offset + nothing)
        nodemcu_usb_opening_mask(base_thickness * 20);
  }
}

module connector() {
  // hexagon and padding
  linear_extrude(base_thickness) difference() {
    hexagon(od = connector_od + connector_hexagon_padding * 2);
    circle(d = connector_id);
  }

  // border
  up(base_thickness - nothing) tube(od = connector_od, id = connector_id,
                                    h = base_thickness, anchor = BOTTOM);

  // thread
  connector_thread();

  // led ring screw nuts
  if (leds_type == "ring") {
    connector_led_ring_holders();
  } else if (leds_type == "bar") {
    connector_led_bar_holder();
  }
}

module connector_led_ring_holders() {
  connector_led_ring_right_holder();
  mirror([ 1, 0, 0 ]) connector_led_ring_right_holder();
}

module connector_led_bar_holder() {
  y = 3;
  z = connector_thread_height + led_bar_dist_to_screw;
  size_z = z + 3 * base_thickness;

  diff() {
    cube([ connector_od, y, base_thickness ], anchor = BOTTOM) {
      position(BACK + TOP) cube([ led_bar_size.x, base_thickness, size_z ],
                                anchor = BACK + BOTTOM) {
        // Sides
        position(LEFT + BOTTOM + BACK)
            cube([ base_thickness, y, size_z ], anchor = RIGHT + BOTTOM + BACK);
        position(RIGHT + BOTTOM + BACK)
            cube([ base_thickness, y, size_z ], anchor = LEFT + BOTTOM + BACK);

        // Screw hole
        screw_hole_size = [
          led_bar_size.x * 0.8, base_thickness * 3,
          led_ring_screw_hole_diameter
        ];
        tag("remove") up(z) position(BOTTOM) cuboid(
            screw_hole_size, rounding = base_thickness / 2, anchor = BOTTOM);
      };

      // Supports
      support_size = [
        (connector_od - led_bar_size.x - 4 * base_thickness) / 2,
        base_thickness,
        connector_thread_height
      ];
      support_x = base_thickness + connector_thread_tolerance;
      left(support_x) position(RIGHT + BOTTOM)
          cube(support_size, anchor = RIGHT + BOTTOM);
      right(support_x) position(LEFT + BOTTOM)
          cube(support_size, anchor = LEFT + BOTTOM);
    }
  }
}

module connector_thread() {
  up(base_thickness * 2 - nothing * 2) difference() {
    connector_threaded_rod();
    down(nothing / 2)
        cylinder(d = connector_id, h = connector_thread_height + nothing,
                 anchor = BOTTOM);
  }
}

module connector_nut() {
  tube(od = sphere_opening, id = connector_od, h = base_thickness,
       anchor = BOTTOM);
  up(base_thickness - nothing) difference() {
    cylinder(h = connector_thread_height - nothing, d = sphere_opening);
    down(nothing / 2) connector_threaded_rod(mask = true);
  }
}

module connector_threaded_rod(mask = false) {
  d = mask ? connector_od + connector_thread_tolerance : connector_od;
  threaded_rod(d = d, l = connector_thread_height,
               pitch = connector_thread_pitch, anchor = BOTTOM,
               internal = mask);
}

module connector_led_ring_right_holder() {
  x = led_ring_screw_hole_dist / 2 - led_ring_screw_hole_diameter / 2 -
      connector_thickness * 2;
  width = connector_od / 2 - x;
  height = led_ring_screw_hole_diameter + base_thickness * 4;

  // The lip that extrudes from sides of the connector bottom plate.
  linear_extrude(base_thickness) difference() {
    right(x) rect([ width, height ],
                  rounding = [ 0, height / 2, height / 2, 0 ], anchor = LEFT);
    right(led_ring_screw_hole_dist / 2)
        circle(d = led_ring_screw_hole_diameter);
  }

  tube_height = connector_thread_height - led_ring_height + base_thickness;
  // Tube into which to thread the screw.
  up(base_thickness) right(led_ring_screw_hole_dist / 2)
      tube(id = led_ring_screw_hole_diameter,
           od = led_ring_screw_hole_diameter + connector_thickness * 2,
           h = tube_height, anchor = BOTTOM);

  // Tube support
  support_x = led_ring_screw_hole_dist / 2 + led_ring_screw_hole_diameter;
  support_size = [
    connector_id / 2 - support_x,
    base_thickness,
    tube_height,
  ];
  right(support_x) up(base_thickness)
      cube(support_size, anchor = BOTTOM + LEFT);
}

module demo_all(space = 0) {
  up(space) diffuser();
  color("#ff6600aa") base();
  color("#0066ffaa") down(base_thickness * 2 + space) connector();
  color("#00ff99aa") down(bottom_lid_z_offset + space * 2) bottom_lid();
}

module demo_connector(space = 0) {
  color("#ff6600aa") up(space) connector_nut();
  color("#0066ffaa") down(base_thickness * 2 + space) connector();
}

module demo_base(space = 0) {
  up(base_height + space) base();

  z = nodemcu_feet_height + base_thickness - 2;
#up(z) mirror([ 0, 0, 1 ]) nodemcu(anchor = TOP);
#up(z) nodemcu_usb_opening_mask(base_thickness * 10);
  bottom_lid();
}

// demo_all(space = 0);
// demo_connector(space = 20);
// demo_base(space = 30);
base();
// bottom_lid();
// connector();
// connector_nut();
// diffuser();
// m3_washer();
// m3_nut_handle();
// screw_tube(h = 20);
