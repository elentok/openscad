include <BOSL2/std.scad>
$fn = 64;

hole_d = 6;
hole_dist = 6;

linear_extrude(4) difference()
{
    circle(d = 82);
    // round2d(r = 2) star(n = 5, od = 80, id = 40, align_tip = [ 0, 1 ]);
    hole_row(y = -3, x = -2, n = 5, space = 4);
    hole_row(y = -2, x = -2.5, n = 6, space = 4);
    hole_row(y = -1, x = -3, n = 7, space = 4);
    hole_row(y = 0, x = -3.5, n = 8, space = 4);
    hole_row(y = 1, x = -3, n = 7, space = 4);
    hole_row(y = 2, x = -2.5, n = 6, space = 4);
    hole_row(y = 3, x = -2, n = 5, space = 4);
    // hole_row(y = 3, x = -3, n = 7, space = 4);
    // hole_row(y = 0.7, x = -2, n = 5, space = 4);
    // hole_row(y = 1.8, x = -1, n = 3, space = 2);
    // hole_row(-1, 2, 10);
}

module hole_row(y, x, n, space)
{
    x0 = x * (space + hole_d);
    back(y * (hole_d + space)) for (i = [0:n - 1])
    {
        right(x0 + (space + hole_d) * i) circle(d = hole_d);
    }
}
