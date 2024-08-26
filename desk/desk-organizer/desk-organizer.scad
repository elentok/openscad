include <BOSL2/std.scad>
$fn = 64;

epsilon = 0.01;

cell_width = 30;
cell_depth = 32;
cell_height = 85;
cell_rounding = 5;
cells_x = 3;
cells_y = 2;
border_thickness = 1.5;
plate_thickness = 2;
rounding = 5;

sticker_d = 14;
sticker_margin = 2;

bottom_padding = 10;

top_size = [
  cell_width * cells_x + border_thickness * (cells_x + 1),
  cell_depth* cells_y + border_thickness*(cells_y + 1)
];

bottom_size = add_scalar(top_size, bottom_padding * 2);

remote_size = [ 65, 26, 60 ];
pocket_size = [ 86, 15, 40 ];
tape_measure_size = [ 65, 26, 30 ];

echo("BOTTOM_SIZE", bottom_size);

module organizer() {
  difference() {
    organizer_base();
    stickers_mask();
  }
}

module organizer_base() {
  // diff() {
  //   prismoid(size1 = bottom_size, size2 = top_size, h = cell_height,
  //            rounding = rounding, anchor = BACK + LEFT) {
  //     edge_profile([TOP], excess = 25, convexity = 20) {
  //       mask2d_roundover(r = 5, mask_angle = $edge_angle);
  //     }
  //   }
  // }

  difference() {
    prismoid(size1 = bottom_size, size2 = top_size, h = cell_height,
             rounding = rounding, anchor = BACK + LEFT + BOTTOM);
    // linear_extrude(plate_thickness + cell_height, convexity = 4)
    //     rect([ plate_x, plate_y ], rounding = rounding, anchor = BACK +
    //     LEFT);

    right(bottom_padding + border_thickness)
        fwd(bottom_padding + border_thickness) up(plate_thickness) {
      for (ix = [0:cells_x - 1]) {
        x = ix * cell_width + ix * border_thickness;
        for (iy = [0:cells_y - 1]) {
          y = iy * cell_depth + iy * border_thickness;
          fwd(y) right(x) linear_extrude(cell_height + epsilon)
              rect([ cell_width, cell_depth ], rounding = cell_rounding,
                   anchor = BACK + LEFT);
        }
      }
    }

    shift_remote_cell() cell_mask(remote_size);
    shift_pocket() cell_mask(pocket_size);
    shift_tape_measure() cell_mask(tape_measure_size);
  }

  shift_remote_cell() cell(remote_size);
  shift_pocket() cell(pocket_size);
  shift_tape_measure() cell(tape_measure_size);
}

module stickers_mask() {
  fwd(sticker_margin) right(sticker_margin) sticker_mask();
  fwd(sticker_margin) right(bottom_size.x - sticker_margin - sticker_d)
      sticker_mask();

  fwd(bottom_size.x - sticker_d - 8) right(sticker_margin + 9) sticker_mask();
  fwd(bottom_size.x - sticker_d - 8) right(pocket_size.x + 5) sticker_mask();

  fwd(bottom_size.x - (bottom_size.x - remote_size.y) / 2 - 4)
      left(remote_size.y + 2) sticker_mask();

  fwd((bottom_size.y - remote_size.x) / 2 - 4) left(remote_size.y + 2)
      sticker_mask();

  fwd(bottom_size.x - (bottom_size.x - remote_size.y) / 2 - 4)
      right(bottom_size.x + tape_measure_size.y - sticker_d + 6) sticker_mask();

  fwd((bottom_size.y - remote_size.x) / 2 - 4)
      right(bottom_size.x + tape_measure_size.y - sticker_d + 6) sticker_mask();
}

module sticker_mask() {
  fwd(sticker_d / 2) right(sticker_d / 2) down(epsilon)
      cyl(h = 0.8 + epsilon, d = sticker_d, anchor = BOTTOM);
}

module shift_remote_cell() {
  fwd(bottom_size.y / 2) right(bottom_padding - border_thickness + 0.25)
      rotate([ 0, 0, -90 ]) children();
}

module shift_pocket() {
  right(bottom_size.x / 2)
      fwd(bottom_size.y - bottom_padding / 2 - border_thickness) children();
  // fwd(bottom_size.y - bottom_padding - border_thickness) children();
}

module shift_tape_measure() {
  // fwd(bottom_size.y / 2) right(bottom_padding) rotate([ 0, 0, -90 ])
  // children();
  right(bottom_size.x - bottom_padding / 2 - 0.25) fwd(bottom_size.y / 2)
      rotate([ 0, 0, 90 ]) children();
}

module cell(isize) {
  difference() {
    base_cell(isize = isize);
    cell_inner_mask(isize = isize);
  }
}

module cell_mask(isize) {
  union() {
    base_cell(isize = isize);
    cell_inner_mask(isize = isize);
  }
}

module cell_inner_mask(isize) {
  fwd(border_thickness) up(plate_thickness)
      linear_extrude(cell_height + epsilon, convexity = 4)
          rect([ isize.x, isize.y ], rounding = rounding, anchor = BACK);
}

module base_cell(isize) {
  top_s = add_scalar([ isize.x, isize.y ], border_thickness * 2);
  bottom_s = [ top_s.x + bottom_padding, top_s.y + bottom_padding ];  //
  prismoid(size1 = bottom_s, size2 = top_s, h = isize.z + plate_thickness,
           rounding = [ 0, 0, rounding, rounding ],
           shift = [ undef, bottom_padding / 2 ], anchor = BACK + BOTTOM);
}

organizer();
