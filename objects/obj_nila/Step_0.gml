var input = player_read_input();
var move = input.move;
var run = input.sprint;

if (move != 0) facing = move;

if (input.jump_p) jump_buffer = jump_buffer_max;
else jump_buffer = max(0, jump_buffer - 1);

player_check_arrival();   // first frame in a room: appear at the door we came through
player_tick_timers();     // counts down spring_timer, h_lock, slope_timer

// Walking speed unless running. (Before, the target in the air was 0 unless Shift was held.)
var target = 0;
if (move != 0) target = move * (run ? run_max : walk_speed);

if (on_ground && move != 0 && sign(hsp) != 0 && sign(hsp) != move && abs(hsp) > walk_speed) {
    skid_timer = skid_max;
    squash_x = 1.15;
    squash_y = 0.88;
}

if (skid_timer > 0) {
    skid_timer--;
    hsp *= 0.85;
} else if (h_lock > 0) {
    // a spring threw us sideways: keep the momentum, no steering for a moment
} else if (on_ground) {
    var a = abs(hsp) < run_mid ? accel_fast : accel_slow;
    if (move != 0 && sign(hsp) == -move) a *= turn_boost;   // snappy turn-around
    hsp = scr_approach(hsp, target, a * max(abs(target), walk_speed));
} else {
    player_air_move(move, target, run_max);
}

if (move == 0 && on_ground && h_lock <= 0) hsp = scr_approach(hsp, 0, friction * walk_speed);

if (attack_cd > 0) attack_cd--;
if (air_attack_lock > 0) air_attack_lock--;

if (input.action_p && attack_cd <= 0) {
    var list = ds_list_create();
    var cnt = collision_circle_list(x, y, 24, obj_EEEEVIL, false, false, list, false);
    for (var i = 0; i < cnt; i++) {
        var e = list[| i];
        e.spd = max(0, e.spd - 6);
        e.x += sign(e.x - x) * 8;
    }
    // NEW: the attack also damages every enemy (obj_enemy_parent) around her
    ds_list_clear(list);
    var ecnt = collision_circle_list(x, y, 30, obj_enemy_parent, false, false, list, false);
    for (var j = 0; j < ecnt; j++) {
        with (list[| j]) enemy_hurt(1);
    }
    ds_list_destroy(list);

    if (!on_ground && !air_attack_used && air_attack_lock <= 0) {
        vsp = (keyboard_check(vk_up) || keyboard_check(ord("W"))) ? spin_jump : attack_jump;
        air_attack_used = true;
        air_attack_lock = 14;
        squash_x = 0.85;
        squash_y = 1.2;
    }

    if (run && on_ground) hsp *= run_boost;
    attack_cd = 16;
}

on_wall = false;
wall_dir = 0;
if (!on_ground) {
    if (player_blocked(x + 1, y, 1, 0)) { on_wall = true; wall_dir = 1; }
    else if (player_blocked(x - 1, y, -1, 0)) { on_wall = true; wall_dir = -1; }
}

player_wall_memory();

// 1) A wall jump beats everything else while on a wall (buffer + coyote + same-wall rule)
var wall_jumped = player_try_wall_jump(input, walk_speed + 2.4, jump_speed);
if (wall_jumped) air_attack_used = false;

// 2) WALL CLIMB: hold toward the wall. One fixed climb speed, limited stamina,
//    refilled on the ground. (Before: the speed depended on hsp and could change mid-climb.)
if (on_ground) climb_stamina = climb_stamina_max;

var climbing = false;
if (!wall_jumped && !on_ground && on_wall && move == wall_dir && wall_dir != last_wall_dir && climb_stamina > 0) {
    climbing = true;
    climb_dir = wall_dir;
    climb_stamina--;
    vsp = scr_approach(vsp, wall_climb_speed, 1.4);   // ease to the climb speed, never snap
}

// 3) The wall ended while we were climbing: hop up and forward onto the ledge.
if (was_climbing && !climbing && !on_wall && !wall_jumped && move == climb_dir) {
    vsp = -5.2;
    hsp = climb_dir * 3.8;
    h_lock = 6;
    fx_dust(x, bbox_bottom, 5);
}
was_climbing = climbing;

var climbing_up = player_wall_climb_update(input);   // slope-run boost up a wall
if (!climbing && spring_timer <= 0 && !climbing_up) {
    player_apply_gravity(input);
}

// 4) Holding toward a wall with no stamina left: slide down it (after gravity, so the cap holds).
if (!climbing && on_wall && move == wall_dir && vsp > 0) vsp = min(vsp, wall_slide_speed);

player_try_jump(input, jump_speed);
var old_h = hsp;
player_move_and_collide();
if (hit_wall && on_ground && abs(old_h) >= run_mid && wall_climb_timer <= 0) {
    hsp = -old_h * 0.3;
    vsp = -2.2;
}
player_update_ground(input);

if (air_attack_used && on_ground) air_attack_used = false;

player_update_squash();
