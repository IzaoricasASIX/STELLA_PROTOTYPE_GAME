if (variable_global_exists("debug_draw") && global.debug_draw) {
    draw_self();
    draw_set_color(c_lime);
    draw_text(x + 10, y - 16, door_id);
    draw_set_color(c_white);
}
