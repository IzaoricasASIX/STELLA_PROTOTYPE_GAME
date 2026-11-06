var touching = place_meeting(x, y, obj_player_parent);

if (!armed) {
    if (!touching) armed = true;
} else if (touching && target_room != noone) {
    room_transition(target_room, target_door);
    armed = false;
}
