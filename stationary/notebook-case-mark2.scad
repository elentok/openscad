include <./notebook-sizes.scad>
include <BOSL2/std.scad>
$fn = 64;

back_thickness = 2;
rounding = back_thickness;
wall_thickness = 1.8;
notebook_thickness = 3.2;
notebooks = 2;
tolerance = [ 1, 3, 3 ];
thumb_size = [ 20, 30 ];
notebook_size = get_notebook_size("fieldnotes");
rubberband_size = [ 2.5, 23 ];

inner_height = notebooks * notebook_thickness;

module notebook_case() {
  case_size = add_scalar(notebook_size, wall_thickness * 2);
  cuboid([ case_size.x, case_size.y, back_thickness ],
         rounding = back_thickness, except = TOP, anchor = TOP);

  rect_tube(size = case_size, isize = notebook_size, h = inner_height,
            rounding = rounding, anchor = BOTTOM);
}

notebook_case();
