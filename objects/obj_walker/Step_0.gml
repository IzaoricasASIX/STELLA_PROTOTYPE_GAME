if (hit_flash > 0) hit_flash--;
image_blend = (hit_flash > 0) ? c_red : c_white;

// ---- gravity (pixel by pixel, like the players) ----
vsp = min(vsp + grav, 14);
var vy = round(vsp);
repeat (abs(vy)) {
    if (!enemy_solid_at(x, y + sign(vy))) y += sign(vy);
    else { vsp = 0; break; }
}

// ---- patrol ----
if (enemy_solid_at(x, y + 1)) {
    var moved = false;
    // try straight ahead, then 1..3 px UP (that is how we climb slopes)
    for (var s = 0; s <= 3 && !moved; s++) {
        if (!enemy_solid_at(x + dir * spd, y - s)) {
            x += dir * spd;
            y -= s;
            moved = true;
        }
    }
    if (!moved) dir = -dir;                          // wall: turn around
    else if (!enemy_floor_ahead(dir)) dir = -dir;    // ledge: turn around instead of falling
}

image_xscale = dir;   // the mask is symmetric (origin is the centre), so flipping is safe

enemy_touch_player();
