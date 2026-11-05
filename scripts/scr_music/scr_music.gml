// ---------------------------------------------------------------------------
// MUSIC MANAGER
// Rooms say WHICH song they want with music_play(CHEER). The manager decides which
// FILE to play: CHEER for Stella, CHEER_NILA_MIX for Nila (any sound named
// <song>_NILA_MIX is found automatically). Same song across rooms keeps playing
// instead of restarting.
// ---------------------------------------------------------------------------
function music_init() {
    if (variable_global_exists("music_base")) return;
    global.music_base = noone;   // the "base" song the room asked for
    global.music_inst = noone;   // the sound instance that is playing right now
}

// Which sound asset to actually play for the current character.
function music_variant(_base) {
    var who = variable_global_exists("character") ? global.character : "stella";
    if (who == "nila") {
        var v = asset_get_index(audio_get_name(_base) + "_NILA_MIX");
        if (v != -1) return v;       // -1 means "no such asset": fall back to the normal song
    }
    return _base;
}

function music_play(_base) {
    music_init();
    if (global.music_base == _base && global.music_inst != noone && audio_is_playing(global.music_inst)) return;

    if (global.music_inst != noone) audio_stop_sound(global.music_inst);
    global.music_base = _base;
    global.music_inst = audio_play_sound(music_variant(_base), 1, true);
}

// Called when the character changes: swap to the other version of the SAME song,
// starting from the SAME position so it sounds like the mix just changed.
function music_switch_character() {
    music_init();
    if (global.music_base == noone) return;

    var pos = 0;
    if (global.music_inst != noone && audio_is_playing(global.music_inst)) {
        pos = audio_sound_get_track_position(global.music_inst);
        audio_stop_sound(global.music_inst);
    }
    global.music_inst = audio_play_sound(music_variant(global.music_base), 1, true);
    audio_sound_set_track_position(global.music_inst, pos);
}
