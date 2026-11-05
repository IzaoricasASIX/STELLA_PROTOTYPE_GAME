// We draw the sprite ourselves so it can point along launch_angle and squash when used.
// (The collision box stays an upright square. The drawing is just for show.)
var w = abs(sprite_width);
var h = abs(sprite_height);
var cx = x + w / 2;      // centre of the spring
var cy = y + h / 2;

var a  = launch_angle - 90;   // the sprite points UP at 0, which is launch_angle 90
var xs = image_xscale * (1 + pop * 0.25);
var ys = image_yscale * (1 - pop * 0.4);

// The sprite's origin is its top-left corner, so to rotate around the CENTRE
// we rotate the corner's offset by hand.
var ox = -sprite_get_width(sprite_index)  * xs / 2;
var oy = -sprite_get_height(sprite_index) * ys / 2;
var rx = ox *  dcos(a) + oy * dsin(a);
var ry = ox * -dsin(a) + oy * dcos(a);

draw_sprite_ext(sprite_index, image_index, cx + rx, cy + ry, xs, ys, a, c_white, 1);

// ----- Press F3 in game to see where each spring will throw you -----
if (variable_global_exists("debug_draw") && global.debug_draw) {
    var p = instance_find(obj_player_parent, 0);
    var g_up   = (p != noone) ? p.grav_rise : 0.36;
    var g_down = (p != noone) ? p.grav_fall : 0.9;

    var px = cx;
    var py = cy;
    var vx = lengthdir_x(launch_speed, launch_angle);
    var vy = lengthdir_y(launch_speed, launch_angle);

    draw_set_color(c_yellow);
    for (var i = 0; i < 80; i++) {
        px += vx;
        py += vy;
        if (i >= lock_time) vy += (vy < 0) ? g_up : g_down;   // same gravity rules as the player
        if (i mod 3 == 0) draw_circle(px, py, 2, false);
    }
    draw_set_color(c_white);
}
