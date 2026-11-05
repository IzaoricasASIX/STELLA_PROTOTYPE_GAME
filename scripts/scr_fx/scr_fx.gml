// ---------------------------------------------------------------------------
// PARTICLES ("juice"). A particle system is a little factory: you describe ONE kind of
// particle (a "part type"), then ask the system to spawn N of them at a position.
// ---------------------------------------------------------------------------
function fx_init() {
    if (variable_global_exists("fx_ps") && part_system_exists(global.fx_ps)) return;

    global.fx_ps = part_system_create();
    part_system_depth(global.fx_ps, -100);          // in front of most things

    global.fx_dust = part_type_create();
    part_type_shape(global.fx_dust, pt_shape_smoke);
    part_type_size(global.fx_dust, 0.12, 0.28, -0.004, 0);   // min, max, change per frame, wiggle
    part_type_speed(global.fx_dust, 0.3, 1.3, -0.03, 0);     // slows down as it travels
    part_type_direction(global.fx_dust, 0, 359, 0, 0);
    part_type_alpha3(global.fx_dust, 0.8, 0.5, 0);           // starts visible, fades out
    part_type_color1(global.fx_dust, make_color_rgb(235, 235, 255));
    part_type_life(global.fx_dust, 14, 26);                  // frames
}

// A little puff of dust at (_x, _y).
function fx_dust(_x, _y, _count = 6) {
    fx_init();
    part_particles_create(global.fx_ps, _x, _y, global.fx_dust, _count);
}
