include <BOSL2/std.scad>
$fn = 64;

ih = 18;
id1 = 7.6;
angle = 4.65;
id2 = (id1 / 2 - tan(angle) * ih) * 2;
echo("id2", id2);

thickness = 1;

oh = ih + thickness;
od1 = id1 + thickness * 2;
od2 = id2 + thickness * 2;

// h1 = 9;
// h2 = 8.7;
// h3 = 3.3;

// w1 = 4.6;
// w2 = 7.5;
// w3 = 9.9;

// side_thickness = 1;
// bottom_thickness = 1;

// total_h = h1 + h2 + h3 + bottom_thickness;
// total_w = w3 + side_thickness * 2;

module cap() {
  difference() {
    cyl(d1 = od1, d2 = od2, h = oh, rounding2 = 1, rounding1 = 0.5,
        anchor = BOTTOM);
    down(0.01) cyl(d1 = id1, d2 = id2, h = ih, rounding2 = 1, anchor = BOTTOM);
    // cuboid([ total_w, total_w, total_h ], rounding = 1.4, anchor = BOTTOM);

    // down(0.01) cyl(d = w3, h = h3, anchor = BOTTOM);
    // down(0.02) up(h3) cyl(d = w2, h = h2, anchor = BOTTOM);
    // down(0.03) up(h2 + h3) cyl(d = w1, h = h1, anchor = BOTTOM);

    // down(0.03) up(h1 + h2 + h3)
    //     cyl(d = w3 * 0.8, h = bottom_thickness, anchor = BOTTOM);
  }
  // linear_extrude(total_h) rect([ total_w, total_w ], rounding = total_w / 4);
}

// module test_print() {
//   intersection() {
//     up(total_h) mirror([ 0, 0, -1 ]) cap();
//     up(bottom_thickness + 0.04)
//         cuboid([ total_w * 1.5, total_w * 1.5, h1 + h2 / 2 ], anchor =
//         BOTTOM);
//   }
// }

// test_print();
cap();
