$fn=50;

module hexagon(extrusion_height, radius) {
    rotate([0, 0, 90])
    cylinder($fn=6, h=extrusion_height, r=radius);
}

module hexagons(extrusion_height, radius, distance, x_reps, y_reps) {
    $hexagon_height = radius*2;
    $side = radius;
     
    // Using the pythagorean theorem:
    //
    //   (Width/2)^2 + (r/2)^2 = r^2
    //
    $hexagon_width = sqrt(3) * radius;
    
    // Using the pythagorean theorem:
    //
    //   VertDist^2 + (Dist/2)^2 = Dist^2
    //
    $vertical_distance = sqrt(1.25)*distance;

    $pattern_height = $hexagon_height + $vertical_distance * 2 + $side; 
    $pattern_width = $hexagon_width + distance;
    
    for(index_y = [0:1:y_reps-1]){
        $y1 = index_y * $pattern_height;
        $y2 = $y1 + 0.75 * $hexagon_height + $vertical_distance;

        for(index_x = [0:1:x_reps-1]) {
            $x1 = index_x * $pattern_width;
            translate([$x1, $y1, 0])
            hexagon(extrusion_height, radius);
            
            $x2 = $x1 + $hexagon_width/2 + distance/2;
            
            translate([$x2, $y2, 0])
            hexagon(extrusion_height, radius);
        }
    }
}

module blocked_hexagons(extrusion_height, radius, distance, width, height) {
    $hexagon_height = radius * 2;
    $hexagon_width = sqrt(3) * radius;
    $x_reps = ceil(width / ($hexagon_width + distance)) + 1;
    $y_reps = ceil(height / ($hexagon_height + distance)) + 1;
    
    intersection() {
        cube([width, height, extrusion_height]);
        hexagons(extrusion_height, radius, distance, $x_reps, $y_reps);
    }
}

//hexagons(5, 5, distance=2, x_reps=20, y_reps=20);
blocked_hexagons(extrusion_height=5, radius=5, distance=2, width=80, height=100);