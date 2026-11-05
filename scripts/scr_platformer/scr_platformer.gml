/// Shared platformer helpers. Call these from a player instance (`obj_stella` / `obj_nila`).

function player_read_input() {
    // While the screen is fading between rooms, the player gets no input at all.
    if (variable_global_exists("transitioning") && global.transitioning) {
        return { move: 0, down: false, jump_p: false, jump_h: false, action_p: false, sprint: false, enter_p: false };
    }

    var gp = 0;
    var ax = gamepad_axis_value(gp, gp_axislh);
    var ay = gamepad_axis_value(gp, gp_axislv);

    var move = 0;
    if (keyboard_check(vk_right) || keyboard_check(ord("D"))) move += 1;
    if (keyboard_check(vk_left) || keyboard_check(ord("A"))) move -= 1;
    if (abs(ax) > 0.3) move = sign(ax);

    return {
        move: clamp(move, -1, 1),
        down: keyboard_check(vk_down) || keyboard_check(ord("S")) || ay > 0.45,
        jump_p: keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(gp, gp_face1),
        jump_h: keyboard_check(ord("Z")) || keyboard_check(vk_space) || gamepad_button_check(gp, gp_face1),
        action_p: keyboard_check_pressed(ord("X")) || gamepad_button_check_pressed(gp, gp_face3),
        sprint: keyboard_check(vk_shift) || gamepad_button_check(gp, gp_shoulderr) || gamepad_button_check(gp, gp_face2),
        enter_p: keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")) || gamepad_button_check_pressed(gp, gp_padu)
    };
}

function player_pressed_enter() {
    var input = player_read_input();
    return input.enter_p;
}

// ---------------------------------------------------------------------------
// ROOM TRANSITIONS
// room_transition() does not change room right away. It only *asks* obj_controller
// to start a fade-out. The controller changes the room when the screen is black,
// then fades back in. `_door_id` is the name of the door we want to appear at.
// ---------------------------------------------------------------------------
function room_transition(_room, _door_id = "") {
    if (global.fade_state != 0) return;   // already travelling, ignore
    global.fade_room = _room;
    global.arrive_door = _door_id;
    global.fade_state = 1;                // 1 = fading out
    global.transitioning = true;          // freezes player input
}

// Call from a door's Step event. `_target_door` is optional so old doors still work.
function door_try_enter(_room, _target_door = "") {
    if (place_meeting(x, y, obj_player_parent) && player_pressed_enter()) {
        room_transition(_room, _target_door);
    }
}

// Run by the player on its first frame in a room: if we arrived through a door,
// move to the matching obj_door (the one whose door_id equals global.arrive_door).
function player_check_arrival() {
    if (arrival_done) return;
    arrival_done = true;
    if (global.arrive_door == "") return;

    var _door = noone;
    with (obj_door) {
        if (door_id == global.arrive_door) _door = id;   // `id` = this door instance
    }
    if (_door == noone) return;

    // Line up the centre of our box with the door, and our feet with its floor.
    x += (_door.bbox_left + _door.bbox_right) / 2 - (bbox_left + bbox_right) / 2;
    y += _door.bbox_bottom - bbox_bottom;

    last_safe_x = x;
    last_safe_y = y;
    start_x = x;
    start_y = y;

    // Make the camera snap to us instead of gliding from the old position.
    if (instance_exists(obj_camera)) obj_camera.last_target = noone;
}

