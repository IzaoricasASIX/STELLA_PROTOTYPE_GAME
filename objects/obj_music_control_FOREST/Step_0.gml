// Only act if the room defines music
if (global.room_music != noone)
{
    // If music is different, change it
    if (global.current_music != global.room_music)
    {
        // Fade out old music (if any)
        if (music_instance != noone)
        {
            audio_sound_gain(music_instance, 0, 30);
            audio_stop_sound(music_instance);
        }

        // Play new music ONCE
        global.current_music = global.room_music;
        music_instance = audio_play_sound(global.current_music, 1, true);
        audio_sound_gain(music_instance, 1, 30);
    }
}
