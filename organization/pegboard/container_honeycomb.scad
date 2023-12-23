use <../../lib/honeycomb.scad>
include <container.scad>

container_honeycomb_padding = 7;
container_honeycomb_hexagons = 6;
honeycomb_size = [
  container_size.x - container_honeycomb_padding * 2,
  container_thickness,
  container_size.z - container_honeycomb_padding * 2,
];

module container_with_honeycomb() {
  difference() {
    container();
    up(container_honeycomb_padding) fwd(container_size.y / 2 - container_thickness / 2)
        cube(honeycomb_size, anchor = BOTTOM);
  }

  container_wall();
}

module honeycomb_wall() {
  up(honeycomb_size.z / 2 + container_honeycomb_padding)
      fwd(container_size.y / 2 - container_thickness) rotate([ 90, 0, 0 ])
          linear_extrude(container_thickness) honeycomb_rectangle(
              [ honeycomb_size.x, honeycomb_size.z ], hexagons = container_honeycomb_hexagons);
}