function player_init_common() {
    hsp = 0;
    vsp = 0;
    hsp_rem = 0;
    vsp_rem = 0;

    on_ground = false;
    on_wall = false;
    wall_dir = 0;
    facing = 1;

    coyote_timer = 0;
    jump_buffer = 0;
    spring_timer = 0;
    inv_timer = 0;
    drop_timer = 0;

    is_dashing = false;
    dash_time = 0;
    dash_dir = 1;
    dash_cooldown = 0;
    air_dash_used = false;

    is_gelatin = false;
    squash_x = 1;
    squash_y = 1;

    last_safe_x = x;
    last_safe_y = y;
    start_x = x;
    start_y = y;

    was_on_ground = false;
    hit_wall = false;
    landed = false;
    hit_ceil = false;

    // --- movement tuning shared by every character (override in a Create event) ---
    step_max = 6;               // tallest little ledge we walk up automatically (px)
    snap_max = 4;               // how far we stick to the ground going downhill (px)
    air_accel = 0.12;           // air steering strength, times speed
    air_turn_accel = 0.06;      // steering when pushing AGAINST your motion (weak = committed jumps)
    air_drag = 0.10;            // how fast we slow down in the air when not pushing
    gelatin_grav = 0.65;        // gravity multiplier while gelatin
    grav_rise = 0.36;           // gravity while going UP
    grav_fall = 0.9;            // gravity while going DOWN
    max_fall = 11;
    jump_cut_speed = 3.2;       // let go of jump while rising: upward speed is capped to this
    jump_cut_ok = true;         // can letting go of jump shorten this rise?
    last_wall_dir = 0;          // side of the last wall we jumped off (0 = none)
    wall_jump_lock = 10;        // frames of no steering after a wall jump
    corner_max = 4;             // head-bump forgiveness: slide around corners up to this many px
    draw_xs = 1;                // how the sprite is DRAWN (squash/stretch). The collision box never changes.
    draw_ys = 1;

    // --- slopes -> wall climb ---
    slope_climbed = 0;          // pixels climbed on a continuous slope
    slope_timer = 0;
    wall_climb_timer = 0;
    wall_climb_time = 16;       // frames the boost lasts
    wall_climb_dir = 0;
    wall_climb_power = 0;
    wall_climb_min_rise = 12;   // need to have climbed this many px of slope...
    wall_climb_min_speed = 3.6; // ...at this speed or faster
    wall_climb_ratio = 0.85;    // upward speed = horizontal speed * this
    wall_climb_max = 6;

    // --- misc ---
    h_lock = 0;                 // frames where horizontal steering is disabled (springs)
    arrival_done = false;

    // the character name decides which version of the music plays (see scr_music)
    global.character = (object_index == obj_nila) ? "nila" : "stella";
    fx_init();

    if (!instance_exists(obj_controller)) {
        instance_create_depth(0, 0, 0, obj_controller);
    }
    if (!instance_exists(obj_camera)) {
        instance_create_depth(0, 0, 0, obj_camera);
    }
}

function oneway_can_pass(_inst, _dx, _dy) {
    var a = ((_inst.image_angle mod 360) + 360) mod 360;
    if (a == 0 && _dx < 0) return true;
    if (a == 180 && _dx > 0) return true;
    if (a == 90 && _dy < 0) return true;
    if (a == 270 && _dy > 0) return true;
    return false;
}

function player_blocked(_nx, _ny, _dx, _dy) {
    var oldx = x;
    var oldy = y;
    x = _nx;
    y = _ny;

    var blocked = place_meeting(x, y, obj_ground) || place_meeting(x, y, obj_slope);

    if (!blocked && !is_gelatin && place_meeting(x, y, obj_slime_block)) {
        blocked = true;
    }

    if (!blocked && _dy > 0 && drop_timer <= 0) {
        var hs = instance_place(x, y, obj_halfSolid);
        if (hs != noone && bbox_bottom <= hs.bbox_top + 2) {
            blocked = true;
        }
    }

    if (!blocked) {
        var ow = instance_place(x, y, obj_oneway);
        if (ow != noone && !oneway_can_pass(ow, _dx, _dy)) {
            blocked = true;
        }
    }

    x = oldx;
    y = oldy;
    return blocked;
}

// If something (a spawn, a switch, a moving thing) left us INSIDE a solid, pop out
// to the nearest free spot. A safety net so you can never be permanently stuck.
function player_unstick() {
    if (!player_blocked(x, y, 0, 0)) return;
    var dx = [0, 1, -1, 0];
    var dy = [-1, 0, 0, 1];
    for (var r = 1; r <= 8; r++) {
        for (var i = 0; i < 4; i++) {
            if (!player_blocked(x + dx[i] * r, y + dy[i] * r, 0, 0)) {
                x += dx[i] * r;
                y += dy[i] * r;
                return;
            }
        }
    }
}

