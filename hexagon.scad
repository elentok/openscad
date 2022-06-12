$fn=50;

module hexagon(extrusion_height, radius) {
    rotate([0, 0, 90])
    cylinder($fn=6, h=extrusion_height, r=radius);
}

module honeycomb(extrusion_height, radius, distance) {
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
    
    for(index_y = [0:1:3]){
        $y1 = index_y * $pattern_height;
        $y2 = $y1 + 0.75 * $hexagon_height + $vertical_distance;

        for(index_x = [0:1:3]) {
            $x1 = index_x * $pattern_width;
            translate([$x1, $y1, 0])
            hexagon(extrusion_height, radius);
            
            $x2 = $x1 + $hexagon_width/2 + distance/2;
            
            translate([$x2, $y2, 0])
            hexagon(extrusion_height, radius);
        }
    }
}

honeycomb(5, 5, distance=2);