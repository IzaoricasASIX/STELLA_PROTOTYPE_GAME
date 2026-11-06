// Controls: Arrows / WASD move · Z / Space jump · X dash · Shift run · Down+jump drop through · Down in air = fast fall
player_init_common();   // shared defaults live in scr_platformer -> player_init_common()

// ---------- ground movement (snappy: reach top speed in ~2 frames, stop in ~3) ----------
walk_speed = 5.6;
run_speed  = 8.0;

accel     = 0.50;
run_accel = 0.60;
friction  = 0.42;
turn_boost = 2.0;      // reversing direction accelerates twice as hard

// ---------- air control ----------
air_accel      = 0.16;   // steering in the direction you already move
air_turn_accel = 0.07;   // steering AGAINST your motion: low = committed jumps
air_drag       = 0.10;   // slowdown per frame if you let go of the stick

// ---------- jump ----------
// Peak height is roughly  jump_speed^2 / (2 * grav_rise)  ->  8.8^2 / 0.8 = ~100 px (about 3 tiles)
jump_speed = -8.8;
grav_rise  = 0.40;       // gravity while going up
grav_fall  = 1.0;        // gravity while falling: bigger = snappier landings
jump_cut_speed = 3.2;    // let go of jump while rising: upward speed is capped to this. Bigger = taller short-hops

// ---------- falling: NO hard cap ----------
fall_soft_speed  = 12;   // past this speed we keep accelerating, but...
fall_slow_factor = 0.35; // ...gravity is multiplied by this (smaller = slower build-up)
fast_fall_mult   = 1.5;  // hold Down while falling

coyote_max = 9;          // frames you can still jump after walking off a ledge
jump_buffer_max = 10;    // frames a jump press is remembered before landing / touching a wall

wall_slide_speed = 1.35;
wall_jump_hsp = 5.0;     // sideways kick away from the wall
wall_jump_vsp = -8.0;

dash_speed = 9.4;
dash_time_max = 7;
dash_cooldown_max = 14;

hp_max = 10;
hp = hp_max;
