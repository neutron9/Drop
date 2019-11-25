var _cy = global.player.y - VIEW_H_HALF;
if(_cy < 0) _cy = 0;
else if(_cy > room_height - VIEW_H) _cy = room_height - VIEW_H;
camera_set_view_pos(camera, 0, _cy);