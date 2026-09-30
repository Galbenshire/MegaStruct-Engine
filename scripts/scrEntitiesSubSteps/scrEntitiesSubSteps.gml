#region Physics

/// @self {prtEntity}
/// @func entity_apply_gravity(force)
/// @desc Applies gravity to an entity
///
/// @param {number}  [force]  How strong the gravity should be. Defaults to the entity's gravity.
function entity_apply_gravity(_force = grav) {
	if (ground || !gravEnabled)
		return;
	yspeed += _force * gravDir * (inWater ? waterGravMod : 1);
	if (yspeed * gravDir > maxFallSpeed)
		yspeed = maxFallSpeed * gravDir;
}

/// @self {prtEntity}
/// @func entity_check_ground(range, snap_to_slopes, test_only)
/// @desc Any entity calling this function will check for ground directly underneath them.
///		  If ground is found, they will be snapped down to said ground.
///
/// @param {int}  [range]  The range at which to check for ground. Defaults to the entity's current xspeed.
/// @param {bool}  [snap_to_slopes]  If true, snaps to slopes within range. Defaults to true.
/// @param {bool}  [test_only]  If true, the entity won't actually be moved. Defaults to false.
///
/// @return {prtCollidable}  The collidable marked as ground. Returns noone if no collision occurs.
function entity_check_ground(_range, _snapToSlopes = true, _testOnly = false) {
	if (!ground || !collideWithSolids || !gravEnabled || yspeed * gravDir < 0) {
		if (!_testOnly) {
			ground = false;
			groundInstance = noone;
			return noone;
		}
	}
	
	// Adjust the check range
	_range ??= xspeed;
	_range = ceil(abs(_range) + 1) * gravDir;
	
	var _foundGround = false,
		_distanceToMove = _range,
		_directionToMove = sign(_range),
		_groundInstance = noone;
	
	var _collidables = get_collidables_y(_range),
		_collidableCount = array_length(_collidables);
	for (var i = 0; i < _collidableCount; i++) {
		var _collidable = _collidables[i],
			_distanceToCollidable = distance_to_collidable_y(_collidable, gravDir);
		
		if (_distanceToCollidable * _directionToMove < 0) // In the wrong direction?
			continue;
		if (abs(_distanceToCollidable) > abs(_distanceToMove)) { // Further down than what we have so far?
			if (_collidable.solidType != SolidType.SLOPE)
				continue;
			if (!_snapToSlopes || slope_is_steep(_collidable))
				continue;
		}
		
		_foundGround = true;
		_distanceToMove = _distanceToCollidable;
		_groundInstance = _collidable;
	}
	
	if (!_testOnly) {
		ground = _foundGround;
		groundInstance = _groundInstance;
		
		if (_foundGround) {
			y += _distanceToMove;
			subPixelY = groundInstance.subPixelY;
			push_entities_y(_distanceToMove);
		}
	}
	
	return _groundInstance;
}

/// @self {prtEntity}
/// @func entity_handle_external_forces()
/// @desc Entity interactions with movement-based gimmicks
function entity_handle_external_forces() {
	externalXForce = 0;
	externalYForce = 0;
	
	// Conveyor Belts
	if (ground && place_meeting(x, y, objConveyorBeltArea) && !asset_has_tags(object_index, "ignore_conveyor", asset_object)) {
		var _belt = instance_place(x, y, objConveyorBeltArea);
		if (instance_exists(_belt))
			externalXForce += _belt.force * sign(_belt.image_xscale);
	}
}

/// @self {prtEntity}
/// @func entity_movement_horizontal()
/// @desc Moves an entity horizontally
function entity_movement_horizontal() {
	var _totalForce = xspeed + externalXForce;
	xcoll = 0;
	xcollInstance = noone;
	
	if (!collideWithSolids) {
		move_x(_totalForce);
		return;
	}
	
	xcollInstance = move_and_collide_x(_totalForce);
	if (xcollInstance != noone) {
		xcoll = xspeed;
		subPixelX = xcollInstance.subPixelX;
		xspeed = 0;
	}
}

/// @self {prtEntity}
/// @func entity_movement_vertical(slip_by)
/// @desc Standard vertical movement of an entity
///
/// @param {int}  [slip_by]  Leniancy when moving upwards relative to gravity. Defaults to 0.
function entity_movement_vertical(_slipBy = 0) {
	var _totalForce = yspeed + externalYForce;
	ycoll = 0;
	ycollInstance = noone;
	
	if (!collideWithSolids) {
		move_y(_totalForce);
		return;
	}
	
	ycollInstance = move_and_collide_y(_totalForce);
	if (ycollInstance == noone)
		return;
	
	if (gravEnabled) {
		if (sign(_totalForce) == gravDir) { // If moving towards gravity, this means we hit ground
			ground = true;
			groundInstance = ycollInstance;
		} else if (_slipBy > 0 && sign(_totalForce) == -gravDir) { // If moving away from gravity, check if we can slip past corners
			for (var i = -1; i <= 1; i += 2) {
				var _overflow = bbox_horizontal(i) - bbox_horizontal(-i, ycollInstance);
				if (_overflow * i > _slipBy)
					continue;
				if (test_move_x(-_overflow))
					continue;
				
				var _x = x;
				move_and_collide_x(-_overflow);
				if (test_move_y(-gravDir)) {
					x = _x;
					continue;
				}
				
				ycollInstance = noone;
				return;
			}
		}
	}
	
	ycoll = yspeed;
	subPixelY = ycollInstance.subPixelY;
	yspeed = 0;
}

#endregion

#region Other

/// @self {prtEntity}
/// @func entity_update_hitboxes()
/// @desc Updates an entity's hitboxes
function entity_update_hitboxes() {
	var i = 0; repeat(hitboxCount) {
		event_user_scope(0, hitboxes[i]);
		i++;
	}
}

/// @self {prtEntity}
/// @func entity_handle_water()
/// @desc Entity interaction with water
function entity_handle_water() {
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
	
	if (canMakeBubble) {
		bubbleTimer++;
		if (bubbleTimer >= 64) {
			bubbleTimer = 0;
			instance_create_depth(x + bubbleXOffset, y + bubbleYOffset, depth, objAirBubble);
		}
	}
}

#endregion
