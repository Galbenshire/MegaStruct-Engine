#region Checking for Collisions

/// @func check_for_solids(x, y, scope)
/// @desc Checks if a given entity would overlap with solid collisions at the location specified
///
/// @param {number}  x  x-position to check at
/// @param {number}  y  y-position to check at
/// @param {prtEntity}  [scope]  The instance to check with. Defaults to the calling instance.
///
/// @return {bool}  Whether there's a collision at the given location (true) or not (false)
function check_for_solids(_x, _y, _scope = self) {
	var _list = ds_list_create(),
		_result = false;
	
	with (_scope) {
		var _cacheX = x,
			_cacheY = y;
		x = _x;
		y = _y;
		
		var _count = instance_place_list(x, y, prtCollidable, _list, true);
		for (var i = 0; i < _count; i++) {
			var _candidate = _list[| i];
			
			if (is_object_type(prtEntity, _candidate) && !entity_is_solid_to_entity(_candidate))
				continue;
			if (_candidate.object_index == objCustomSolid && !_candidate.is_solid_to_entity(self))
				continue;
			
			switch (get_collidable_type(_candidate, self)) {
				case SolidType.SOLID: // Yep, you're touching a solid
					_result = true;
					break;
				case SolidType.SLOPE: // Strap in...
					var _bboxWidth = bbox_width(),
						_bboxXCenter = bbox_x_center();
					var _isSteepSlope = slope_is_steep(_candidate),
						_slopeXscale = _candidate.image_xscale;
					var _leftBounds = _candidate.bbox_left - _bboxWidth * (_isSteepSlope && _slopeXscale < 0),
						_rightBounds = _candidate.bbox_right + _bboxWidth * (_isSteepSlope && _slopeXscale > 0);
					
					if (_bboxXCenter >= _leftBounds && _bboxXCenter < _rightBounds) { // The center of the checker is within bounds
						var _slopeX = _isSteepSlope ? bbox_horizontal(-_candidate.image_xscale) : _bboxXCenter,
							_slopeY = slope_y_at(_candidate, _slopeX),
							_yDistance = _slopeY - bbox_vertical(-_candidate.image_yscale);
						_result = (_yDistance * _candidate.image_yscale) >= 0;
					}
					break;
				case SolidType.SLOPE_SOLID: // We should check this solid's exposed sides
					var _bboxWidth = bbox_width(),
						_bboxXCenter = bbox_x_center();
					var _leftBounds = _candidate.bbox_left - _bboxWidth * _candidate.exposedLeft,
						_rightBounds = _candidate.bbox_right + _bboxWidth * _candidate.exposedRight;
					_result = _bboxXCenter >= _leftBounds && _bboxXCenter < _rightBounds;
					break;
			}
			
			if (_result)
				break;
		}
		
		x = _cacheX;
		y = _cacheY;
	}
	
	ds_list_destroy(_list);
	return _result;
}

/// @func check_for_solids_point(x, y, scope)
/// @desc Version of check_for_solids that uses a single point
///
/// @param {number}  x  x-position to check at
/// @param {number}  y  y-position to check at
/// @param {prtEntity}  [scope]  The instance to get with. Defaults to the calling instance.
///
/// @return {bool}  Whether there's a collision at the given location (true) or not (false)
function check_for_solids_point(_x, _y, _scope = self) {
	var _list = ds_list_create(),
		_result = false;
	
	var _count = instance_position_list(_x, _y, prtCollidable, _list, true);
	for (var i = 0; i < _count; i++) {
		var _candidate = _list[| i];
		
		if (_scope != noone) {
			if (is_object_type(prtEntity, _candidate) && !entity_is_solid_to_entity(_candidate, _scope))
				continue;
			if (_candidate.object_index == objCustomSolid && !_candidate.is_solid_to_entity(_scope))
				continue;
		}
		
		switch (get_collidable_type(_candidate, _scope)) {
			case SolidType.SOLID: // Yep, you're touching a solid
			case SolidType.SLOPE_SOLID:
			case SolidType.SLOPE:
                _result = true;
                break;
		}
		
		if (_result)
			break;
	}
	
	ds_list_destroy(_list);
	return _result;
}

