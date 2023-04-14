include <BOSL2/std.scad>
$fn = 64;

money_size = [ 46.3, 92.4 ];
card_size = [ 44.6, 76.3 ];
coin_diameter = 19.4;
dozen_coins_thickness = 16.5;
wall_thickness = 1.7;
rounding = 3;

coin_tolerance = 2;
money_tolerance = 2;
money_stack_thickness = 8;

coin_od = coin_diameter + coin_tolerance;
coin_opening_width = 10;

base_connector_height = 10;
base_connector_width = 25;
base_tolerance = 0.1;

// for some reason when the lid diameter matches the hole diameter
// it's still loose so I need a negative tolerance.
lid_tolerance = -0.2;
lid_top_height = 2;
lid_bottom_height = 5;

player_box_size = [
  // x:
  wall_thickness * 3 + coin_od + money_size.x + money_tolerance,

  // y:
  coin_od + wall_thickness * 2,

  // z:
  45,
];

echo("PLAYER BOX SIZE:", player_box_size);

module player_box() {
  // floor
  linear_extrude(wall_thickness, convexity = 4)
      rect(player_box_size, rounding = rounding);

  linear_extrude(player_box_size.z, convexity = 4) diff() {
    rect(player_box_size, rounding = rounding) {
      tag("remove") left(wall_thickness) position(RIGHT) money_mask();
      tag("remove") left(player_box_size.x / 2 - coin_od / 2 - wall_thickness)
          coin_mask();
    }
  }
}

module coin_mask() {
  round2d(ir = rounding) union() {
    circle(d = coin_od);
    rect([ coin_opening_width, player_box_size.y / 2 ], anchor = BACK);
    fwd(player_box_size.y / 2) rect([ coin_od, wall_thickness ], anchor = BACK);
  }
}

module money_mask() {
  rect(
      [
        money_size.x + money_tolerance, money_stack_thickness + money_tolerance
      ],
      anchor = RIGHT);
}

module player_box_base() {
  cylinder(d = player_box_size.x + 5, h = wall_thickness, anchor = TOP);

  fwd(player_box_size.y / 2 + base_tolerance) player_box_base_connector();
  back(player_box_size.y / 2 + base_tolerance) mirror([ 0, 1, 0 ])
      player_box_base_connector();
}

module player_box_base_connector() {
  h = base_connector_height;
  rotate([ 0, -90, 0 ]) linear_extrude(base_connector_width, convexity = 4,
                                       center = true) intersection() {
    circle(r = h);
    rect([ h, h ], anchor = LEFT + BACK);
  }
}

module lid() {
  cylinder(d = coin_od + wall_thickness * 2, h = lid_top_height);

  up(lid_top_height)
      tube(od = coin_od - lid_tolerance, id = coin_od - wall_thickness,
           h = lid_bottom_height, anchor = BOTTOM);
}

// coin_mask();
// player_box();
// player_box_base();
// player_box_base_connector();

lid();
