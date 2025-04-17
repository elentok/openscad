include <BOSL2/std.scad>
$fn = 64;

scriveiner_d = 6.2;
scriveiner_l = 110;
parker_g2_d = 5.6;
parker_g2_l = 97.9;

// P2S - ParkerG2 to Scriveiner
p2s_extender_od = 7.4;
p2s_extender_id = parker_g2_d + 0.1;
p2s_extender_h_full = scriveiner_l - parker_g2_l;
p2s_extender_h_hollow = 10;

module p2s_extender() {
  cyl(d = p2s_extender_od, h = p2s_extender_h_full, anchor = BOTTOM);
  up(p2s_extender_h_full - 0.1)
      tube(od = p2s_extender_od, id = p2s_extender_id,
           h = p2s_extender_h_hollow, anchor = BOTTOM);
}

module p2s_tip_adapter() {
  adapter_l = 6.6;
  adapter_od = 4.2;
  adapter_id = 2.4;

  difference() {
    cyl(d = adapter_od, h = adapter_l, chamfer2 = 0.4, anchor = BOTTOM);
    down(0.01) cyl(d = adapter_id, h = adapter_l + 0.02, anchor = BOTTOM);
  }

  // tube(od = adapter_od, id = adapter_id, h = adapter_l, anchor=BOTTOM);
  // tube(od = adapter_od, id = adapter_id, h = adapter_l, anchor=BOTTOM);
}

// p2s_extender();
p2s_tip_adapter();
