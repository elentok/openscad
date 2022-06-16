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

module negative_edge(width, radius) {
    difference() {
        cube([width, radius, radius]);

        translate([0, radius, 0])
        rotate([0,90,0])
        cylinder(h = width + 1, r = radius);        
    }
}


module rounded_edge(width, depth, height, radius) {
    assert(radius <= height, "Radius must be less or equal to the height");
    union() {
        translate([0, radius, 0])
        cube([width, depth - radius, height]);

        cube([width, radius, height - radius]);
       
        translate([0, radius, (height - radius)])
        quarter_cylinder(height = width, radius = radius);
    }    
}

module centered_rounded_edge(width, depth, height, radius) {
    translate([-width/2, -depth/2, -height/2])
    rounded_edge(width, depth, height, radius);
}

module quarter_cylinder(height, radius) {   
    rotate([90, -90, 90])
    rotate_extrude(angle = 90)
    square([radius, height]);
}

//cube([10,20,30]);
//rounded_cube(30, 50, 12, 5);
//half_rounded_cube(30, 50, 6, 5);
//quarter_rounded_cube(30, 25, 6, 5);
//centered_rounded_edge(30, 50, 12, 11);
//half_cylinder(30, 5);