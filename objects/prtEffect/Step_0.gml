if (!game_can_step(pauseMask))
	exit;

var _ticks = bitmask_has_bit(pauseMask, PauseType.TIMESCALE) ? global.gameTimeScale.integer : 1;
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