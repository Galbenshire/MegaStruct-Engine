/// @description Start Slither Direction
switch (moveDir) {
	case 0: // On the floor
	case 2: // On the ceiling
		gravEnabled = true;
		gravDir = -moveDir + 1;
		xspeed = slitherSpeed * image_xscale * gravDir;
		yspeed = 0;
		ground = true;
		entity_check_ground(2);
		break;
	
	case 1: // UP a wall
	case 3: // DOWN a wall
		var _yDir = moveDir - 2;
		gravEnabled = false;
		ground = false;
		groundInstance = noone;
		xspeed = 0;
		yspeed = slitherSpeed * _yDir;
		move_and_collide_x(-image_xscale * _yDir);
		break;
}