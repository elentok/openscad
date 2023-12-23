include <BOSL2/std.scad>
$fn = 64;

letter1 = [
  [ 0, 0 ], [ 1, 0 ], [ 2, 0 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ], [ 2, 4 ],
  [ 1, 2 ], [ 0, 3 ], [ 0, 4 ]
];
letter2 = [ [ 0, 0 ], [ 0, 1 ] ];
letter3 = [
  [ 0, 0 ], [ 1, 1 ], [ 2, 2 ], [ 3, 3 ], [ 4, 4 ], [ 1, 2 ], [ 0, 3 ],
  [ 0, 4 ], [ 3, 2 ], [ 4, 1 ], [ 4, 0 ]
];

dot_diameter = 7;
dot_space = 5;
letter_space = 20;
word_coords = [ letter3, letter2, letter1 ];

function get_coord(coords,
                   index) = [for (i = [0:len(coords) - 1]) coords[i][index]];

function max_coord(coords, index) = max(get_coord(coords, index));

// function word_dots(word_coords, letter_index = 0, x = 0, y = 0) = if
// (letter_index + 1 < len(word_coords)) [x,y] else word_dots(word_coords,
// letter_index + 1, x + max_coord(word_coords[letter_index], 0), y +
// max_coord(word_coors)

module word() { letter(word_coords, 0, 0); }

module letter(word_coords, letter_index, x) {
  letter_coords = word_coords[letter_index];
  echo("x", x);
  // echo(letter_coords);
  // echo(get_coord(letter_coords, 0));
  if (letter_index == 0) {
    circle_grid(letter_coords, d = dot_diameter, space = dot_space);
  } else {
    right(x) circle_grid(letter_coords, d = dot_diameter, space = dot_space);
  }

  if (letter_index + 1 < len(word_coords)) {
    letter_x_dots = max_coord(letter_coords, 0) + 1;
    letter_width = letter_x_dots * (dot_diameter + dot_space);
    letter(word_coords, letter_index + 1, x + letter_width + letter_space);
  }
}

module circle_grid(coords, d = 10, space = 10) {
  for (i = [0:len(coords) - 1]) {
    coord = coords[i];
    echo(i, coords[i]);
    x = d * coord.x + space * coord.x;
    y = d * coord.y + space * coord.y;

    fwd(y) right(x) circle(d = d);
  }
}

word();
// circle_grid(letter3);
