if (global.room_music != noone)
{
    if (global.current_music != global.room_music)
    {
        if (global.current_music != noone)
        {
            audio_stop_sound(global.current_music);
        }

        global.current_music = global.room_music;
        audio_play_sound(global.current_music, 1, true);
    }
}
