var input = player_read_input();
var move = input.move;
var sprint = input.sprint;

player_check_arrival();   // first frame in a room: appear at the door we came through
player_tick_timers();     // counts down spring_timer, h_lock, slope_timer

if (input.jump_p) jump_buffer = jump_buffer_max;
else jump_buffer = max(0, jump_buffer - 1);

if (dash_cooldown > 0) dash_cooldown--;

// --- DASH JUMP: pressing jump during a dash cancels the dash but KEEPS its speed ---
if (is_dashing && jump_buffer > 0 && coyote_timer > 0) {
    is_dashing = false;
    hsp = dash_dir * dash_speed * 0.9;
    h_lock = 3;           // a few frames with no friction so the speed survives the takeoff
}

// --- dash (ground or one air dash) ---
var can_air_dash = on_ground || !air_dash_used;
if (input.action_p && dash_cooldown <= 0 && !is_dashing && can_air_dash) {
    is_dashing = true;
    dash_time = dash_time_max;
    dash_dir = (move != 0) ? move : facing;
    dash_cooldown = dash_cooldown_max;
    vsp = 0;
    wall_climb_timer = 0;
    if (!on_ground) air_dash_used = true;
    squash_x = 1.35;
    squash_y = 0.7;
    fx_dust(x - dash_dir * 12, bbox_bottom, 6);
}

// --- horizontal movement ---
var max_speed = sprint ? run_speed : walk_speed;
if (is_gelatin) max_speed *= 0.92;
var target = move * max_speed;

// A spring throw / wall jump (h_lock) or a dash takes over steering for a few frames.
if (!is_dashing && spring_timer <= 0 && h_lock <= 0) {
    if (on_ground) {
        var accel_use = sprint ? run_accel : accel;
        var reversing = (move != 0 && sign(hsp) == -move);
        if (reversing) {
            accel_use *= turn_boost;                               // turn around FAST
            if (abs(hsp) > walk_speed) fx_dust(x, bbox_bottom, 1); // little skid puff
        }
        hsp = scr_approach(hsp, target, accel_use * max_speed);
        if (move == 0) hsp = scr_approach(hsp, 0, friction * max_speed);
    } else {
        player_air_move(move, target, max_speed);   // weaker steering, keeps momentum
    }
}

// --- wall detection first, so every wall rule below can use it ---
on_wall = false;
wall_dir = 0;
if (!on_ground && !is_dashing) {
    if (player_blocked(x + 1, y, 1, 0)) { on_wall = true; wall_dir = 1; }
    else if (player_blocked(x - 1, y, -1, 0)) { on_wall = true; wall_dir = -1; }
}
player_wall_memory();
player_try_wall_jump(input, wall_jump_hsp, wall_jump_vsp);   // buffer + coyote + same-wall rule: see scr_platformer

// --- vertical movement ---
var climbing_up = player_wall_climb_update(input);   // slope-run boost up a wall

if (is_dashing) {
    hsp = dash_dir * dash_speed;
    vsp = 0;
    dash_time--;
    if (dash_time mod 2 == 0) fx_dust(x - dash_dir * 10, y + 6, 1);   // dash trail
    if (dash_time <= 0) {
        is_dashing = false;
        hsp = dash_dir * run_speed * 1.2;   // ease out of the dash instead of stopping dead
    }
} else if (spring_timer <= 0 && !climbing_up) {
    player_apply_gravity(input);
}

if (on_wall && move == wall_dir && vsp > 0) {
    vsp = min(vsp, wall_slide_speed);   // wall slide
}

player_try_jump(input, jump_speed);
player_move_and_collide();
player_update_ground(input);

if (move != 0 && !is_dashing) facing = move;

player_update_squash();
