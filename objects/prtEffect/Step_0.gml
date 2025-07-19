if (!game_can_step(ignoreTimeScale))
	exit;

var _ticks = ignoreTimeScale ? 1 : global.gameTimeScale.integer;
repeat(_ticks) {
	xspeed.update();
	yspeed.update();
	x += xspeed.integer;
	y += yspeed.integer;
	
	yspeed.value += grav;
	if (yspeed.value * grav > maxFallSpeed)
		yspeed.value = maxFallSpeed * sign(grav);
	
	subPixelX = xspeed.fractional;
	subPixelY = yspeed.fractional;
	
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