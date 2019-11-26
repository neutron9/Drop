camera = view_camera[0];
camera_init_up_speed = 25;
camera_status = 0;

global.player = obj_player;
global.opponent = obj_opponent;

camera_set_view_pos(camera, 0, room_height - VIEW_H);