/// @func distance_to_collidable_x(collidable, direction, scope)
/// @desc Finds the horizontal distance from a given collidable to a given entity.
///		  The solid type of the collidable will be taken into account.
///
/// @param {prtCollidable}  collidable  The collidable to check against.
/// @param {number}  [direction]  The direction to check in. Defaults to the direction of the entity's center to the collidable's
/// @param {prtEntity}  [scope]  The instance to get the distance for. Defaults to the calling instance.
///
/// @return {number}  The distance to the collidable in the x-direction
function distance_to_collidable_x(_collidable, _direction, _scope = self) {
    _direction ??= sign_nonzero(bbox_x_center(_collidable) - bbox_x_center(_scope));
    
    if (_collidable.solidType == SolidType.SLOPE) {
		// Slopes are treated differently
		// But only if the entity is not approaching the flat end
		if (sign(_direction) != sign(_collidable.image_xscale)) {
            var _slopeX = slope_x_at(_collidable, bbox_vertical(-_collidable.image_yscale, _scope)),
                _startX = slope_is_steep(_collidable, _scope) ? bbox_horizontal(-_collidable.image_xscale, _scope) : bbox_x_center(_scope);
            return _slopeX - _startX;
        }
    } else if (_collidable.solidType == SolidType.SLOPE_SOLID) {
		// For Slope Solids, it depends on if the side is exposed (has no slope)
		var _exposed = _direction >= 0 ? _collidable.exposedLeft : _collidable.exposedRight;
        if (!_exposed)
            return bbox_horizontal(-_direction, _collidable) - bbox_x_center(_scope);
    }
    
    return bbox_horizontal(-_direction, _collidable) - bbox_horizontal(_direction, _scope);
}

/// @func distance_to_collidable_y(collidable, direction, scope)
/// @desc Finds the vertical distance from a given collidable to a given entity.
///		  The solid type of the collidable will be taken into account.
///
/// @param {prtCollidable}  collidable  The collidable to check against.
/// @param {number}  [direction]  The direction to check in. Defaults to the direction of the entity's center to the collidable's
/// @param {prtEntity}  [scope]  The instance to get the distance for. Defaults to the calling instance.
///
/// @return {number}  The distance to the collidable in the y-direction
function distance_to_collidable_y(_collidable, _direction, _scope = self) {
    _direction ??= sign_nonzero(bbox_y_center(_collidable) - bbox_y_center(_scope));
    
    // Slopes are treated differently
    // But only if the entity is not approaching the flat end
    if (_collidable.solidType == SolidType.SLOPE) {
		if (sign(_direction) != sign(_collidable.image_yscale)) {
			var _x = slope_is_steep(_collidable, _scope) ? bbox_horizontal(-_collidable.image_xscale, _scope) : bbox_x_center(_scope),
				_slopeY = slope_y_at(_collidable, _x);
			return _slopeY - bbox_vertical(-_collidable.image_yscale, _scope);
		}
    }
    
    return bbox_vertical(-_direction, _collidable) - bbox_vertical(_direction, _scope);
}

/// @func get_collidable_type(collidable, scope)
/// @desc Finds the type of solid a collidable is, taking into account any overrides defined by the calling instance.
///
/// @param {prtCollidable}  collidable  The collidable to check.
/// @param {prtEntity}  [scope]  The instance to check against. Defaults to noone.
///
/// @return {int}  Solid type of the collidable
function get_collidable_type(_collidable, _scope = noone) {
	with (_scope) {
		var _collidableName = object_get_name(_collidable.object_index);
		if (struct_exists(collisionOverrides, _collidableName))
			return collisionOverrides[$ _collidableName];
		
		var _parentName = object_get_name(object_get_parent(_collidable.object_index));
		if (struct_exists(collisionOverrides, _parentName))
			return collisionOverrides[$ _parentName];
	}
	
	return _collidable.solidType;
}

