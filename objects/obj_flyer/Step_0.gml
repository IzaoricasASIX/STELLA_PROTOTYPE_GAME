if (hit_flash > 0) hit_flash--;
image_blend = (hit_flash > 0) ? c_red : c_white;

t++;
var p = instance_nearest(x, y, obj_player_parent);
var dist = (p != noone) ? point_distance(x, y, p.x, p.y) : 99999;

if (state == 0) {
    // IDLE: glide toward a point that slowly moves in a figure-eight around home
    var gx = home_x + sin(t * 0.03) * idle_range_x;
    var gy = home_y + sin(t * 0.07) * idle_range_y;
    x = lerp(x, gx, 0.08);
    y = lerp(y, gy, 0.08);
    if (dist < wake_dist) { state = 1; fx_dust(x, y, 4); }
}
else if (state == 1) {
    // CHASE: fly straight at the player, with a little vertical wobble
    var d = point_direction(x, y, p.x, p.y);
    x += lengthdir_x(chase_spd, d);
    y += lengthdir_y(chase_spd, d) + sin(t * 0.25) * 0.6;
    if (dist > lose_dist) state = 2;
}
else {
    // GO HOME
    var d2 = point_direction(x, y, home_x, home_y);
    x += lengthdir_x(chase_spd, d2);
    y += lengthdir_y(chase_spd, d2);
    if (point_distance(x, y, home_x, home_y) < 6) state = 0;
    else if (dist < wake_dist * 0.7) state = 1;
}

if (p != noone) image_xscale = (p.x < x) ? -1 : 1;   // face the player

enemy_touch_player();