function player_move_and_collide() {
    player_unstick();
    hit_wall = false;
    landed = false;
    hit_ceil = false;

    var was_grounded = on_ground;   // where we stood at the end of last frame

    hsp_rem += hsp;
    vsp_rem += vsp;

    var hx = round(hsp_rem);
    var vy = round(vsp_rem);
    hsp_rem -= hx;
    vsp_rem -= vy;

    // ---------- horizontal: one pixel at a time ----------
    var sx = sign(hx);
    repeat (abs(hx)) {
        if (!player_blocked(x + sx, y, sx, 0)) {
            x += sx;
        } else {
            // Blocked. Maybe it is a slope or a tiny ledge: try to step UP onto it.
            var stepped = false;
            if (vsp >= 0) {
                for (var s = 1; s <= step_max; s++) {
                    if (!player_blocked(x + sx, y - s, sx, 0)) {
                        y -= s;
                        x += sx;
                        stepped = true;
                        slope_climbed += s;   // remember how much we climbed
                        slope_timer = 6;      // ...for the next 6 frames
                        break;
                    }
                }
            }
            if (!stepped) {
                // A real wall. Did we just run UP a slope into it, fast enough?
                // We must read hsp BEFORE zeroing it, so this check comes first.
                if (was_grounded && wall_climb_timer <= 0
                    && slope_climbed >= wall_climb_min_rise
                    && abs(hsp) >= wall_climb_min_speed) {
                    wall_climb_timer = wall_climb_time;
                    wall_climb_dir = sx;
                    wall_climb_power = min(abs(hsp) * wall_climb_ratio, wall_climb_max);
                }
                hsp = 0;
                hsp_rem = 0;
                hit_wall = true;
                is_dashing = false;
                break;
            }
        }

        // Going DOWNHILL: if the floor fell away under us by a few pixels, stick to it
        // (otherwise we would hop down the slope like a bouncing ball).
        if (was_grounded && vsp >= 0 && !player_blocked(x, y + 1, 0, 1)) {
            for (var d = 1; d <= snap_max; d++) {
                if (player_blocked(x, y + d + 1, 0, 1)) {
                    y += d;
                    break;
                }
            }
        }
    }

    // ---------- vertical: one pixel at a time ----------
    var sy = sign(vy);
    repeat (abs(vy)) {
        if (!player_blocked(x, y + sy, 0, sy)) {
            y += sy;
        } else {
            // HEAD BUMP FORGIVENESS: if we clip just the edge of a ceiling, slide
            // sideways around the corner instead of losing the whole jump.
            var slid = false;
            if (sy < 0) {
                for (var n = 1; n <= corner_max && !slid; n++) {
                    for (var side = -1; side <= 1 && !slid; side += 2) {
                        if (!player_blocked(x + n * side, y - 1, 0, -1) && !player_blocked(x + n * side, y, 0, 0)) {
                            x += n * side;
                            y -= 1;
                            slid = true;
                        }
                    }
                }
            }
            if (!slid) {
                if (sy > 0) landed = true;
                if (sy < 0) hit_ceil = true;
                vsp = 0;
                vsp_rem = 0;
                break;
            }
        }
    }
}

// ---------------------------------------------------------------------------
// SMALL SHARED HELPERS (used by both Stella and Nila)
// ---------------------------------------------------------------------------

// Counts down every timer once per frame.
function player_tick_timers() {
    if (spring_timer > 0) spring_timer--;
    if (h_lock > 0) h_lock--;
    if (slope_timer > 0) slope_timer--;
    else slope_climbed = 0;           // forgot the slope after 6 frames without climbing
}

// Horizontal movement while in the AIR.
//   _move   = -1 / 0 / 1 (what the player is pressing)
//   _target = the speed we would like to reach
//   _ref    = a reference speed that scales the steering strength
function player_air_move(_move, _target, _ref) {
    if (_move == 0) {
        // Not pressing anything: only slow down gently (momentum!).
        hsp = scr_approach(hsp, 0, air_drag);
    } else if (sign(hsp) == _move && abs(hsp) > abs(_target)) {
        // Already faster than our target in the pressed direction (after a dash or spring):
        // do NOT brake hard, just ease down.
        hsp = scr_approach(hsp, _target, air_drag);
    } else if (sign(hsp) == -_move) {
        // Pushing against our motion = trying to turn around. Weak on purpose.
        hsp = scr_approach(hsp, _target, air_turn_accel * _ref);
    } else {
        // Speeding up in the same direction.
        hsp = scr_approach(hsp, _target, air_accel * _ref);
    }
}

