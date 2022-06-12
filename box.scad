$fn=50;

module rounded_rectangle(width, height, radius) {
    minkowski() {
        square([width - radius*2, height - radius*2], center=true);
        circle(radius);
    }
}

module rounded_rectangle_border(width, height, radius, wall_width) {
    difference() {
      rounded_rectangle(width, height, radius);
      rounded_rectangle(width - wall_width*2, height - wall_width*2, radius);       
    }
}

module box(width, depth, height, radius, wall_width) {
    linear_extrude(height)
    rounded_rectangle_border(width, depth, radius, wall_width);
    
    linear_extrude(wall_width)
    rounded_rectangle(width, depth, radius);
}

module box_with_label(width, depth, height, radius, wall_width) {
    box(width, depth, height, radius, wall_width);

    $label_width = 60;
    $label_depth = 10;
    $label_height = 10;

    translate([-$label_width / 2, depth/2 - $label_depth, height - $label_height])
    label($label_width, $label_depth, $label_height);
}

module label(width, depth, height) {
    difference() {
      cube([width, depth, height]);

      translate([width/2, 0, -1])
      rotate([90, 0, 90])
      cylinder(h = width + 1, r = depth, center = true);
    };

    $triangle_width = 2;

    // Left triangle
    label_triangle(depth, $triangle_width);
    
    // Right triangle
    translate([width - $triangle_width, 0, 0])
    label_triangle(depth, $triangle_width);
}

module label_triangle(size, triangle_width) {
    rotate([90, 0, 90])
    linear_extrude(triangle_width)
    polygon([[size, size], [0, size], [size, 0]]);
}



//box_with_label(width = 98, depth = 93, height = 130, radius = 5, wall_width = 1.2);
