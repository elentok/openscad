include <BOSL2/std.scad>
use <../lib-old/honeycomb.scad>

// Speaker size:
// riser_size = [165, 155, 26];

// Small UPS size:
riser_size = [245, 90, 26];

feet_thickness = 2;
// Speaker:
// feet_id = 27;
feet_id = 18;
feet_od = feet_id + 2 * feet_thickness;
feet_felt_sticker_height = 3.5;

frame_thickness = 3;
frame_osize =
[riser_size.x - feet_od, riser_size.y - feet_od, riser_size.z * 0.2];
frame_isize = [
  frame_osize.x - frame_thickness * 2,
  frame_osize.y - frame_thickness * 2,
];
frame_hexagons = 4;

module speaker_riser() {
  frame();
  feet();
}

module frame() {
  linear_extrude(frame_osize.z) union() {
      shell2d(-frame_thickness) rect([frame_osize.x, frame_osize.y]);
      rotate([0, 0, 90]) honeycomb_rectangle(
          [frame_isize.y + 0.1, frame_isize.x + 0.1], hexagons=frame_hexagons,
          thickness=frame_thickness
        );
    }
}

module feet() {
  left(frame_osize.x / 2) union() {
      fwd(frame_osize.y / 2) foot();
      back(frame_osize.y / 2) foot();
    }

  right(frame_osize.x / 2) union() {
      fwd(frame_osize.y / 2) foot();
      back(frame_osize.y / 2) foot();
    }
}

module foot() {
  tube(od=feet_od, id=feet_id, h=riser_size.z, anchor=BOTTOM);
  cylinder(
    d=feet_id, h=riser_size.z - feet_felt_sticker_height,
    anchor=BOTTOM
  );
}

speaker_riser();
