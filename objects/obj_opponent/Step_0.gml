/// @description Movement logic

// make input decision
if(decision_time < 1 && static_time < 1 && place_meeting(x, y + 1, obj_solid))
{
	// find the hole
	ds_list_clear(hole_list);
	ds_list_clear(solid_list);
	var i, j;
	for(i = 0; i < VIEW_W; i += 64)
	{
		if(!collision_point(i, y + 8, obj_solid, false, false))
		{
			// find the middle point of the hole
			var i_l = i, i_r = i, i_m = i;
			while(!collision_point(i_l - 1, y + 8, obj_solid, false, false) && i_l > 0) i_l--;
			while(!collision_point(i_r + 1, y + 8, obj_solid, false, false) && i_r < VIEW_W) i_r++;
			i_m = (i_l + i_r) * .5;
			ds_list_add(hole_list, i_m - VIEW_W);
			ds_list_add(hole_list, i_m);
			ds_list_add(hole_list, i_m + VIEW_W);
		}
	}
	
	var _sn = collision_line_list(0, y, VIEW_W, y, obj_solid, false, true, solid_list, false);
	if(abs(y - global.player.y) < 16)
	{
		ds_list_add(solid_list, global.player);
		_sn++;
	}
	for(i = 0; i < _sn; i++)
	{
		var _s = solid_list[| i].x;
		if(_s < x)
		{
			for(j = 0; j < ds_list_size(hole_list); j++)
			{
				if(hole_list[| j] < _s) hole_list[| j] = -5000;
			}
		}
		else
		{
			for(j = 0; j < ds_list_size(hole_list); j++)
			{
				if(hole_list[| j] > _s) hole_list[| j] = 5000;
			}
		}
	}
	
	var _min_d = 10000, _hole = 0;
	for(i = 0; i < ds_list_size(hole_list); i++)
	{
		var _d = abs(x - hole_list[| i]);
		if(_d < _min_d)
		{
			_min_d = _d;
			_hole = hole_list[| i];
		}
	}
	
	if(x > _hole) h_input = -1;
	else h_input = 1;
}

if(static_time > 0) h_input = 0;

h_speed = move_speed * h_input + h_force_speed;

v_speed += GRAVITY;

// other arguments
if(static_time > 0) static_time--;
if(decision_time > 0) decision_time--;
else decision_time = 30;
if(abs(h_force_speed) < 1) h_force_speed = 0;
else h_force_speed *= .8;

// sprite control
image_xscale_previous = image_xscale;
if(h_input == 1) image_xscale = 1;
else if(h_input == -1) image_xscale = -1;
if(h_input == 0 || image_xscale_previous != image_xscale) angle_arg = 0;
else angle_arg = clamp(angle_arg + 15, 0, 180);

// check collision
var i;
for(i = 0; i < abs(h_speed); i++)
{
	var _dh = sign(h_speed);
	if(place_free(x + _dh, y)) 
	{
		if(!place_free(x, y + 1)) x += _dh;
	}
	else
	{
		if(!place_free(x, y + 1))
		{
			h_input = 0;
			h_force_speed = -h_speed;
			static_time = 30;
		}
		break;
	}
}
for(i = 0; i < abs(v_speed); i++)
{
	var _dv = sign(v_speed);
	if(place_free(x, y + _dv)) y += _dv;
	else
	{
		v_speed = 0;
		break;
	}
}

// wrap
if(x < -PLAYER_WIDTH_HALF) x = VIEW_W + PLAYER_WIDTH_HALF - 1;
else if(x > VIEW_W + PLAYER_WIDTH_HALF) x = -PLAYER_WIDTH_HALF + 1;