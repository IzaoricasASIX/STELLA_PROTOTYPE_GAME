// ==================================================
// FIND NEAREST PLAYER (ANY CHARACTER)
// ==================================================
player = instance_nearest(x, y, obj_player_parent);
if (!instance_exists(player)) exit;

// ==================================================
// RUBBERBANDING SPEED
// ==================================================
var d = point_distance(x, y, player.x, player.y);

var t_spd = lerp(
    min_spd,
    max_spd,
    clamp(d / rubber_dist, 0, 1)
);

// Fast acceleration, slow deceleration
if (spd < t_spd) {
    spd += accel;
} else {
    spd = lerp(spd, t_spd, decel);
}

// ==================================================
// MOVE TOWARD PLAYER
// ==================================================
var dir = point_direction(x, y, player.x, player.y);

x += lengthdir_x(spd, dir);
y += lengthdir_y(spd, dir);

// ==================================================
// SPRITE TURNING (SNAP)
// ==================================================
var face_dir = sign(player.x - x);
if (face_dir != 0) {
    image_xscale = face_dir;
}

// ==================================================
// LEAN / TILT (PIZZAFACE FEEL)
// ==================================================
var max_tilt = 12;
image_angle = clamp(spd * 1.2, 0, max_tilt) * image_xscale;

// Slight jitter at high speed
if (spd > max_spd * 0.85) {
    image_angle += random_range(-1, 1);
}

var p = instance_place(x, y, obj_player_parent);
if (p != noone) {
    with (p) player_hurt(2);
}
