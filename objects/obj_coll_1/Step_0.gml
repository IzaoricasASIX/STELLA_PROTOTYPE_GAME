if (place_meeting(x, y, obj_player_parent)) {
    global.score += 5;
    instance_destroy();
}
