player_init_common();

walk_speed = 7.6;
run_max = 13.2;
run_mid = 10.8;

accel_fast = 0.28;
accel_slow = 0.08;
// air control: weaker steering, and turning around mid-air is even weaker
air_accel      = 0.05;
air_turn_accel = 0.025;
air_drag       = 0.08;
friction = 0.24;

// peak height ~ jump_speed^2 / (2 * grav_rise)  ->  8^2 / 0.72 = ~90 px
jump_speed = -8.0;
grav_rise = 0.36;
grav_fall = 0.9;
max_fall = 12;
jump_cut_speed = 3.2;   // see obj_stella: caps upward speed when jump is released

coyote_max = 7;
jump_buffer_max = 7;

wall_climb_speed = -2.8;

attack_cd = 0;
air_attack_used = false;
air_attack_lock = 0;
attack_jump = -6.4;
spin_jump = -8.4;
run_boost = 1.06;

was_climbing = false;
skid_timer = 0;
skid_max = 6;

hp_max = 9;
hp = hp_max;
