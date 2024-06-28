/// @description Move Player
with (playerInstance) {
	xspeed.update();
	yspeed.update();
	x += xspeed.integer;
	y += yspeed.integer;
	
	if (other.animatePlayer)
		animator.update();
}