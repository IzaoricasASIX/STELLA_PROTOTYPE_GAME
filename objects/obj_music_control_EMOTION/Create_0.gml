// The music manager (scr_music) picks the Stella or Nila version for us,
// and does NOT restart the song if it is already playing.
music_play(EMOTION);

// (kept from the old version: the Step event below still reads these)
global.current_music = noone;
global.room_music = noone;