/// @func get_collidables_x(range, scope)
/// @desc Checks for possible collisions to the left/right of the given instance
///
/// @param {number}  range  How far ahead of the instance's bounding box to check.
/// @param {prtEntity}  [scope]  The instance to check against. Defaults to the calling instance.
///
/// @return {array<prtCollidable>}  An array of collidables that the entity could collide with
function get_collidables_x(_range, _scope = self) {
	var _results = [],
		_list = ds_list_create();
	var _startX = (_range == 0) ? bbox_x_center(_scope) : bbox_horizontal(-_range, _scope),
		_endX = bbox_horizontal(_range, _scope) + _range;
		
    var _count = collision_rectangle_list(_startX, _scope.bbox_top, _endX, _scope.bbox_bottom, prtCollidable, false, false, _list, false);
    for (var i = 0; i < _count; i++) {
		var _candidate = _list[| i];
		
        if (_candidate.id == _scope.id)
            continue;
        if (is_object_type(prtEntity, _candidate) && !entity_is_solid_to_entity(_candidate, _scope))
            continue;
        if (_candidate.object_index == objCustomSolid && !_candidate.is_solid_to_entity(_scope))
			continue;
        
        var _valid = 0; // 0 = not valid; 1 = valid; 2 = valid slope
        switch (get_collidable_type(_candidate, _scope)) {
            case SolidType.SOLID: // Always a candidate
            case SolidType.SLOPE_SOLID:
                _valid = 1;
                break;
            case SolidType.LEFT_SOLID: // Only count if we're moving to the left, and aren't already inside it
                _valid = (_range >= 0 && _scope.bbox_right <= _candidate.bbox_left);
                break;
            case SolidType.RIGHT_SOLID: // Only count if we're moving to the right, and aren't already inside it
                _valid = (_range < 0 && _scope.bbox_left >= _candidate.bbox_right);
                break;
            case SolidType.SLOPE: // Always a candidate, but should be last in the array
                _valid = 2;
                break;
        }
        
        if (_valid == 1)
            array_insert(_results, 0, _candidate);
        else if (_valid == 2)
            array_push(_results, _candidate);
    }
    
    ds_list_destroy(_list);
    return _results;
}

/// @func get_collidables_y(range, scope)
/// @desc Checks for possible collisions above/below the given instance
///
/// @param {int}  range  How far up/down the instance's bounding box to check.
/// @param {prtEntity}  [scope]  The instance to check against. Defaults to the calling instance.
///
/// @return {array<prtCollidable>}  An array of collidables that the entity could collide with
function get_collidables_y(_range, _scope = self) {
    var _results = [],
        _list = ds_list_create();
    var _startY = (_range == 0) ? bbox_y_center(_scope) : bbox_vertical(-_range, _scope),
		_endY = bbox_vertical(_range, _scope) + _range;
    
    var _count = collision_rectangle_list(_scope.bbox_left, _startY, _scope.bbox_right, _endY, prtCollidable, false, false, _list, false);
    for (var i = 0; i < _count; i++) {
		var _candidate = _list[| i];
		
		if (_candidate.id == _scope.id)
            continue;
        if (is_object_type(prtEntity, _candidate) && !entity_is_solid_to_entity(_candidate, _scope))
			continue;
        if (is_object_type(objCustomSolid, _candidate) && !_candidate.is_solid_to_entity(_scope))
			continue;
		
		var _valid = 0; // 0 = not valid; 1 = valid; 2 = valid slope
        switch (get_collidable_type(_candidate, _scope)) {
			case SolidType.SOLID: // Always a candidate
                _valid = 1;
                break;
			case SolidType.TOP_SOLID: // Only count if we're moving down, and aren't already inside it
                _valid = (_range >= 0 && _scope.bbox_bottom <= _candidate.bbox_top);
                break;
            case SolidType.BOTTOM_SOLID: // Only count if we're moving up, and aren't already inside it
                _valid = (_range < 0 && _scope.bbox_top >= _candidate.bbox_bottom);
                break;
            case SolidType.GRAV_DIR_SOLID: // Only count if we're moving in the direction of gravity, and aren't already inside it
				if (_range * _scope.gravDir >= 0) {
					with (_scope)
						_valid = !place_meeting(x, y, _candidate);
				}
				break;
			case SolidType.SLOPE: // The entity's x-center must be within the slope
                var _isSteepSlope = slope_is_steep(_candidate, _scope),
                    _slopeXscale = _candidate.image_xscale,
                    _bboxWidth = bbox_width(_scope),
                    _bboxXCenter = bbox_x_center(_scope);
                var _leftBounds = _candidate.bbox_left - _bboxWidth * (_isSteepSlope && _slopeXscale < 0),
                    _rightBounds = _candidate.bbox_right + _bboxWidth * (_isSteepSlope && _slopeXscale > 0);
                _valid = 2 * (_bboxXCenter >= _leftBounds && _bboxXCenter <= _rightBounds);
                break;
            case SolidType.SLOPE_SOLID: // Depends on if the solid is exposed on either sides
				var _bboxWidth = bbox_width(_scope),
                    _bboxXCenter = bbox_x_center(_scope);
                var _leftBounds = _candidate.bbox_left - _bboxWidth * _candidate.exposedLeft,
                    _rightBounds = _candidate.bbox_right + _bboxWidth * _candidate.exposedRight;
                _valid = (_bboxXCenter >= _leftBounds && _bboxXCenter <= _rightBounds);
                break;
        }
        
        if (_valid == 1)
            array_insert(_results, 0, _candidate);
        else if (_valid == 2)
            array_push(_results, _candidate);
    }
    
    ds_list_destroy(_list);
    return _results;
}

