/// @description Movement logic

// detect input - mouse or keyboard
if(keyboard_check(vk_left)) h_input = -1;
if(keyboard_check(vk_right)) h_input = 1;

if(mouse_check_button(mb_left))
{
	if(mouse_x < VIEW_W_HALF) h_input = -1;
	else h_input = 1;
}

if(static_time > 0) h_input = 0;

h_speed = move_speed * h_input + h_force_speed;

v_speed += GRAVITY;

// other arguments
if(static_time > 0) static_time--;
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