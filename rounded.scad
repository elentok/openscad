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

module rounded_cube(width, depth, height, radius) {
    minkowski() {
        cube([width - radius*2, depth - radius*2, height - radius*2], center=true);
        sphere(radius);
    }
}

module half_rounded_cube(width, depth, height, radius) {
    intersection() {
        rounded_cube(width, depth, height*2, radius);
        
        translate([-width/2, -depth/2, 0])
        cube([width, depth, height]);
    }
}

module quarter_rounded_cube(width, depth, height, radius) {
    intersection() {
        rounded_cube(width, depth*2, height*2, radius);
        
        translate([-width/2, 0, 0])
        cube([width, depth, height]);
    }
}

//cube([10,20,30]);
//rounded_cube(30, 50, 12, 5);
//half_rounded_cube(30, 50, 6, 5);
//quarter_rounded_cube(30, 25, 6, 5);