#endregion

#region Moving Entities (Absolute)

/// @func move_and_collide_to_x(position, scope)
/// @desc Moves an entity horizontally to the given position, taking collisions into account
///
/// @param {number}  position  The x-position to move this entity to
/// @param {bool}  [test_only]  If true, the entity won't actually be moved. Defaults to false.
/// @param {prtEntity}  [scope]  The instance to move. Defaults to the calling instance.
function move_and_collide_to_x(_pos, _testOnly = false, _scope = self) {
    move_and_collide_x(_pos - entity_x(_scope), _testOnly, _scope);
}

/// @func move_and_collide_to_y(position, scope)
/// @desc Moves an entity verically to the given position, taking collisions into account
///
/// @param {number}  position  The y-position to move this entity to
/// @param {bool}  [test_only]  If true, the entity won't actually be moved. Defaults to false.
/// @param {prtEntity}  [scope]  The instance to move. Defaults to the calling instance.
function move_and_collide_to_y(_pos, _testOnly = false, _scope = self) {
    move_and_collide_y(_pos - entity_y(_scope), _testOnly, _scope);
}

/// @func move_to_x(position, scope)
/// @desc Moves an entity horizontally to the given position
///
/// @param {number}  position  The x-position to move this entity to
/// @param {prtEntity}  [scope]  The instance to move. Defaults to the calling instance.
function move_to_x(_pos, _scope = self) {
    move_x(_pos - entity_x(_scope), _scope);
}

/// @func move_to_y(position, scope)
/// @desc Moves an entity verically to the given position
///
/// @param {number}  position The y-position to move this entity to
/// @param {prtEntity}  [scope]  The instance to move. Defaults to the calling instance.
function move_to_y(_pos, _scope = self) {
    move_y(_pos - entity_y(_scope), _scope);
}

#endregion

#region Moving Entities (Relative)

/// @func move_and_collide_x(xspeed, test_only, scope)
/// @desc Moves the given entity left/right, taking collisions into account
///
/// @param {number}  xspeed  Moves the entity by this many pixels. Should be an integer.
/// @param {bool}  [test_only]  If true, the entity won't actually be moved. Defaults to false.
/// @param {prtEntity}  [scope]  The instance to move. Defaults to the calling instance.
///
/// @return {prtCollidable}  The collidable the entity has collided with. Returns noone if no collision occurs.
function move_and_collide_x(_xspeed, _testOnly = false, _scope = self) {
    if (_xspeed == 0)
        return noone;
    
    with (_scope) {
		var _wholePixels = floor(subPixelX + _xspeed),
			_subPixels = frac(_xspeed);
		subPixelX += (_xspeed - _wholePixels) * !_testOnly;
		
		if (_wholePixels != 0) {
			var _collidableList = get_collidables_x(_wholePixels),
				_collidableCount = array_length(_collidableList);
			var _distanceToMove = _wholePixels,
				_directionToMove = sign(_wholePixels),
				_collXInstance = noone;
			
			for (var i = 0; i < _collidableCount; i++) {
				var _collidable = _collidableList[i],
					_distanceToCollidable = distance_to_collidable_x(_collidable, _directionToMove);
				
				if (abs(_distanceToCollidable) >= abs(_distanceToMove))
					continue; // Too far
				if (_distanceToCollidable * _directionToMove < 0)
					continue; // Don't move backwards
				
				if (_collidable.solidType == SolidType.SLOPE) { // Slopes are a special kind
					if (_directionToMove == -sign(_collidable.image_xscale) && !slope_is_steep(_collidable)) {
						var _slopeY = slope_y_at(_collidable, bbox_x_center() + _wholePixels),
							_y = y;
							
						var _slopeResult = move_and_collide_y(_slopeY - bbox_vertical(-_collidable.image_yscale), _testOnly);
						if (_slopeResult == noone) {
							_collXInstance = (y != _y) ? noone : _collXInstance;
							continue;
						}
					}
				}
				
				_distanceToMove = _distanceToCollidable;
				_collXInstance = _collidable;
			}
			
			if (!_testOnly) {
				x += _distanceToMove;
				push_entities_x(_distanceToMove + _subPixels);
			}
			
			return _collXInstance;
		}
    }
    
    return noone; // Fail Safe
}