// Gravity. Three different feelings: rising (holding jump), rising (let go = cut), falling.
function player_apply_gravity(_input) {
    var g = is_gelatin ? gelatin_grav : 1;

    // JUMP CUT: letting go of jump while rising caps the upward speed.
    // (The old version did vsp *= 0.6 every frame. A number multiplied by 0.6 gets tiny
    //  but never reaches 0, so the game kept "cutting" and you hovered. A cap fixes it.)
    if (vsp < 0 && !_input.jump_h && jump_cut_ok) {
        vsp = max(vsp, -jump_cut_speed);
    }

    vsp += (vsp < 0 ? grav_rise : grav_fall) * g;
    vsp = min(vsp, max_fall);
}

// The "ran up a slope into a wall" boost. Returns true while it is pushing us up.
function player_wall_climb_update(_input) {
    if (wall_climb_timer <= 0) return false;

    // Cancel if the player lets go of the direction, or bonks a ceiling.
    if (_input.move != wall_climb_dir || hit_ceil) {
        wall_climb_timer = 0;
        return false;
    }

    var t = wall_climb_timer / wall_climb_time;   // 1.0 at the start -> 0 at the end
    vsp = -wall_climb_power * t;                  // strong first, fading out
    wall_climb_timer--;
    jump_cut_ok = false;
    return true;
}

// Called BY a spring (self = the spring) when a player touches it.
function spring_launch(_p) {
    if (cooldown > 0) return false;

    var vx = lengthdir_x(launch_speed, launch_angle);
    var vy = lengthdir_y(launch_speed, launch_angle);

    with (_p) {
        // Sideways part: if the spring throws us left/right, keep whichever is FASTER
        // (our own speed or the spring's) when they point the same way. A straight-up
        // spring (vx ~ 0) leaves our horizontal speed completely alone.
        if (abs(vx) > 0.5) {
            if (sign(hsp) == sign(vx)) hsp = sign(vx) * max(abs(hsp), abs(vx));
            else hsp = vx;
        }
        vsp = vy;
        hsp_rem = 0;
        vsp_rem = 0;
        spring_timer = other.lock_time;                        // `other` = the spring
        h_lock = (abs(vx) > 0.5) ? other.h_lock_time : 0;        // only lock steering if it throws us sideways
        jump_cut_ok = false;                                   // letting go of jump must NOT shorten a spring
        is_dashing = false;
        wall_climb_timer = 0;
        air_dash_used = false;
        on_ground = false;
        coyote_timer = 0;
        squash_x = 0.8;
        squash_y = 1.3;
    }

    cooldown = cooldown_max;
    pop = 1;
    fx_dust(x + sprite_width / 2, y + sprite_height / 2, 8);
    return true;
}

function player_set_gelatin(_on) {
    if (object_index != obj_stella) return;

    if (_on) {
        is_gelatin = true;
        sprite_index = spr_stella_gelatin;
        squash_x = 1.18;
        squash_y = 0.82;
    } else {
        var was = is_gelatin;
        is_gelatin = false;
        if (was && player_blocked(x, y, 0, 0)) {
            is_gelatin = true;
            return;
        }
        sprite_index = spr_stella;
    }
}

function player_hurt(_dmg) {
    if (inv_timer > 0) return;

    hp -= _dmg;
    inv_timer = 55;
    is_dashing = false;
    hsp = -facing * 3.2;
    vsp = -4.2;
    squash_x = 0.75;
    squash_y = 1.2;
    global.cam_shake = 8;

    if (hp <= 0) {
        player_respawn(true);
    }
}

function player_respawn(_reset_hp) {
    x = last_safe_x;
    y = last_safe_y;
    hsp = 0;
    vsp = 0;
    hsp_rem = 0;
    vsp_rem = 0;
    is_dashing = false;
    dash_time = 0;
    spring_timer = 0;
    coyote_timer = 0;
    jump_buffer = 0;
    on_ground = false;
    inv_timer = 40;
    global.cam_shake = 6;
    if (_reset_hp) hp = hp_max;
}

