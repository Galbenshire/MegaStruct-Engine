event_inherited();

moveDir = 0;
snakeAngle = 0;
isSlithering = false;

__enableCeilings = false;

// Callbacks
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