/// @func move_and_collide_y(yspeed, test_only, scope)
/// @desc Moves the given entity up/down, taking collisions into account
///
/// @param {int}  yspeed  Moves the entity by this many pixels. Should be an integer.
/// @param {bool}  [test_only]  If true, the entity won't actually be moved. Defaults to false.
/// @param {prtEntity}  [scope]  The instance to move. Defaults to the calling instance.
///
/// @return {prtCollidable}  The collidable the entity has collided with. Returns noone if no collision occurs.
function move_and_collide_y(_yspeed, _testOnly = false, _scope = self) {
    if (_yspeed == 0) // No need to continue if we have no speed
        return noone;
    
    with (_scope) {
        var _wholePixels = floor(subPixelY + _yspeed),
			_subPixels = frac(_yspeed);
		subPixelY += (_yspeed - _wholePixels) * !_testOnly;
		
		if (_wholePixels != 0) {
			var _collidableList = get_collidables_y(_wholePixels),
				_collidableCount = array_length(_collidableList);
			var _distanceToMove = _wholePixels,
				_directionToMove = sign(_wholePixels),
				_collYInstance = noone;
			
			for (var i = 0; i < _collidableCount; i++) {
				var _collidable = _collidableList[i],
					_distanceToCollidable = distance_to_collidable_y(_collidable, _directionToMove);
				
				if (_distanceToCollidable * _directionToMove < 0)
					continue; // Don't move backwards
				if (abs(_distanceToCollidable) >= abs(_distanceToMove))
					continue; // Too far
				
				if (_collidable.solidType == SolidType.SLOPE) { // Slopes are a special kind
					if (_directionToMove == -sign(_collidable.image_yscale) && slope_is_steep(_collidable)) {
						var _slopeX = slope_x_at(_collidable, bbox_vertical(-_collidable.image_yscale) + _yspeed),
							_x = x;
						
						var _slopeResult = move_and_collide_x(_slopeX - bbox_horizontal(-_collidable.image_xscale), _testOnly);
						if (_slopeResult == noone) {
							_collYInstance = (x != _x) ? noone : _collYInstance;
							continue;
						}
					}
				}
				
				_distanceToMove = _distanceToCollidable;
				_collYInstance = _collidable;
			}
			
			if (!_testOnly) {
				y += _distanceToMove;
				push_entities_y(_distanceToMove + _subPixels);
			}
			
			return _collYInstance;
		}
    }
    
    return noone; // Fail Safe
}

/// @func move_x(xspeed, scope)
/// @desc Moves the given entity left/right
///
/// @param {int}  xspeed  Moves the entity by this many pixels. Should be an integer.
/// @param {prtEntity}  [scope]  The instance to move. Defaults to the calling instance.
function move_x(_xspeed, _scope = self) {
    if (_xspeed == 0)
        return;
    
    with (_scope) {
        subPixelX += _xspeed;
		var _wholePixels = floor(subPixelX);
		subPixelX -= _wholePixels;
        x += _wholePixels;
        push_entities_x(_xspeed);
    }
}

