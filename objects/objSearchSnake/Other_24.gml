/// @description Entity Tick
image_index += imageSpeed;

if (!isSlithering) {
	var _newDir = -1;
	if (ground)
		_newDir = 0;
	else if (xcoll != 0)
		_newDir = 1;
	
	if (_newDir >= 0) {
		isSlithering = true;
		moveDir = _newDir;
		event_user(0);
	}
} else if (ground) { // Adjust speed based on slopes
	var _deFactoSpeed = slitherSpeed;
	if (is_object_type(objSlope, groundInstance)) {
		var _steepness = abs(groundInstance.steepness);
		_deFactoSpeed *= (_steepness > 1) ? 1 / abs(groundInstance.steepness) : 1;
	}
	
	if (xspeed.value != 0)
		xspeed.value = _deFactoSpeed * sign(xspeed.value);
}