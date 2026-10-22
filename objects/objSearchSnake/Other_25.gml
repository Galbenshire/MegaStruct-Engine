/// @description Entity Posttick
if (isBlocked)
	exit;

if (!isSlithering) {
	var _newDir = -1;
	if (ground)
		_newDir = 0;
	else if (xcoll != 0)
		_newDir = 1;
	
	if (_newDir >= 0) {
		isSlithering = true;
		moveDir = _newDir;
		event_user(2);
	}
}

snakeAngle = moveDir * 90 * sign(image_xscale);
if (ground && is_object_type(objSlope, groundInstance))
	snakeAngle = wrap_angle(groundInstance.normal + 90);

if (moveDir == 2 && !__enableCeilings) {
	deathExplode = true;
	entity_kill_self();
}
