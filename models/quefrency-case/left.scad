include <./case-shared.scad>
include <./variables-left.scad>

mirror([ 1, 0, 0 ]) union() {
  // case_top();
  // case_bottom();
  case_top_left();
  // case_bottom_left();
  // case_top_right();
  // case_bottom_right();
}
