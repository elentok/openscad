use <box.scad>
use <hexagon.scad>

module honeycomb_box(width, depth, height, border_radius, wall_width, hexagon_radius, hexagon_dist, padding_bottom, padding_top, padding_horizontal) {
    
    $honeycomb_height = height - padding_bottom - padding_top;
    $honeycomb_width = width - padding_horizontal * 2;

    difference() {
        box_with_label(width, depth, height, border_radius, wall_width);
        
        translate([padding_horizontal-width/2, (depth+10)/2, padding_bottom])
        rotate([90, 0, 0])
        blocked_hexagons(depth+10, hexagon_radius, hexagon_dist, $honeycomb_width, $honeycomb_height);
    
        translate([-(width+10)/2, padding_horizontal-width/2, padding_bottom])
        rotate([90, 0, 90])
        blocked_hexagons(width+10, hexagon_radius, hexagon_dist, $honeycomb_width, $honeycomb_height);
    }
}

honeycomb_box(
    width = 98,
    depth = 93,
    height = 130,
    border_radius = 5,
    wall_width = 1.2,
    hexagon_radius = 5,
    hexagon_dist = 2,
    padding_bottom = 25,
    padding_top = 15,
    padding_horizontal = 10);