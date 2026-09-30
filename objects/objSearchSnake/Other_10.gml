/// @description Snake Movement (Floor/Ceiling)
xcoll = 0;
xcollInstance = noone;
ycoll = 0;
ycollInstance = noone;

var _isOnFloor = (moveDir == 0),
	_totalSpeed = xspeed + externalXForce,
	_wasOnTopSolid = false,
	_bboxHeight = bbox_height();

if (ground) {
	var _solidType = get_collidable_type(groundInstance, self);
	if (_solidType == SolidType.SLOPE) {
		var _steepness = abs(groundInstance.steepness);
		if (_steepness > 1)
			_totalSpeed *= (1 / _steepness);
	}
	_wasOnTopSolid = (_solidType == SolidType.TOP_SOLID);
}

while (abs(_totalSpeed) > 0) {
	var _step = abs(_totalSpeed) > 1 ? sign(_totalSpeed) : _totalSpeed;
    xcollInstance = move_and_collide_x(_step);
    entity_check_ground(_bboxHeight);
    
    if (xcollInstance != noone) {
        xcoll = xspeed;
		subPixelX = xcollInstance.subPixelX;
		moveDir = _isOnFloor ? 1 : 3;
		event_user(2);
		break;
    }
    if (!ground) {
		if (_wasOnTopSolid) {
			isSlithering = false;
			entity_apply_gravity();
		} else {
			move_and_collide_y(gravDir);
			moveDir = _isOnFloor ? 3 : 1;
			event_user(2);
		}
		break;
    }
	
	_totalSpeed = approach(_totalSpeed, 0, 1);
}