/// @func move_y(yspeed, scope)
/// @desc Moves the given entity up/down
///
/// @param {int}  yspeed  Moves the entity by this many pixels. Should be an integer.
/// @param {prtEntity}  [scope]  The instance to move. Defaults to the calling instance.
function move_y(_yspeed, _scope = self) {
    if (_yspeed == 0)
        return;
    
    with (_scope) {
        subPixelY += _yspeed;
		var _wholePixels = floor(subPixelY);
		subPixelY -= _wholePixels;
        y += _wholePixels;
        push_entities_y(_yspeed);
    }
}

#endregion

#region Pushing Other Entities

/// @func push_entities_x(xspeed, scope)
/// @desc Given an entity that has moved horizontally, push other entities that are standing on it, or are in its path
///
/// @param {int}  xspeed  How much the entity moved
/// @param {prtEntity}  [scope]  The instance to move. Defaults to the calling instance.
function push_entities_x(_xspeed, _scope = self) {
	var _canShove = true;
	switch (_scope.solidType) {
        case SolidType.NOT_SOLID:
        case SolidType.SLOPE:
        case SolidType.SLOPE_SOLID:
            return;
        case SolidType.TOP_SOLID:
        case SolidType.BOTTOM_SOLID:
        case SolidType.GRAV_DIR_SOLID:
            _canShove = false;
            break;
	}
	
	var _subPixels = frac(_xspeed),
		_wholePixels = _xspeed - _subPixels;
    
    with (prtEntity) {
        if (!collideWithSolids || self.id == _scope.id || entity_is_dead())
            continue;
        
        if (groundInstance == _scope.id || ladderInstance == _scope.id || wallInstance == _scope.id) {
			var _subPixelCache = subPixelX;
			subPixelX = 0;
			move_and_collide_x(_wholePixels);
			entity_update_hitboxes();
			subPixelX = _subPixelCache;
            continue;
        }
        
        if (_canShove) {
			if (_scope.solidType == SolidType.LEFT_SOLID && _xspeed >= 0)
				continue;
			if (_scope.solidType == SolidType.RIGHT_SOLID && _xspeed <= 0)
				continue;
			
			if (place_meeting(x, y, _scope.id) && !place_meeting(x + _wholePixels, y, _scope.id)) {
				var _displacement = bbox_horizontal(_wholePixels, _scope.id) - bbox_horizontal(-_wholePixels);
				subPixelX = 0;
				move_and_collide_x(_displacement);
				entity_update_hitboxes();
				subPixelX = _scope.subPixelX;
			}
        }
    }
}

/// @func push_entities_y(yspeed, scope)
/// @desc Given an entity that has moved vertically, push other entities that are standing on it, or are in its path
///
/// @param {int}  yspeed  How much the entity moved
/// @param {prtEntity}  [scope]  The instance to move. Defaults to the calling instance.
function push_entities_y(_yspeed, _scope = self) {
	switch (_scope.solidType) {
        case SolidType.SOLID:
        case SolidType.TOP_SOLID:
        case SolidType.BOTTOM_SOLID:
        case SolidType.GRAV_DIR_SOLID:
            break;
        default:
            return;
	}
	
	var _subPixels = frac(_yspeed),
		_wholePixels = _yspeed - _subPixels;
    
    with (prtEntity) {
        if (!collideWithSolids || self.id == _scope.id || entity_is_dead())
            continue;
        
        if (groundInstance == _scope.id || ladderInstance == _scope.id || wallInstance == _scope.id) {
			subPixelY = 0;
			move_and_collide_y(_wholePixels);
			entity_update_hitboxes();
			subPixelY = _scope.subPixelY;
            continue;
        }
        
        if (_scope.solidType == SolidType.TOP_SOLID && _yspeed >= 0)
			continue;
		if (_scope.solidType == SolidType.BOTTOM_SOLID && _yspeed <= 0)
			continue;
		if (_scope.solidType == SolidType.GRAV_DIR_SOLID && _yspeed * gravDir >= 0)
			continue;
        
        if (place_meeting(x, y, _scope.id) && !place_meeting(x, y + _yspeed, _scope.id)) {
            var _displacement = bbox_vertical(_yspeed, _scope.id) - bbox_vertical(-_yspeed);
            subPixelY = 0;
            move_and_collide_y(_displacement);
            entity_update_hitboxes();
            subPixelY = _scope.subPixelY;
        }
    }
}

