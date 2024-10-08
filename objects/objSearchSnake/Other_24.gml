/// @description Entity Tick
if (reflected)
	exit;

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
	if (groundInstance.solidType == SolidType.SLOPE) {
		var _steepness = abs(groundInstance.steepness);
		_deFactoSpeed *= (_steepness > 1) ? 1 / abs(groundInstance.steepness) : 1;
	}
	
	if (xspeed.value != 0)
		xspeed.value = _deFactoSpeed * sign(xspeed.value);
		
	wasOnTopSolid = (groundInstance.solidType == SolidType.TOP_SOLID);
}