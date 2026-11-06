// ---------------------------------------------------------------------------
// ENEMY HELPERS. Every enemy is a child of obj_enemy_parent and calls these.
//   * enemy_touch_player()  : stomp it from above = it dies and you bounce.
//                             Stella dashing through it = it dies.
//                             Touch it any other way = you get hurt.
//   * enemy_hurt(dmg)       : lower hp, flash, die at 0.
// Nila's attack (X) calls enemy_hurt() on everything around her (see obj_nila Step).
// ---------------------------------------------------------------------------

// Is there solid ground at the enemy's position (self = the enemy)?
function enemy_solid_at(_x, _y) {
    return place_meeting(_x, _y, obj_ground) || place_meeting(_x, _y, obj_slope) || place_meeting(_x, _y, obj_slime_block);
}

// Is there any floor in the column just ahead of our feet? (to stop at ledges)
function enemy_floor_ahead(_dir) {
    var fx = x + _dir * (abs(sprite_width) / 2 + 2);
    var y1 = bbox_bottom - 2;
    var y2 = bbox_bottom + 26;     // look up to ~26px down: also works for downhill slopes
    return collision_line(fx, y1, fx, y2, obj_ground, false, true) != noone
        || collision_line(fx, y1, fx, y2, obj_slope, false, true) != noone
        || collision_line(fx, y1, fx, y2, obj_halfSolid, false, true) != noone;
}

function enemy_hurt(_dmg) {
    if (dead) return;
    hp -= _dmg;
    hit_flash = 6;
    if (hp <= 0) enemy_die();
}

function enemy_die() {
    dead = true;
    fx_dust(x, y, 14);
    global.score += 10;
    global.cam_shake = max(global.cam_shake, 3);
    instance_destroy();
}

function enemy_touch_player() {
    if (dead) return;
    var p = instance_place(x, y, obj_player_parent);
    if (p == noone) return;

    // STOMP: the player is falling AND last frame his feet were above our top.
    var prev_feet = p.bbox_bottom - max(p.vsp, 0);
    var stomp = (p.vsp > 0 && prev_feet <= bbox_top + 10);

    if (stomp) {
        enemy_hurt(1);
        with (p) {
            vsp = -8.6;            // bounce! Hold jump to bounce higher (jump cut works as usual)
            jump_cut_ok = true;
            air_dash_used = false; // stomping refills your air dash...
            if (variable_instance_exists(id, "air_attack_used")) air_attack_used = false;   // ...and Nila's air attack
            squash_x = 0.8;
            squash_y = 1.25;
        }
    } else if (p.is_dashing) {
        enemy_hurt(1);             // Stella's dash is also an attack
    } else {
        with (p) player_hurt(other.contact_dmg, other.x);   // `other` = the enemy
    }
}
