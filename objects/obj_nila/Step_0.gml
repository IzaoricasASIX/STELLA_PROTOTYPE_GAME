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

var climbing = false;
if (on_wall && move == wall_dir && !on_ground) {
    climbing = true;
    vsp = min(vsp, wall_climb_speed - abs(hsp) * 0.08);
}

if (was_climbing && !climbing) {
    hsp = clamp(hsp + (-vsp * 0.55) * facing, -run_max, run_max);
    vsp = 0;
}
was_climbing = climbing;

if (player_try_wall_jump(input, walk_speed + 2.2, jump_speed)) air_attack_used = false;

var climbing_up = player_wall_climb_update(input);   // slope-run boost up a wall
if (!climbing && spring_timer <= 0 && !climbing_up) {
    player_apply_gravity(input);
}

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
