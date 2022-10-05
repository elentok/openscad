include <./case-shared.scad>
include <./variables-left.scad>

mirror([ 1, 0, 0 ]) union() {
  // case_top();
  // case_bottom();
  // case_top_left();  // left-top-right
  // case_top_right();  // left-top-left
  // case_bottom_left();  // left-bottom-right
  case_bottom_right();  // left-bottom-left
}
