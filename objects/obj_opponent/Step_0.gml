/// @description Movement logic

// make input decision
if(decision_time < 1)
{
	// find the hole
	ds_list_clear(hole_list);
	ds_list_clear(solid_list);
	var i, j;
	for(i = 0; i < VIEW_W; i += 48)
	{
		if(!collision_point(i, y + 8, obj_solid, false, false))
		{
			ds_list_add(hole_list, i - VIEW_W);
			ds_list_add(hole_list, i);
			ds_list_add(hole_list, i + VIEW_W);
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
else decision_time = 50;
if(abs(h_force_speed) < 1) h_force_speed = 0;
else h_force_speed *= .8;

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