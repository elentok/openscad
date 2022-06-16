$fn=50;

module hook(inner_diameter, thickness) {
    $outer_diameter = inner_diameter + thickness * 2;
    
    difference() {
      circle(d = $outer_diameter);
      circle(d = inner_diameter);
    }
}


hook(inner_diameter = 30, thickness = 3);