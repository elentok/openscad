include <BOSL2/std.scad>
$fn = 64;

finger_d1 = 17.5;
finger_d2 = 16;
h = 30;
band_width = 4;
wall_thickness = 1.5;

od1 = finger_d1 + wall_thickness * 2;
od2 = finger_d2 + wall_thickness * 2;

launcher();

module launcher() {
  tube(h = 35, od1 = od1, od2 = od2, id1 = finger_d1, id2 = finger_d2,
       anchor = TOP);

  difference() {
    top();
    scale([ 1, 1, 0.6 ]) sphere(d = finger_d2);
  }
}

module top() {
  difference() {
    top_half() sphere(d = od2);

    mask_h = od2 / 2;
    up(mask_h / 2) rotate([ 90, 0, 0 ]) linear_extrude(od2, center = true)
        trapezoid(h = mask_h, w1 = band_width, w2 = band_width * 2);
  }

  scale([ 1, 1, 0.6 ]) top_half() sphere(d = od2);
}
