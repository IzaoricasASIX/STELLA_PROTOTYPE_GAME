// Invisible while playing. Press F3 to see the trigger and where it leads.
if (variable_global_exists("debug_draw") && global.debug_draw) {
    draw_self();
    var to_room = (target_room != noone) ? room_get_name(target_room) : "(nothing!)";
    draw_set_color(c_aqua);
    draw_text(bbox_left + 2, bbox_top + 2, "-> " + to_room + " / " + target_door);
    draw_set_color(c_white);
}
