include <BOSL2/std.scad>
$fn = 64;

nothing = 0.01;

saw_w1 = 32;
saw_w2 = 41;
saw_h = 125;
saw_thickness = 0.8;

wall_thickness = 3;
rounding = 3;

magnet_d = 8.2;
magnet_h = 1.7; // + 0.3 tolerance

cover_thickness = saw_thickness + wall_thickness * 2;
connector_tolerance = 0.2;

module saw_cover_bottom_half() {
  saw_cover_half();
  connectors();
}

module saw_cover_top_half() {
  difference() {
    saw_cover_half();
    connectors(connector_tolerance);
  }
}

module connectors(tolerance = 0) {
  fwd(saw_h + wall_thickness / 2) connector(tolerance);

  side_connector_angle = atan(saw_h / ((saw_w2 - saw_w1) / 2));

  fwd(saw_h / 4) left(saw_w2 / 2 + 0.3) rotate([ 0, 0, -side_connector_angle ])
      connector(tolerance);

  fwd(saw_h / 4) right(saw_w2 / 2 + 0.3) rotate([ 0, 0, side_connector_angle ])
      connector(tolerance);

  fwd(saw_h * 0.7) left(saw_w1 / 2 + 2.7)
      rotate([ 0, 0, -side_connector_angle ]) connector(tolerance);

  fwd(saw_h * 0.7) right(saw_w1 / 2 + 2.7)
      rotate([ 0, 0, side_connector_angle ]) connector(tolerance);
}

module saw_cover_half() {
  h = cover_thickness / 2;
  difference() {
    linear_extrude(h) trapezoid(
        h = saw_h + wall_thickness, w1 = saw_w1 + wall_thickness * 2,
        w2 = saw_w2 + wall_thickness * 2, anchor = BACK, rounding = rounding);

    // saw
    back(nothing) up(h - saw_thickness / 2 + nothing)
        linear_extrude(saw_thickness / 2)
            trapezoid(h = saw_h, w1 = saw_w1, w2 = saw_w2, anchor = BACK);

    up(h - saw_thickness / 2 - magnet_h + nothing * 2) union() {
      fwd(saw_h * 0.4) magnet_mask();
      fwd(saw_h * 0.6) magnet_mask();
      fwd(saw_h * 0.8) magnet_mask();
    }
  }
}

module magnet_mask() { cylinder(d = magnet_d, h = magnet_h); }

module connector(tolerance = 0) {
  size = [
    saw_w1 * 0.3 + tolerance,
    wall_thickness / 2 + tolerance,
    cover_thickness / 2 + tolerance,
  ];
  up(cover_thickness / 4) cube(size, anchor = BOTTOM);
}

module demo(spacing = 0) {
  saw_cover_bottom_half();

  % up(cover_thickness + spacing) mirror([ 0, 0, 1 ]) saw_cover_top_half();
}

saw_cover_bottom_half();
// saw_cover_top_half();
// demo();
