/// @func cbkOnDeath_objSearchSnake(damage_source)
/// @desc onDeath callback for objSearchSnake
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnDeath_objSearchSnake(_damageSource) {
    lifeState = LifeState.DEAD_ONSCREEN;
    visible = false;
    instance_create_depth(x, y, depth, objExplosion);
}

/// @func cbkOnDraw_objSearchSnake(whiteflash)
/// @desc onDraw callback for objSearchSnake
function cbkOnDraw_objSearchSnake(_whiteflash) {
    var _angle = image_angle;
    image_angle = snakeAngle;
	draw_self();
	image_angle = _angle;
}
