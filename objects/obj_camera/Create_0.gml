cam = view_camera[0];

follow_x = camera_get_view_x(cam);
follow_y = camera_get_view_y(cam);

cam_w = camera_get_view_width(cam);
cam_h = camera_get_view_height(cam);

smooth = 0.12;
look_x = 0;
look_y = 0;
last_target = noone;

if (!variable_global_exists("cam_shake")) global.cam_shake = 0;
