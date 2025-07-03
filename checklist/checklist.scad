include <BOSL2/std.scad>
include <../lib/rounded-rect-mask.scad>
include <../lib/rcube.scad>
$fn = 64;

// Tolerances
inner_panel_tolerance = 0.2;
checkbox_tolerance = [0.1, 0.1, 0.1];

// Variables
tasks = 3;
list_title_y_size = 15;
list_gap = 10;
list_margin = 7;
list_border_thickness = 3;
task_gap = 15;
task_name_size = [60, 15];
task_rounding = 7;

outer_panel_rounding = 10;
inner_panel_rounding = 7;
outer_panel_thickness = 3;
inner_panel_thickness = 3;
inner_panel_z_rounding = inner_panel_thickness / 3;

checkbox_bottom_height = inner_panel_thickness / 2;
checkbox_green_layer_height = 1;
checkbox_top_height = inner_panel_thickness - checkbox_bottom_height - checkbox_green_layer_height;
checkbox_size = [
  task_name_size.y * 3 - checkbox_tolerance.x,
  task_name_size.y - checkbox_tolerance.y,
];

checkbox_diameter = task_name_size.y - checkbox_tolerance.y;
checkbox_hole_size = [task_name_size.y * 2, task_name_size.y, inner_panel_thickness + 0.02];

outer_size = [
  list_border_thickness * 2 + list_margin * 2 + task_name_size.x + checkbox_hole_size.x + task_gap,
  list_border_thickness * 2 + list_margin * 2 + list_title_y_size + list_gap + (task_name_size.y * tasks) + list_gap * (tasks - 1),
];
inner_size = add_scalar(outer_size, -list_border_thickness * 2);

list_title_x_size = inner_size.x - list_margin * 2;

echo("Outer size:", outer_size);
echo("Inner size:", inner_size);

module outer_panel() {
  mask_size = [
    inner_size.x + inner_panel_tolerance,
    inner_size.y + inner_panel_tolerance,
    inner_panel_thickness,
  ];
  difference() {
    rcube([outer_size.x, outer_size.y, outer_panel_thickness], rounding_sides=outer_panel_rounding, rounding_top=outer_panel_thickness / 3);
    up(outer_panel_thickness - inner_panel_thickness + 0.01) {
      rcube(
        mask_size,
        rounding_sides=inner_panel_rounding,
        rounding_top=outer_panel_thickness / 3,
        anchor=BOTTOM
      );
    }
  }
}

module inner_panel() {
  left(inner_size.x / 2) back(inner_size.y / 2)
      difference() {
        fwd(inner_size.y / 2) right(inner_size.x / 2)
            rcube(
              [inner_size.x, inner_size.y, inner_panel_thickness],
              rounding_sides=inner_panel_rounding,
              rounding_top=inner_panel_z_rounding,
              rounding_bottom=inner_panel_z_rounding
            );

        fwd(list_margin) right(list_margin) {
            list_title_mask();

            fwd(list_title_y_size + list_gap) {

              for (i = [0:tasks - 1]) {
                fwd(i * (task_name_size.y + list_gap)) {
                  task_name_mask();
                  right(task_name_size.x + task_gap) checkbox_mask();
                }
              }
            }
          }
      }
}

module list_title_mask() {
  inner_panel_mask([list_title_x_size, list_title_y_size]);
}

module task_name_mask() {
  inner_panel_mask([task_name_size.x, task_name_size.y]);
}

module checkbox_mask() {
  inner_panel_mask([checkbox_hole_size.x, checkbox_hole_size.y]);
}

module inner_panel_mask(size) {
  size3d = [size.x, size.y, inner_panel_thickness + 0.02];
  rcube(
    size3d, rounding_sides=size.y / 2,
    rounding_top=-inner_panel_z_rounding,
    anchor=BACK + LEFT,
  );
}

module checkbox() {
  rcube([checkbox_size.x, checkbox_size.y, checkbox_bottom_height], rounding_sides=checkbox_size.y / 2, anchor=BOTTOM); //, rounding_top=inner_panel_z_rounding,);
  up(checkbox_bottom_height) left(checkbox_size.y / 2) rcube([checkbox_size.x - checkbox_size.y, checkbox_size.y, checkbox_green_layer_height], rounding_sides=checkbox_size.y / 2, anchor=BOTTOM); //, rounding_top=inner_panel_z_rounding);
  up(checkbox_bottom_height + checkbox_green_layer_height)
    difference() {
      cyl(d=checkbox_size.y, h=checkbox_green_layer_height);
      #cyl(d=checkbox_size.y, h=checkbox_top_height, rounding1=0.5, rounding2=0);
      // rcube([checkbox_size.y, checkbox_size.y, checkbox_green_layer_height], rounding_sides=checkbox_size.y / 2, anchor=BOTTOM);

      // thumb_size = [checkbox_size.y * 0.7, checkbox_size.y * 0.7, checkbox_green_layer_height / 2];

      // #up(5) rcube(thumb_size, rounding_sides=thumb_size.y / 2, anchor=BOTTOM);
    }
}

// outer_panel();
// inner_panel();
checkbox();
