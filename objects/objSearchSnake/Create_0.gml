event_inherited();

moveDir = 0;
snakeAngle = 0;
isSlithering = false;
wasOnTopSolid = false;
reflected = false;
deathExplode = false;

__enableCeilings = false;

// Callbacks
onReflected = function(_damageSource) {
	play_sfx(sfxReflect);
	
    reflected = true;
    canTakeDamage = false;
    canDealDamage = false;
    collideWithSolids = false;
    gravEnabled = false;
    
    hspeed = xspeed.value;
    vspeed = yspeed.value;
    set_velocity_vector(6, direction - 135);
}
onDeath = function(_damageSource) {
	cbkOnDeath_prtProjectile(_damageSource);
    
    if (deathExplode)
		instance_create_depth(x, y, depth, objExplosion);
};
onDraw = function(_whiteflash) {
    var _angle = image_angle;
    image_angle = snakeAngle;
	draw_self();
	image_angle = _angle;
};