#endregion

#region Testing for Collisions

/// @func test_move_x(xspeed, scope)
/// @desc Checks for collisions along a horizontal path, without moving the instance
///
/// @param {int}  xspeed  Checks this many pixels horizontally. Should be an integer.
/// @param {prtEntity}  [scope]  The instance to "move". Defaults to the calling instance.
///
/// @return {bool}  If there is a collision in this path (true) or not (false)
function test_move_x(_xspeed, _scope = self) {
	return move_and_collide_x(_xspeed, true, _scope) != noone;
}

/// @func test_move_y(yspeed, scope)
/// @desc Checks for collisions along a vertical path, without moving the instance
///
/// @param {int}  yspeed  Checks this many pixels vertically. Should be an integer.
/// @param {prtEntity}  [scope]  The instance to "move". Defaults to the calling instance.
///
/// @return {bool}  If there is a collision in this path (true) or not (false)
function test_move_y(_yspeed, _scope = self) {
	return move_and_collide_y(_yspeed, true, _scope) != noone;
}

#endregion

#region Velocities

/// @func approach_point(target_x, target_y, speed, scope)
/// @desc Sets the velocity of the given entity to bring it towards the specified destination.
///		  The entity will not overshoot its destination, and returns if it reached said location yet.
///
/// @param {number}  target_x  x-position of the destination
/// @param {number}  target_y  y-position of the destination
/// @param {number}  speed  speed of the entity
/// @param {prtEntity}  [scope]  The instance to set the velocity of. Defaults to the calling instance.
///
/// @return {bool}  If the destination has been reached (true) or not (false)
function approach_point(_targetX, _targetY, _speed, _scope = self) {
	with (_scope) {
		var _deltaX = _targetX - x,
			_deltaY = _targetY - y;
		if (_deltaX == 0 && _deltaY == 0) {
			xspeed = 0;
			yspeed = 0;
			return true;
		}
		
		var _dir = point_direction(x, y, _targetX, _targetY);
		_speed = min(_speed, point_distance(x, y, _targetX, _targetY));
		set_velocity_vector(_speed, _dir);
	}
	
	return false;
}

/// @func set_velocity_vector(speed, direction, scope)
/// @desc Sets the velocity of the given entity, using a direction & magnitude
///
/// @param {number}  speed  The magnitude of the velocity
/// @param {number}  direction  The direction of the velocity
/// @param {prtEntity}  [scope]  The instance to set the velocity of. Defaults to the calling instance.
function set_velocity_vector(_speed, _direction, _scope = self) {
	with (_scope) {
		direction = _direction;
		speed = _speed;
		xspeed = hspeed;
		yspeed = vspeed;
		direction = 0;
		speed = 0;
	}
}

#endregion

#region Other

/// @func try_splashing(x1, y1, x2, y2)
/// @desc Given a line, this function tries to make a splash against any water instances in the line's path
///
/// @param {number}  x1  The x coordinate of the start of the line.
/// @param {number}  y1  The y coordinate of the start of the line.
/// @param {number}  x2  The x coordinate of the end of the line.
/// @param {number}  y2  The y coordinate of the end of the line.
function try_splashing(_x1, _y1, _x2, _y2) {
	var _inWaterStart = position_meeting(_x1, _y1, objWater),
		_inWaterEnd = position_meeting(_x2, _y2, objWater);
	if (_inWaterStart == _inWaterEnd)
		return;
	
	var _water = _inWaterStart ? instance_position(_x1, _y1, objWater) : instance_position(_x2, _y2, objWater);
	
	for (var i = 0; i < 4; i++) {
		if (!bitmask_has_bit(_water.splashDirection, 1 << i))
			continue;
		
		var _line/*:Line*/ = _water.lines[i],
			_intersect/*:Vector2*/ = line_line_intersects(_x1, _y1, _x2, _y2, _line[Line.x1], _line[Line.y1], _line[Line.x2], _line[Line.y2]);
		if (is_undefined(_intersect))
			continue;
		
		var _splash = instance_create_depth(_intersect[Vector2.x], _intersect[Vector2.y], depth, objSplash, {
			image_angle: 90 * (i - 1),
			waterInstance: _water
		});
	}
}

#endregion
