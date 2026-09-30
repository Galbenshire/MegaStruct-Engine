if (!game_can_step(ignoreTimeScale))
	exit;

var _ticks = ignoreTimeScale ? 1 : global.gameTimeScale.integer;
repeat(_ticks) {
	x += xspeed;
	y += yspeed;
	
	yspeed += grav;
	if (yspeed * grav > maxFallSpeed)
		yspeed = maxFallSpeed * sign(grav);
	
	event_user(EVENT_EFFECT_TICK);
	if (__isDestroyed)
		exit;
	
	if (destroyOnAnimEnd && image_index + animSpeed >= image_number) {
		instance_destroy();
		exit;
	}
	
	image_index += animSpeed;
	
	if (lifeDuration > 0) {
		lifeDuration--;
		if (lifeDuration <= 0) {
			instance_destroy();
			exit;
		}
	}
}