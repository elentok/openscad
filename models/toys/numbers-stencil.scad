include <BOSL2/std.scad>
$fn = 64;

number_size = [ 17, 25 ];
spacing = 8;
padding = [ 15, 7 ];
numbers = 5;
rounding = 10;
thickness = 2;
font = "Google Sans:style=Bold";

// number_xoffsets = [ 0, -1.2, 0, 0, 0, 0, 0, 0, 0, 0 ];

stencil_size = [
  numbers * number_size.x + spacing * (numbers - 1) + padding.x * 2,
  number_size.y + padding.y * 2,
];

echo("Stencil Size:", stencil_size);

module stencil() { linear_extrude(thickness) stencil2d(); }

module stencil2d() {
  union() {

    difference() {
      rect(stencil_size, rounding = rounding, anchor = LEFT);
      numbers_mask();
    }
  }
}

module numbers_mask() {
  // yoffset = number_size.y / 2 + spacing / 2;
  //
  for (i = [1:5]) {
    xoffset =
        padding.x + number_size.x / 2 + (i - 1) * (number_size.x + spacing);
    right(xoffset) number_mask(str(i));

    // debugging
    // right(xoffset) #rect(number_size);
  }

  // for (i = [5:9]) {
  //   xoffset = padding + number_size.x / 2 + (i - 5) * (number_size.x +
  //   spacing); fwd(yoffset) right(xoffset) number_mask(str(i));
  //
  //   // debugging
  //   // right(xoffset) #rect(number_size);
  // }
}

module number_mask(text, xoffset = 0) {
  right(xoffset) text(text, halign = "center", valign = "center",
                      size = number_size.y, font = font);
}

// module number_supports() {
//   right(padding.x + number_size.x / 2)
//       rect([ 2, number_size.y + spacing ], anchor = FWD);
//
//   fwd(number_size.y / 2)
//       right(padding.x + number_size.x / 2 + number_size.x + spacing)
//           rect([ 2, number_size.y / 2 ], anchor = BACK);
// }

stencil();
