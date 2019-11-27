/// @description Collide with other player

if(static_time < 1)
{
	h_input = 0;
	h_force_speed = (x > other.x ? 1 : -1) * move_speed;
	static_time = 20;
}