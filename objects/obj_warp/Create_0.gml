// TOUCH-TO-TRAVEL trigger (not a door: no key press needed). Resize it in the room editor
// with the scale handles; it can be a thin strip at the edge of a room.
// Select it -> Properties -> Creation Code, for example:
//
//     target_room = FOREST_1;       // where to go
//     target_door = "forest_1_left" // the door_id of an obj_door, obj_warp or obj_spawn over there
//     door_id     = "forest_0_right"// (optional) lets OTHER rooms arrive here
//
// Leave target_door as "" to appear at the other room's normal player start.
target_room = noone;
target_door = "";
door_id     = "";
armed       = false;   // only becomes true once the player is NOT touching us.
                       // (Otherwise arriving on top of a warp would send you straight back.)
