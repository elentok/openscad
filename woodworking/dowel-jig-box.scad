include <BOSL2/std.scad>
$fn = 64;

spacer_height = 14;

holder_size = [197, 82, 12];

module pin_mask(d1, d2 = 0, h1, h2 = 0) {
  rotate([-90, 0, 0]) {
    cyl(d=d1, h=h1, anchor=TOP);
    cuboid([d1, d1 / 2, h1], anchor=TOP + BACK);
    if (d2 > 0) {
      down(0.01) {
        cyl(d=d2, h=h2, anchor=BOTTOM);
        cuboid([d2, d2 / 2, h2], anchor=BOTTOM + BACK);
      }
    }
  }
}

module small_thread() {
  pin_mask(d1=14.5, d2=16.5, h1=10, h2=21);
}

module large_thread() {
  pin_mask(d1=18.5, d2=20.5, h1=15, h2=16);
}

module plate_connector() {
  pin_mask(d1=8.5, d2=16.5, h1=23, h2=21);
}

module holder() {
  spacer();
  right(holder_size.x) mirror([1, 0, 0]) spacer();
  right(holder_size.x) fwd(82) mirror([1, -1, 0]) spacer();
  fwd(holder_size.y) mirror([0, 1, 0]) spacer();

  middle_spacer();

  difference() {
    cuboid(holder_size, anchor=TOP + LEFT + BACK, rounding=1);

    right(54.7) fwd(15) rotate([0, 0, -90]) drillbit_8mm();

    right(15.2) fwd(33) rotate([0, 0, 90]) stop_pin();

    right(13) fwd(65) {
        small_thread();
        right(20) small_thread();
        right(40) small_thread();
        right(60) small_thread();
        right(80) small_thread();
      }

    right(114) fwd(60) {
        large_thread();
        right(23) large_thread();
      }

    fwd(52) right(163) {
        plate_connector();
        right(20) plate_connector();
      }

    right(129.7) fwd(15) {
        drillbit_stop();
        right(16) drillbit_stop();
        right(32) drillbit_stop();
        right(48) drillbit_stop();
      }

    right(115) fwd(35)
        rotate([0, 0, 90]) plastic_dowel();
  }
}

module stop_pin() {
  pin_mask(d1=8.5, d2=15.5, h1=51, h2=10.5);
}

module plastic_dowel() {
  pin_mask(d1=8.5, h1=36);
}

module drillbit_stop() {
  rotate([0, 0, 90]) pin_mask(d1=20.5, h1=13.5);
}

module drillbit_8mm() {
  pin_mask(d1=8.5, h1=50, d2=20.5, h2=68);
}

module spacer() {
  down(3) {
    cuboid([10, 4, spacer_height + 3], anchor=BOTTOM + LEFT + BACK, rounding=1, except=BOTTOM);
    cuboid([4, 10, spacer_height + 3], anchor=BOTTOM + LEFT + BACK, rounding=1, except=BOTTOM);
  }
}

module middle_spacer() {
  fwd(holder_size.y / 2 - 5)
    right(holder_size.x / 2 - 7)
      cuboid([30, 10, spacer_height], anchor=BOTTOM, rounding=1, except=BOTTOM);
}

holder();
