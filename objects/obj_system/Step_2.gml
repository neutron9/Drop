if(camera_status == 0)
{
	camera_set_view_pos(camera, 0, camera_get_view_y(camera) - camera_init_up_speed);
	if(camera_get_view_y(camera) < 1)
	{
		camera_set_view_pos(camera, 0, 0);
		camera_status = 1;
		with(obj_player) static_time = 60;
	}
}
else if(camera_status == 1)
{
	var _cy = global.player.y - VIEW_H_HALF;
	if(_cy < 0) _cy = 0;
	else if(_cy > room_height - VIEW_H) _cy = room_height - VIEW_H;
	camera_set_view_pos(camera, 0, _cy);
}