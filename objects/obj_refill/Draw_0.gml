var bob = sin(t * 0.08) * 3;
if (active) draw_sprite_ext(sprite_index, 0, x, y + bob, 1, 1, 0, c_white, 1);
else        draw_sprite_ext(sprite_index, 0, x, y, 0.7, 0.7, 0, c_white, 0.2);   // faded ghost while recharging
