include <BOSL2/std.scad>
include <../lib/rounded-rect-mask.scad>
include <../lib/rcube.scad>
$fn = 64;

// Tolerances
inner_panel_tolerance = 0.2;
checkbox_tolerance = [0.1, 0.1, 0.1];
notch_tolerance = 0.2;

// Variables
tasks = 1;
list_title_y_size = 15;
list_gap = 10;
list_margin = 7;
list_border_thickness = 3;
task_gap = 17;
task_name_size = [60, 15];
task_rounding = 7;

// How much does the checkbox's bottom part goes behind the inner panel.
checkbox_bottom_lip = 2;

outer_panel_rounding = 15;
inner_panel_rounding = 12;
outer_panel_thickness = 3;
inner_panel_thickness = 3;
inner_panel_z_rounding = inner_panel_thickness / 3;

// size of two notches at the sides of the inner panel
// that connect to the outer panel
notch_size = [1, 5, inner_panel_thickness / 2];

// checkbox_green_layer_height = 1;
checkbox_top_diameter = task_name_size.y - checkbox_tolerance.y;

checkbox_bottom_size = [
  // x
  (checkbox_top_diameter + checkbox_tolerance.y) * 2,
  // y
  task_name_size.y + checkbox_bottom_lip * 2 - checkbox_tolerance.y,
  // z
  inner_panel_thickness / 2 - checkbox_tolerance.z,
];

checkbox_bottom_mask_size = [
  // x
  (checkbox_top_diameter + checkbox_tolerance.y) * 3,
  // y
  task_name_size.y + checkbox_bottom_lip * 2,
  // z
  inner_panel_thickness / 2,
];

checkbox_top_height = inner_panel_thickness - checkbox_bottom_size.z;

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
    rcube([outer_size.x, outer_size.y, outer_panel_thickness + inner_panel_thickness], rounding_sides=outer_panel_rounding, rounding_top=outer_panel_thickness / 3);
    up(outer_panel_thickness - inner_panel_thickness + 0.01) {
      rcube(
        mask_size,
        rounding_sides=inner_panel_rounding,
        rounding_top=-outer_panel_thickness / 3,
        anchor=BOTTOM
      );
    }
    up(outer_panel_thickness / 2) {
      right(inner_size.x / 2) notch(anchor=LEFT, rounding=0);
      mirror([1, 0, 0]) right(inner_size.x / 2) notch(anchor=LEFT, rounding=0);
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

  right(inner_size.x / 2) notch(anchor=LEFT);
  mirror([1, 0, 0]) right(inner_size.x / 2) notch(anchor=LEFT);
}

module notch(mask = false, rounding = notch_size.x / 2, anchor) {
  left(inner_panel_z_rounding) down(inner_panel_thickness / 2 - notch_size.z / 2) cuboid(
        [
          notch_size.x + inner_panel_z_rounding + (mask ? notch_tolerance : 0),
          notch_size.y + (mask ? notch_tolerance : 0),
          notch_size.z + (mask ? notch_tolerance : 0),
        ],
        rounding=rounding,
        except_edges=LEFT,
        anchor=anchor
      );
}

module list_title_mask() {
  inner_panel_mask([list_title_x_size, list_title_y_size]);
}

module task_name_mask() {
  inner_panel_mask([task_name_size.x, task_name_size.y]);
}

module checkbox_mask() {
  up(checkbox_top_height / 2 + 0.01) inner_panel_mask(
      [checkbox_hole_size.x, checkbox_hole_size.y], h=checkbox_top_height
    );

  size = [
    checkbox_bottom_mask_size.x,
    checkbox_bottom_mask_size.y,
    checkbox_bottom_mask_size.z + 0.04,
  ];

  back(checkbox_bottom_lip - checkbox_tolerance.y)
    down(checkbox_bottom_mask_size.z / 2 - 0.01)
      left(checkbox_bottom_mask_size.x / 3)
        rcube(size, rounding_sides=1, anchor=BACK + LEFT);
}

module inner_panel_mask(size, h = inner_panel_thickness + 0.02) {
  size3d = [size.x, size.y, h];
  rcube(
    size3d, rounding_sides=size.y / 2,
    rounding_top=-inner_panel_z_rounding,
    anchor=BACK + LEFT,
  );
}

module checkbox() {
  union() {
    difference() {
      rcube(checkbox_bottom_size, rounding_sides=checkbox_bottom_size.y / 2, rounding_top=checkbox_bottom_size.z / 4, anchor=TOP);

      green_h = 1;
      green_diameter_diff = 2;
      green_diameter = checkbox_top_diameter - green_diameter_diff;
      up(0.01) left(green_diameter_diff / 2)
          cyl(d=green_diameter, h=green_h, anchor=RIGHT + TOP, rounding2=-green_h / 2);
    }

    difference() {
      padding = 1;
      inner_circle_d = checkbox_top_diameter - padding * 2;
      inner_circle_h = 1;

      cyl(d=checkbox_top_diameter, h=checkbox_top_height, anchor=LEFT + BOTTOM, rounding2=padding / 2);
      up(checkbox_top_height - inner_circle_h + 0.01) right(padding)
          cyl(
            d=inner_circle_d, h=inner_circle_h, anchor=LEFT + BOTTOM,
            rounding2=-padding / 2
          );
    }
  }
}

// module demo() {
//   color("green") outer_panel();
//   color("blue") inner_panel();
// }

// demo();
// outer_panel();
// inner_panel();
checkbox();
// checkbox_mask();
