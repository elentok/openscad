use <../containers/box.scad>
include <BOSL2/std.scad>

remotes = 3;
remote_size = [ 24, 40, 100 ];
rounding = 10;
thickness = 2;
separator_height = 60;

separators = remotes - 1;
caddy_size = [
  remote_size.x * remotes + thickness * (separators + 2),
  remote_size.y + thickness * 2,
  remote_size.z + thickness,
];

module caddy() {
  box(caddy_size, rounding = rounding);
  separators();
}

module separators() {
  delta_x = remote_size.x + thickness;

  left(caddy_size.x / 2 - thickness / 2) for (i = [1:separators]) {
    x = i * delta_x;
    right(x) separator();
  }
}

module separator() {
  z = separator_height / 2 + thickness;
  up(z) cube([ thickness, remote_size.y, separator_height ], center = true);
}

// for debugging
module remotes() {
  left(caddy_size.x / 2 - thickness) for (i = [0:remotes - 1]) {
    x = remote_size.x / 2 + i * (remote_size.x + thickness);
    right(x) up(remote_size.z / 2 + thickness) #remote();
  }
}

module remote() { up(remote_size.z / 2 + thickness) cube(remote_size, center = true); }

caddy();
// remotes();
