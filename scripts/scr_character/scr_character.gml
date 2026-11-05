// ---------------------------------------------------------------------------
// CHARACTER SWITCHING (Tab, or the terminal)
// There is no "swap" in GameMaker: we create the OTHER object at the same spot, copy
// over the state that matters (speed, facing, hp...), and destroy the old one.
// _to: "stella", "nila", or "" to toggle.
// ---------------------------------------------------------------------------
function character_switch(_to = "") {
    var n = instance_number(obj_player_parent);
    if (n == 0) return;

    // collect first, THEN swap (so we don't loop over instances we are creating)
    var list = [];
    for (var i = 0; i < n; i++) array_push(list, instance_find(obj_player_parent, i));

    var changed = false;
    for (var i = 0; i < n; i++) {
        var p = list[i];

        var to_obj;
        if (_to == "stella") to_obj = obj_stella;
        else if (_to == "nila") to_obj = obj_nila;
        else to_obj = (p.object_index == obj_nila) ? obj_stella : obj_nila;

        if (p.object_index == to_obj) continue;

        var np = instance_create_layer(p.x, p.y, p.layer, to_obj);   // its Create event runs right now
        np.hsp = p.hsp;
        np.vsp = p.vsp;
        np.hsp_rem = p.hsp_rem;
        np.vsp_rem = p.vsp_rem;
        np.facing = p.facing;
        np.on_ground = p.on_ground;
        np.coyote_timer = p.coyote_timer;
        np.jump_buffer = p.jump_buffer;
        np.air_dash_used = p.air_dash_used;
        np.inv_timer = p.inv_timer;
        np.last_safe_x = p.last_safe_x;
        np.last_safe_y = p.last_safe_y;
        np.start_x = p.start_x;
        np.start_y = p.start_y;
        np.arrival_done = p.arrival_done;
        np.hp = min(p.hp, np.hp_max);
        np.squash_x = 1.35;
        np.squash_y = 0.75;

        fx_dust(p.x, p.bbox_bottom, 10);
        with (p) instance_destroy();
        changed = true;
    }

    // Remember the choice so it also applies when we enter the next room.
    global.character_override = global.character;
    if (changed) music_switch_character();
}
