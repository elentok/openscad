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

checkbox_diameter = task_name_size.y - checkbox_tolerance.y;
checkbox_hole_size = [task_name_size.y * 2, task_name_size.y, inner_panel_thickness + 0.02];

outer_size = [
  list_margin * 2 + task_name_size.x + checkbox_hole_size.x + task_gap,
  list_margin * 2 + list_title_y_size + list_gap + (task_name_size.y * tasks) + list_gap * tasks,
];
inner_size = add_scalar(outer_size, -list_border_thickness * 2);
// inner_width = outer_width - list_border_thickness * 2;
// inner_height = outer_height - list_border_thickness * 2;

list_title_x_size = inner_size.x - list_margin * 2;

echo("Outer size:", outer_size);
echo("Inner size:", inner_size);

module outer_panel() {
  difference() {
    rcube([outer_size.x, outer_size.y, outer_panel_thickness], rounding_sides=list_orounding, rounding_top=outer_panel_thickness / 3);
    up(outer_panel_thickness - inner_panel_thickness + 0.01) {
      cuboid(
        [
          inner_size.x + inner_panel_tolerance,
          inner_size.y + inner_panel_tolerance,
          inner_panel_thickness,
        ],
        rounding=list_orounding, except=[TOP, BOTTOM], anchor=BOTTOM
      );
    }
  }
}

module inner_panel() {
  difference() {
    fwd(inner_size.y / 2) right(inner_size.x / 2) rcube([inner_size.x, inner_size.y, inner_panel_thickness], rounding_sides=inner_panel_rounding, rounding_top=inner_panel_thickness / 3);
    list_title_mask();

    for (i = [0:tasks - 1]) {
      fwd(i * (task_name_size.y + list_gap)) {
        task_name_mask();
        checkbox_mask();
      }
    }
  }
}

module list_title_mask() {
  fwd(list_title_y_size / 2 + list_margin) right(list_title_x_size / 2 + list_margin) down(0.01) {
        rounded_rect_mask([list_title_x_size, list_title_y_size], h=inner_panel_thickness + 0.02, rounding=1);
      }
}
module task_name_mask() {
  down(0.01) fwd(task_name_size.y / 2 + list_margin + list_title_y_size + list_gap)
      right(task_name_size.x / 2 + list_margin)
        rounded_rect_mask(task_name_size, h=inner_panel_thickness + 0.02, rounding=1);
}

module checkbox_mask() {
  down(0.01) fwd(task_name_size.y / 2 + list_margin + list_title_y_size + list_gap)
      right(checkbox_hole_size.x / 2 + task_name_size.x + task_gap)
        rcube(checkbox_hole_size, rounding_sides=checkbox_hole_size.y / 2);
}

// outer_panel();
inner_panel();
