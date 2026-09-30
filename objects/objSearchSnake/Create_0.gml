event_inherited();

maxSlopeSteepness = 999;

moveDir = 0;
snakeAngle = 0;
isSlithering = false;
wasOnTopSolid = false;
deathExplode = false;

__enableCeilings = false;

// Callbacks
onBlocked = function(_damageSource) {
	play_sfx(sfxReflect);
	
    isBlocked = true;
    hitmaskMaster = 0;
    collideWithSolids = false;
    gravEnabled = false;
    
    hspeed = xspeed.value;
    vspeed = yspeed.value;
    set_velocity_vector(6, direction - 135);
}
onDeath = function(_damageSource) {
	cbkOnDeath_projectile(_damageSource);
    if (deathExplode)
		instance_create_depth(x, y, depth, objExplosion);
};
onMovement = function() {
	if (!isSlithering || isBlocked) {
		cbkOnMovement_base();
		return;
	}
	
	// Temporarily disabled for now
	// entity_handle_external_forces();
	// entity_gravity();
	// event_user(moveDir & 1);
	// entity_water();
};
onDraw = function() {
    var _angle = image_angle;
    image_angle = snakeAngle;
	draw_self();
	image_angle = _angle;
};