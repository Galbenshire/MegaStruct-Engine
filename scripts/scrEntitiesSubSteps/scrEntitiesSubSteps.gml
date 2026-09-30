/// @self {prtEntity}
/// @func entity_check_ground()
/// @desc Any entity calling this function will check for a ground directly underneath them
function entity_check_ground() {
	if (!ground || !collideWithSolids || !gravEnabled || yspeed.value * gravDir < 0) {
		ground = false;
		groundInstance = noone;
		return;
	}
	
	var _groundRange = (abs(xspeed.integer) + 1) * gravDir,
		_foundGround = false,
		_collidables = get_ycoll_candidates(_groundRange),
		_collidableCount = array_length(_collidables),
		_distanceToMove = _groundRange,
		_directionToMove = sign(_groundRange),
		_groundInstance = noone;
	
	for (var i = 0; i < _collidableCount; i++) {
		var _distanceToCollidable = distance_to_collidable_y(_collidables[i], gravDir);
		
		if (_distanceToCollidable * _directionToMove < 0 || abs(_distanceToCollidable) >= abs(_distanceToMove))
            continue;
        
        _foundGround = true;
        _distanceToMove = _distanceToCollidable;
        _groundInstance = _collidables[i];
	}
	
	y += _distanceToMove * _foundGround;
	ground = _foundGround;
	groundInstance = _groundInstance;
	
	if (_foundGround)
		push_entities_y(_distanceToMove);
}

/// @self {prtEntity}
/// @func entity_gravity(force)
/// @desc Applies gravity to an entity
///
/// @param {number}  [force]  How strong the gravity should be. Defaults to the entity's gravity.
function entity_gravity(_force = grav) {
	if (ground || !gravEnabled)
		return;
	
	yspeed.value += _force * gravDir * (inWater ? waterGravMod : 1);
	if (yspeed.value * gravDir > maxFallSpeed)
		yspeed.value = maxFallSpeed * gravDir;
}

/// @self {prtEntity}
/// @func entity_handle_external_forces()
/// @desc Entity interactions with movement-based gimmicks
function entity_handle_external_forces() {
	externalXForce.value = 0;
	externalYForce.value = 0;
	
	// Conveyor Belts
	if (ground && place_meeting(x, y, objConveyorBeltArea) && !asset_has_tags(object_index, "ignore_conveyor", asset_object)) {
		var _belt = instance_place(x, y, objConveyorBeltArea);
		if (instance_exists(_belt))
			externalXForce.value += _belt.force * sign(_belt.image_xscale);
	}
	
	externalXForce.update();
	externalYForce.update();
	
	if (collideWithSolids) {
		move_and_collide_x(externalXForce.integer);
		move_and_collide_y(externalYForce.integer);
	} else {
		move_x(externalXForce.integer);
		move_y(externalYForce.integer);
	}
}

/// @self {prtEntity}
/// @func entity_horizontal_movement()
/// @desc Moves an entity horizontally
function entity_horizontal_movement() {
	xcoll = 0;
	xcollInstance = noone;
	xspeed.update();
	
	if (collideWithSolids) {
		xcollInstance = move_and_collide_x(xspeed.integer);
		if (xcollInstance != noone) {
			xcoll = xspeed.value;
			xspeed.clear_all();
		}
	} else {
		move_x(xspeed.integer);
	}
}

/// @self {prtEntity}
/// @func entity_update_hitboxes()
/// @desc Updates an entity's hitboxes
function entity_update_hitboxes() {
	var i = 0;
	repeat(hitboxCount) {
		event_user_scope(0, hitboxes[i]);
		i++;
	}
}

/// @self {prtEntity}
/// @func entity_update_subpixels()
/// @desc Updates an entity's subpixels
function entity_update_subpixels() {
	if (options_data().pixelPerfect) {
		subPixelX = 0;
		subPixelY = 0;
		return;
	}
	
	subPixelX = xspeed.fractional;
	subPixelY = yspeed.fractional;
	
	if (ground && instance_exists(groundInstance)) {
		subPixelX = modf(subPixelX + groundInstance.subPixelX, 1.0);
		subPixelY = modf(subPixelY + groundInstance.subPixelY, 1.0);
	}
}

/// @self {prtEntity}
/// @func entity_vertical_movement()
/// @desc Moves an entity vertically
function entity_vertical_movement() {
	ycoll = 0;
	ycollInstance = noone;
	yspeed.update();
	
	if (collideWithSolids) {
		ycollInstance = move_and_collide_y(yspeed.integer);
		if (ycollInstance != noone) {
			if (gravEnabled && sign(yspeed.value) == gravDir) {
				ground = true;
				groundInstance = ycollInstance;
			}
			
			ycoll = yspeed.value;
			yspeed.clear_all();
		}
	} else {
		move_y(yspeed.integer);
	}
}

/// @self {prtEntity}
/// @func entity_water()
/// @desc Entity interaction with water
function entity_water() {
	if (!interactWithWater) {
		inWater = false;
		return;
	}
	
	var _x = bbox_x_center(),
		_y = bbox_y_center();
	try_splashing(_x - (x - xprevious), _y - (y - yprevious), _x, _y);
	
	inWater = place_meeting(x, y, objWater);
	if (!inWater) {
		bubbleTimer = 0;
		return;
	}
	
	if (++bubbleTimer >= 64) {
		bubbleTimer = 0;
		instance_create_depth(x + bubbleXOffset, y + bubbleYOffset, depth, objAirBubble);
	}
}
