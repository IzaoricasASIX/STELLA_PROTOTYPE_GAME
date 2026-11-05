// Stand near the terminal and press P or C to swap character
// (same function Tab uses: keeps speed/hp and switches the music too).
var near = false;
with (obj_player_parent) {
    if (point_distance(x, y, other.x, other.y) < 32) near = true;
}

if (near && (keyboard_check_pressed(ord("P")) || keyboard_check_pressed(ord("C")))) {
    character_switch();
}
