/// @description Snake Movement (Walls)
xcoll = 0;
xcollInstance = noone;
ycoll = 0;
ycollInstance = noone;

var _movingUpWall = (moveDir == 1),
	_wallCheckDir = _movingUpWall ? image_xscale : -image_xscale,
	_totalSpeed = yspeed + externalYForce;

while (abs(_totalSpeed) > 0) {
	var _step = abs(_totalSpeed) > 1 ? sign(_totalSpeed) : _totalSpeed;
    ycollInstance = move_and_collide_y(_step);
    
    if (ycollInstance != noone) {
        ycoll = xspeed;
		subPixelY = ycollInstance.subPixelY;
		moveDir = _movingUpWall ? 2 : 0;
		event_user(2);
		break;
    }
    if (!test_move_x(_wallCheckDir)) {
		move_and_collide_x(_wallCheckDir);
		moveDir = _movingUpWall ? 0 : 2;
		event_user(2);
		break;
    }
	
	_totalSpeed = approach(_totalSpeed, 0, 1);
}