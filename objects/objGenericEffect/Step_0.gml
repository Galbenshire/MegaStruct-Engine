if (!game_can_step())
	exit;

var _gameTicks = global.gameTimeScale.integer;
repeat(_gameTicks) {
    xspeed.update();
    yspeed.update();
    x += xspeed.integer;
    y += yspeed.integer;
    
    yspeed.value += grav;
    if (yspeed.value * grav > maxFallSpeed)
        yspeed.value = maxFallSpeed * sign(grav);
    
    lifeTimer++;
    
    if (!is_undefined(onStep))
        onStep();
    
    if (destroyOnAnimEnd && image_index + animSpeed >= image_number) {
        instance_destroy();
        exit;
    }
    
    if (lifeDuration > 0 && lifeTimer >= lifeDuration) {
        instance_destroy();
        exit;
    }
}

if (animSpeed > 0)
	image_index += animSpeed * _gameTicks;

subPixelX = xspeed.fractional;
subPixelY = yspeed.fractional;
