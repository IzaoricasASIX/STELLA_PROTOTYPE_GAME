var p = instance_place(x, y, obj_player_parent);
if (p == noone) exit;

with (p) {
    player_hurt(2);
    player_respawn(false);
}
