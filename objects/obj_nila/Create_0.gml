player_init_common();

walk_speed = 3.8;
run_max = 9.2;
run_mid = 6.8;

accel_fast = 0.28;
accel_slow = 0.11;
// air control: weaker steering, and turning around mid-air is even weaker
air_accel      = 0.07;
air_turn_accel = 0.03;
air_drag       = 0.08;
friction = 0.32;
turn_boost = 1.8;     // reversing direction on the ground accelerates this much harder

// peak height ~ jump_speed^2 / (2 * grav_rise)  ->  8.4^2 / 0.8 = ~90 px
jump_speed = -8.4;
grav_rise = 0.40;
grav_fall = 1.0;

// falling has no hard cap: past fall_soft_speed gravity is multiplied by fall_slow_factor
fall_soft_speed = 12;
fall_slow_factor = 0.35;
fast_fall_mult = 1.5;
jump_cut_speed = 3.2;   // see obj_stella: caps upward speed when jump is released

coyote_max = 8;
jump_buffer_max = 9;

// ---- wall climb: hold toward a wall in the air ----
wall_climb_speed = -3.2;    // fixed upward speed while climbing (same every time)
climb_stamina_max = 75;     // frames of climbing available; refills when you touch the ground
climb_stamina = climb_stamina_max;
climb_dir = 0;
wall_slide_speed = 1.6;     // when stamina runs out you slide, like Stella

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
