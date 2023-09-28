include <BOSL2/std.scad>
$fn = 64;

// 150cm^2

bottom_thickness = 2;
side_thickness = 2;
cell_isize = [ 50, 50 ];
rounding = 5;

cell_heights = [
  [ 80, 80, 80 ],
  [ 80, 80, 80 ],
];

module cell(h, isize) {
  osize = add_scalar(isize, side_thickness * 2);
  echo("CELL", h);
  linear_extrude(bottom_thickness)
      rect(osize, rounding = rounding, anchor = BACK + LEFT);
  rect_tube(h = h, size = osize, isize = isize, rounding = rounding,
            anchor = BOTTOM + BACK + LEFT);
}

offset_x = cell_isize.x + side_thickness + 0.01;
offset_y = cell_isize.y + side_thickness + 0.01;

for (i_row = [0:len(cell_heights) - 1]) {
  row = cell_heights[i_row];
  echo("ROW", i_row, row);

  fwd(i_row * offset_y) for (i_col = [0:len(row) - 1]) {
    right(i_col * offset_x) cell(h = row[i_col], isize = cell_isize);
  }
}

// back(10) cell(h = 80, isize = [ 150, 10 ]);
