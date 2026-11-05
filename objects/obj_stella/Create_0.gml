// Controls: Arrows / WASD move · Z / Space jump · X dash · Shift run · Down+jump drop through
player_init_common();   // shared defaults live in scr_platformer -> player_init_common()

// ---------- ground movement ----------
walk_speed = 5.4;
run_speed  = 9.6;

accel     = 0.38;
run_accel = 0.5;
friction  = 0.28;

// ---------- air control (the "can't turn much in the air" part) ----------
air_accel      = 0.12;   // steering in the direction you already move  (was 0.22)
air_turn_accel = 0.06;   // steering AGAINST your motion: low = committed jumps
air_drag       = 0.10;   // slowdown per frame if you let go of the stick

// ---------- jump (the "less high, less floaty" part) ----------
// Peak height is roughly  jump_speed^2 / (2 * grav_rise).
// Before: 8.15^2 / (2 * 0.19) = ~175 px.   Now: 8.4^2 / (2 * 0.36) = ~98 px (about 3 tiles).
jump_speed = -8.4;
grav_rise  = 0.36;   // gravity while going up (before: effectively 0.19!)
grav_fall  = 0.9;    // gravity while falling: bigger = snappier landings
max_fall   = 12;
jump_cut_speed = 3.2; // let go of jump while rising: upward speed is capped to this. Bigger = taller short-hops

coyote_max = 8;
jump_buffer_max = 8;

wall_slide_speed = 1.35;
wall_jump_hsp = 4.8;   // sideways kick away from the wall (was 5.8)
wall_jump_vsp = -7.6;

dash_speed = 8.4;
dash_time_max = 8;
dash_cooldown_max = 16;

hp_max = 10;
hp = hp_max;
