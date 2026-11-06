t++;
if (!active) {
    timer--;
    if (timer <= 0) { active = true; fx_dust(x, y, 6); }
} else {
    var p = instance_place(x, y, obj_player_parent);
    if (p != noone) {
        fx_dust(x, y, 10);
        with (p) {
            air_dash_used = false;
            if (variable_instance_exists(id, "air_attack_used")) air_attack_used = false;
            squash_x = 1.2;
            squash_y = 0.85;
        }
        active = false;
        timer = respawn_time;
    }
}
