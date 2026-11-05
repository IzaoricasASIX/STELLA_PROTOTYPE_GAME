draw_self();

var cx = (bbox_left + bbox_right) / 2;

// A bobbing arrow when you are standing in the door: "press Up".
if (place_meeting(x, y, obj_player_parent)) {
    var bob = sin(current_time / 180) * 3;
    draw_set_color(c_white);
    draw_triangle(cx - 7, bbox_top - 8 + bob, cx + 7, bbox_top - 8 + bob, cx, bbox_top - 20 + bob, false);
}

// F3 debug: show how this door is wired.
if (variable_global_exists("debug_draw") && global.debug_draw) {
    var to_room = (target_room != noone) ? room_get_name(target_room) : "(nothing!)";
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    draw_text(cx, bbox_top - 44, "id: " + door_id);
    draw_text(cx, bbox_top - 30, "-> " + to_room + " / " + target_door);
    draw_set_halign(fa_left);
    draw_set_color(c_white);
}
