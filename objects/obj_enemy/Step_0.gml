var wall = collision_point(x + dir * PLAYER_WIDTH_HALF, y, obj_solid, false, false);
var hole = !collision_point(x + dir * PLAYER_WIDTH_HALF, y + 8, obj_solid, false, false);

if(wall || hole)
{
	dir = -dir;
}

x += move_speed * dir;

// wrap
if(x < -PLAYER_WIDTH_HALF) x = VIEW_W + PLAYER_WIDTH_HALF - 1;
else if(x > VIEW_W + PLAYER_WIDTH_HALF) x = -PLAYER_WIDTH_HALF + 1;