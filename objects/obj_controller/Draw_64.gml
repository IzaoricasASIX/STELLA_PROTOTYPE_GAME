var p = instance_find(obj_player_parent, 0);
if (p != noone) {

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);

draw_text(16, 16, "Score " + string(global.score));

var hearts = p.hp;
var maxh = p.hp_max;
var i;
for (i = 0; i < maxh; i++) {
    var xx = 16 + i * 14;
    var yy = 40;
    draw_set_color(i < hearts ? make_color_rgb(255, 92, 140) : make_color_rgb(60, 40, 50));
    draw_rectangle(xx, yy, xx + 10, yy + 12, false);
}
draw_set_color(c_white);

draw_text(16, 60, ((p.object_index == obj_nila) ? "NILA" : "STELLA") + (global.muted ? "   (MUTED)" : ""));
if (p.object_index == obj_stella && p.is_gelatin) {
    draw_text(16, 76, "GELATIN");
}

draw_set_alpha(0.7);
draw_text(16, display_get_gui_height() - 28, "Z jump  X dash/atk  Shift run  R retry  Tab switch  M mute  F3 debug");
draw_set_alpha(1);
}

// --- fade overlay, drawn last so it covers the HUD too ---
if (global.fade_alpha > 0) {
    draw_set_alpha(global.fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
