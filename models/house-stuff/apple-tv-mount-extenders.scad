include <BOSL2/std.scad>
$fn = 64;

// Mount extenders for the Apple TV 4K Wall-mount by niklasbartsch
// https://www.printables.com/model/58322-apple-tv-4k-wall-mount
//
// These extenders allow connecting the mount to the TV arm.

h = 19;
h1 = 3;
h2 = h - h1;

id = 5.5;
od1 = 15;
od2 = 10;

module extender() {
  tube(id = id, od = od1, h = h1, anchor = BOTTOM);
  up(h1 - 0.01) tube(id = id, od = od2, h = h2, anchor = BOTTOM);
}

extender();
