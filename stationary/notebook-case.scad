include <BOSL2/std.scad>
use <../lib/thumb-mask.scad>
$fn = 64;

type = "fieldnotes";
// type = "traveler-regular";
// type = "a6";

notebook_thickness = 3.2;
notebooks = 3;
wall_thickness = 1.8;
tolerance = [ 1, 3, 3 ];
thumb_size = [ 20, 30 ];
rubberband_size = [ 2.5, 23 ];

notebook_size = type == "traveler-regular" ? [ 110, 210 ]
                : type == "fieldnotes"     ? [ 90, 140 ]
                                           : [ 105, 148 ];

connector_d = 4;
connector_l = 4;
connector_tolerance = 0.1;
// connectors = 4;

// to make space for the rubber band hole
side_thickness = rubberband_size.x + wall_thickness * 2;

case_inner_size = [
  notebook_size.x + tolerance.x,
  notebook_size.y + tolerance.y,
  notebooks* notebook_thickness + tolerance.z,
];

case_outer_size = [
  case_inner_size.x + wall_thickness + side_thickness,
  case_inner_size.y + wall_thickness * 2,
  case_inner_size.z + wall_thickness * 2,
];

echo("Inner size", case_inner_size);
echo("Outer size", case_outer_size);

// margins from the Y axis edges
rubberband_margin = 15;
rubberband_spacing =
    case_outer_size.y / 2 - rubberband_margin - rubberband_size.y * 1.5;
echo("Rubberband spacing", rubberband_spacing);

connectors = [
  case_outer_size.y / 2 - rubberband_margin / 2,
  rubberband_size.y / 2 + rubberband_spacing / 2,
];

module notebook_case() {
  difference() {
    cuboid(case_outer_size, rounding = wall_thickness, anchor = LEFT);
    right(wall_thickness + side_thickness + 0.01)
        cuboid(case_inner_size, anchor = LEFT);
    right(case_outer_size.x - thumb_size.x) rotate([ 0, 0, -90 ])
        thumb_mask([ thumb_size.y, thumb_size.x, case_outer_size.z + 0.01 ],
                   rounding = 10, anchor = FWD);

    rubberbands_mask();
    connectors_mask();
  };
}

module rubberbands_mask() {
  y = case_outer_size.y / 2 - rubberband_size.y / 2 - rubberband_margin;
  rubberband_hole_mask();
  back(y) rubberband_hole_mask();
  fwd(y) rubberband_hole_mask();
}

module rubberband_hole_mask() {
  right(wall_thickness * 2) cuboid(
      [ rubberband_size.x, rubberband_size.y, case_outer_size.z + 0.01 ]);
}

module connectors_mask() {
  for (i = [0:len(connectors) - 1]) {
    y = connectors[i];
    echo("Connector", i, y);

    // y = i * case_outer_size.y / connectors;
    // fwd(y) connector_mask();
    // back(y)
    fwd(y) connector_mask();
    back(y) connector_mask();
  }
}

module flexible_connectors_mask() {
  spacing = case_outer_size.y / (connectors + 1);

  if (connectors % 2 == 0) {
    for (i = [1:connectors / 2]) {
      y = (i - 0.5) * spacing;
      fwd(y) connector_mask();
      back(y) connector_mask();
    }
  } else {
    connector_mask();
    for (i = [1:(connectors - 1) / 2]) {
      y = i * spacing;
      fwd(y) connector_mask();
      back(y) connector_mask();
    }
  }
}

module connector_mask() {
  rotate([ 0, 90, 0 ]) down(0.01)
      cyl(d = connector_d, h = connector_l, anchor = BOTTOM);
}

notebook_case();
