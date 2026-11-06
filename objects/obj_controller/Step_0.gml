// R = RETRY: reload this room (with the fade) and undo any score picked up in it.
// (The old R only teleported you to where you were already standing.)
if (keyboard_check_pressed(ord("R")) && global.fade_state == 0) {
    global.score = global.score_at_room_start;
    room_transition(room);
}

// TAB = switch character (Stella <-> Nila). Also gamepad Select/Back.
if ((keyboard_check_pressed(vk_tab) || gamepad_button_check_pressed(0, gp_select)) && global.fade_state == 0) {
    character_switch();
}

if (global.cam_shake > 0) global.cam_shake = max(0, global.cam_shake - 0.45);

if (keyboard_check_pressed(vk_f3)) global.debug_draw = !global.debug_draw;

// M = mute / unmute ALL audio (master volume 0 or 1)
if (keyboard_check_pressed(ord("M"))) {
    global.muted = !global.muted;
    audio_master_gain(global.muted ? 0 : 1);
}

// --- room transition state machine ---
if (global.fade_state == 1) {
    global.fade_alpha = min(1, global.fade_alpha + fade_speed);
    if (global.fade_alpha >= 1) {
        room_goto(global.fade_room);   // happens at the end of this frame, while the screen is black
        global.fade_state = 2;
    }
} else if (global.fade_state == 2) {
    global.fade_alpha = max(0, global.fade_alpha - fade_speed);
    if (global.fade_alpha <= 0) {
        global.fade_state = 0;
        global.transitioning = false;   // give the player control back
        global.arrive_door = "";
    }
}
