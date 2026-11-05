var target = noone;
if (instance_exists(obj_stella)) target = obj_stella;
else if (instance_exists(obj_nila)) target = obj_nila;
if (target == noone) exit;

cam_w = camera_get_view_width(cam);
cam_h = camera_get_view_height(cam);

var face = 1;
if (variable_instance_exists(target, "facing")) face = target.facing;

look_x = lerp(look_x, face * 48, 0.08);
var look_down = 0;
if (variable_instance_exists(target, "vsp") && target.vsp > 2.5) look_down = min(40, target.vsp * 6);

var tx = target.x - cam_w * 0.5 + look_x;
var ty = target.y - cam_h * 0.58 + look_down;

tx = clamp(tx, 0, max(0, room_width - cam_w));
ty = clamp(ty, 0, max(0, room_height - cam_h));

if (target != last_target) {
    follow_x = tx;
    follow_y = ty;
    last_target = target;
} else {
    follow_x = lerp(follow_x, tx, smooth);
    follow_y = lerp(follow_y, ty, smooth);
}

var sx = 0;
var sy = 0;
if (global.cam_shake > 0) {
    sx = random_range(-global.cam_shake, global.cam_shake);
    sy = random_range(-global.cam_shake, global.cam_shake);
}

camera_set_view_pos(cam, follow_x + sx, follow_y + sy);
