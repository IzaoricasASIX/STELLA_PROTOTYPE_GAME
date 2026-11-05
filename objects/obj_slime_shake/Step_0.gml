var p = instance_place(x, y, obj_player_parent);
if (p == noone) exit;

with (p) player_set_gelatin(true);
instance_destroy();
