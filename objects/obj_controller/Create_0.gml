if (instance_number(object_index) > 1) {
    instance_destroy();
    exit;
}

persistent = true;

if (!variable_global_exists("score")) global.score = 0;
if (!variable_global_exists("cam_shake")) global.cam_shake = 0;

// --- room transition state (see room_transition() in scr_platformer) ---
if (!variable_global_exists("fade_state"))    global.fade_state = 0;      // 0 idle, 1 fading out, 2 fading in
if (!variable_global_exists("fade_alpha"))    global.fade_alpha = 0;      // 0 = clear, 1 = black
if (!variable_global_exists("fade_room"))     global.fade_room = noone;
if (!variable_global_exists("arrive_door"))   global.arrive_door = "";
if (!variable_global_exists("transitioning")) global.transitioning = false;
if (!variable_global_exists("debug_draw"))    global.debug_draw = false;  // F3 toggles

if (!variable_global_exists("character_override")) global.character_override = "";   // "" = rooms decide; otherwise the character chosen with Tab
if (!variable_global_exists("score_at_room_start")) global.score_at_room_start = global.score;

if (!variable_global_exists("muted")) global.muted = false;   // M toggles

fade_speed = 0.08;   // how fast the screen fades (per frame). 0.05 = slower
