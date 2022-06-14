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