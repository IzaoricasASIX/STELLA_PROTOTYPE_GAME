// ---------------------------------------------------------------
// SPRING SETTINGS.  To change them for ONE spring: select it in the room editor
// -> Properties -> Creation Code, and write e.g.
//        launch_speed = 15;
//        launch_angle = 60;
// ---------------------------------------------------------------
launch_speed = 11;   // pixels/frame. Peak height ~ launch_speed^2 / (2 * grav_rise):
                     //   8 = ~90px   11 = ~170px   14 = ~270px   17 = ~400px
launch_angle = 90;   // direction in degrees: 0 = right, 90 = up, 180 = left, 45 = up-right
lock_time    = 0;    // frames with NO gravity after launch (0 = none)
h_lock_time  = 10;   // frames with NO left/right steering after a sideways launch

cooldown     = 0;    // so one touch can't launch twice
cooldown_max = 10;

pop = 0;             // squash animation, 1 = just launched, fades to 0
