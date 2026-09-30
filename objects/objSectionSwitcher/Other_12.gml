/// @description Move Player
with (playerInstance) {
	move_x(xspeed);
	move_y(yspeed);
	
	if (other.animatePlayer)
		self.handle_animation();
}