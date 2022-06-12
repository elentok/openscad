$fn=50;

$border_width = 1.2;
$radius = 5;
$box_width = 98;
$box_depth = 93;
$box_height = 130;


module round_cube(width, depth, height, radius) {    
    minkowski() {
        cube([
            width - radius*2,
            depth - radius*2,
            height - radius*2], center=true);
        sphere(radius);
    }
}

module rounded_rectangle(width, height, radius) {
    minkowski() {
        square([width - radius/2, height - radius/2], center=true);
        circle(radius);
    }
}

module rounded_rectangle_border(width, height, radius, border_width) {
    difference() {
      rounded_rectangle(width, height, radius);
      rounded_rectangle(width - border_width*2, height - border_width*2, radius);       
    }
}

module box(width, depth, height, radius, border_width) {
    linear_extrude(height)
    rounded_rectangle_border(width, depth, radius, border_width);
    
    linear_extrude(border_width)
    rounded_rectangle(width, depth, $radius);
}

module box_with_label(width, depth, height, radius, border_width) {
    box(width, depth, height, radius, border_width);

    $label_width = 60;
    $label_depth = 10;
    $label_height = 10;

    translate([-$label_width / 2, width/2 - $label_depth, height - $label_height])
    cube([$label_width, $label_depth, $label_height]);
}

box_with_label($box_width, $box_depth, $box_height, $radius, $border_width);

