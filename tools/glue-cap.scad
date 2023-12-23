include <BOSL2/std.scad>
$fn = 64;

thickness = 1.5;
diameter = 28.1;
height = 14;
axis_w = 13.5;
axis_depth = 1.5;

od = diameter + thickness * 2;

difference() {
  cyl(d = od, h = height, rounding2 = thickness, anchor = BOTTOM);
  down(0.01) cyl(d = diameter, h = height - thickness,
                 rounding2 = thickness * 2, anchor = BOTTOM);

  down(0.01) cuboid([ axis_w, axis_depth + od / 2, height - thickness * 3 ],
                    anchor = BACK + BOTTOM);
}