function player_update_ground(_input) {
    var grounded_now = landed || player_blocked(x, y + 1, 0, 1);

    if (grounded_now) {
        if (!on_ground) {
            squash_x = 1.18;
            squash_y = 0.72;
            fx_dust(x, bbox_bottom, 8);
            global.cam_shake = max(global.cam_shake, min(3, abs(vsp) * 0.15));
        }
        on_ground = true;
        jump_cut_ok = true;
        last_wall_dir = 0;      // touching the ground makes every wall usable again
        coyote_timer = coyote_max;
        air_dash_used = false;
        last_safe_x = x;
        last_safe_y = y;
    } else {
        on_ground = false;
        coyote_timer = max(0, coyote_timer - 1);
    }

    was_on_ground = on_ground;

    if (y > room_height + 48) {
        player_hurt(2);
        player_respawn(false);
    }
}

function player_update_squash() {
    var target_x = 1;
    var target_y = 1;

    if (is_gelatin && !is_dashing) {
        var wob = sin(current_time / 110) * 0.08;
        target_x = 1 + wob;
        target_y = 1 - wob;
    }

    squash_x = lerp(squash_x, target_x, 0.18);
    squash_y = lerp(squash_y, target_y, 0.18);

    var face = facing;
    if (is_dashing) face = dash_dir;
    if (on_wall && !on_ground) face = -wall_dir;

    // IMPORTANT: image_xscale/yscale also scale the COLLISION MASK. So the instance always
    // stays at scale 1 and the squash is applied only when drawing (see player_draw).
    image_xscale = 1;
    image_yscale = 1;
    draw_xs = face * squash_x;
    draw_ys = squash_y;

    if (inv_timer > 0) {
        image_alpha = (inv_timer div 4) mod 2 == 0 ? 1 : 0.4;
        inv_timer--;
    } else {
        image_alpha = 1;
    }
}

// Draws the sprite squashed/stretched but keeps the FEET on the floor.
function player_draw() {
    var half_h = sprite_get_height(sprite_index) / 2;
    draw_sprite_ext(sprite_index, image_index, x, y + half_h * (1 - draw_ys), draw_xs, draw_ys, 0, c_white, image_alpha);
}

// Shared wall jump for every character.
//   _kick_h = sideways speed away from the wall, _kick_v = upward speed (negative).
// Rules: you can't wall jump off the SAME wall twice in a row (alternate walls, or land
// first), and you can't steer for a few frames (wall_jump_lock) so you really leave the wall.
function player_try_wall_jump(_input, _kick_h, _kick_v) {
    if (!_input.jump_p || !on_wall || on_ground) return false;
    if (wall_dir == last_wall_dir) return false;

    vsp = _kick_v;
    hsp = -wall_dir * _kick_h;
    facing = -wall_dir;
    last_wall_dir = wall_dir;
    h_lock = wall_jump_lock;
    on_wall = false;
    jump_buffer = 0;
    coyote_timer = 0;
    air_dash_used = false;
    wall_climb_timer = 0;
    jump_cut_ok = true;
    squash_x = 0.82;
    squash_y = 1.18;
    fx_dust(x - facing * 14, y, 5);
    return true;
}

function player_try_jump(_input, _jump_spd) {
    if (drop_timer > 0) drop_timer--;

    if (_input.down && _input.jump_p && on_ground) {
        drop_timer = 8;
        y += 1;
        on_ground = false;
        coyote_timer = 0;
        jump_buffer = 0;
        vsp = 1.5;
        return false;
    }

    if (jump_buffer > 0 && coyote_timer > 0 && !is_dashing) {
        vsp = _jump_spd;
        jump_cut_ok = true;
        wall_climb_timer = 0;
        if (is_gelatin) vsp -= 0.8;
        jump_buffer = 0;
        coyote_timer = 0;
        on_ground = false;
        squash_x = 0.78;
        squash_y = 1.22;
        fx_dust(x, bbox_bottom, 5);
        if (_input.move != 0) hsp += _input.move * 0.2;
        return true;
    }
    return false;
}
