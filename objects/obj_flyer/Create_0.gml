event_inherited();

// ---- settings: change per instance in Creation Code ----
wake_dist = 150;     // starts chasing when you get this close
lose_dist = 300;     // gives up when you get this far
idle_range_x = 24;   // how far it drifts around its home while idle
idle_range_y = 12;
chase_spd = 1.5;

home_x = x;
home_y = y;
state = 0;           // 0 = idle around home, 1 = chasing, 2 = going home
t = irandom(200);    // so several flyers don't all bob in sync
