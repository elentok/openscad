include <../../lib/screw-hole-mask.scad>
include <BOSL2/screws.scad>
include <BOSL2/std.scad>
$fn = 64;

epsilon = 0.01;
plate_size = [ 80, 23, 3 ];
screw_hole_isize = [ 20, 4.2 ];
screw_hole_osize = [ 25, 10 ];
screw_hole_padding = 5;

tripod_screw_spec = "1/4-20";
tripod_screw_h = 7;
inner_screw_spec = "M3";
inner_screw_hole_d = 3.2;
inner_screw_head_h = 1.8;
inner_screw_head_d = 7;

module plate() {
  difference() {
    linear_extrude(plate_size.z) {
      rect([ plate_size.x, plate_size.y ], rounding = plate_size.y / 2);
    }

    mount_hole_x =
        plate_size.x / 2 - screw_hole_isize.x / 2 - screw_hole_padding;
    left(mount_hole_x) plate_mount_hole_mask();
    right(mount_hole_x) plate_mount_hole_mask();

    down(epsilon / 2) cyl(d = inner_screw_hole_d, h = plate_size.z + epsilon,
                          anchor = BOTTOM);
    down(epsilon / 2) cyl(d = inner_screw_head_d,
                          h = inner_screw_head_h + epsilon, anchor = BOTTOM);
  }
}

module plate_mount_hole_mask() {
  down(epsilon / 2)
      prismoid(h = plate_size.z / 2 + epsilon, size1 = screw_hole_isize,
               rounding = screw_hole_isize.y / 2, size2 = screw_hole_isize);

  up(plate_size.z / 2 - epsilon / 2)
      prismoid(h = plate_size.z / 2 + epsilon, size1 = screw_hole_isize,
               rounding1 = screw_hole_isize.y / 2,
               rounding2 = screw_hole_osize.y / 2, size2 = screw_hole_osize);
}

module tripod_screw() {
  difference() {
    screw(tripod_screw_spec, l = tripod_screw_h, anchor = BOTTOM,
          bevel1 = false, blunt_start1 = false);
    down(epsilon / 2)
        screw_hole(inner_screw_spec, l = tripod_screw_h + epsilon,
                   anchor = BOTTOM, bevel1 = false, thread = true);
  }
}

plate();
up(plate_size.z - epsilon) tripod_screw();
