// ROOM START event: runs every time a new room begins (the controller is persistent).
global.score_at_room_start = global.score;   // so R can restore the score

// If you chose a character with Tab, keep playing as them in this room too
// (rooms place Stella or Nila by default; the override wins).
if (global.character_override != "") character_switch(global.character_override);

// If this room never asked for music, keep whatever is playing; if NOTHING is playing yet, start a default song.
music_init();
if (global.music_base == noone) music_play(CHEER);
