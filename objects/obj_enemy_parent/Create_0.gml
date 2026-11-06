// Shared setup. Children call event_inherited() at the top of their Create event.
hp = 1;
dead = false;
hit_flash = 0;       // frames the enemy is tinted red after a hit
contact_dmg = 1;     // damage dealt when touched from the side
