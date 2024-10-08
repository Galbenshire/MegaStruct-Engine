/// @description Entity Posttick
if (!isSlithering || reflected)
	exit;

var _prevMoveDir = moveDir;

switch (moveDir) {
	case 0: // Moving on the ground
		if (xcoll != 0) {
			moveDir = 1;
		} else if (!ground && !wasOnTopSolid) {
			move_and_collide_y(gravDir);
			move_and_collide_x(ceil(xprevious - x));
			moveDir = 3;
		}
		break;
	
	case 1: // Moving UP a wall
		if (ycoll != 0) {
			if (__enableCeilings)
				moveDir = 2;
			else
				entity_kill_self();
		} else if (!test_move_x(image_xscale)) {
			move_and_collide_x(image_xscale);
			move_and_collide_y(ceil(yprevious - y));
			moveDir = 0;
		}
		break;
	
	case 2: // Moving on the ceiling
		if (xcoll != 0) {
			moveDir = 3;
		} else if (!ground) {
			move_and_collide_y(gravDir);
			move_and_collide_x(ceil(xprevious - x));
			moveDir = 1;
		}
		break;
	
	case 3: // Moving DOWN a wall
		if (ycoll != 0) {
			moveDir = 0;
		} else if (!test_move_x(-image_xscale)) {
			move_and_collide_x(-image_xscale);
			move_and_collide_y(ceil(yprevious - y));
			moveDir = 2;
		}
		break;
}

if (moveDir != _prevMoveDir)
	event_user(0);

snakeAngle = moveDir * 90 * sign(image_xscale);
if (ground && is_object_type(objSlope, groundInstance)) {
	var _steepness = groundInstance.steepness;
	if (abs(_steepness) > 1)
		snakeAngle += (90 * sign(_steepness)) - (45 * (1 / _steepness));
	else
		snakeAngle += 45 * _steepness;
}
