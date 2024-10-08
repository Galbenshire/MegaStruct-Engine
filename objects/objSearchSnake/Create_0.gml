event_inherited();

moveDir = 0;
snakeAngle = 0;
isSlithering = false;
wasOnTopSolid = false;
reflected = false;

__enableCeilings = false;

// Callbacks
onReflected = function(_damageSource) {
	cbkOnDeath_prtProjectile(_damageSource);
	
	gravEnabled = false;
	collideWithSolids = false;
    reflected = true;
    
    hspeed = xspeed.value;
    vspeed = yspeed.value;
    set_velocity_vector(6, direction - 135);
}
onDeath = function(_damageSource) {
    lifeState = LifeState.DEAD_ONSCREEN;
    visible = false;
    instance_create_depth(x, y, depth, objExplosion);
};
onDraw = function(_whiteflash) {
    var _angle = image_angle;
    image_angle = snakeAngle;
	draw_self();
	image_angle = _angle;
};
