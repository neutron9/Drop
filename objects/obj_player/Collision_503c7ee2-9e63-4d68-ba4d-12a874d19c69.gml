/// @description Collide with other player

if(static_time < 1)
{
	h_force_speed = sign(x - other.x) * move_speed;
	static_time = 20;
}