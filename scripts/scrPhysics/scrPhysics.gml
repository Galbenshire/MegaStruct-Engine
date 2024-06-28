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
    
    switch (_collidable.solidType) {
        // Slopes are treated differently
        // But only if the entity is not approaching the flat end
        case SolidType.SLOPE:
            if (sign(_direction) != sign(_collidable.image_xscale)) {
                var _slopeX = slope_x_at(_collidable, bbox_vertical(-_collidable.image_yscale, _scope)),
                    _startX = slope_is_steep(_collidable) ? bbox_horizontal(-_collidable.image_xscale, _scope) : bbox_x_center(_scope);
                return _slopeX - _startX;
            }
            break;
        
        // For Slope Solids, it depends on if the side is exposed (has no slope)
        case SolidType.SLOPE_SOLID:
            var _exposed = _direction >= 0 ? _collidable.exposedLeft : _collidable.exposedRight;
            if (!_exposed)
                return bbox_horizontal(-_direction, _collidable) - bbox_x_center(_scope);
            break;
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
    if (_collidable.solidType == SolidType.SLOPE && sign(_direction) != sign(_collidable.image_yscale)) {
        var _x = slope_is_steep(_collidable) ? bbox_horizontal(-_collidable.image_xscale, _scope) : bbox_x_center(_scope),
            _slopeY = slope_y_at(_collidable, _x);
        return _slopeY - bbox_vertical(-_collidable.image_yscale, _scope);
    }
    
    return bbox_vertical(-_direction, _collidable) - bbox_vertical(_direction, _scope);
}

/// @func get_xcoll_candidates(range, scope)
/// @desc Checks for possible collisions to the left/right of the given instance
///
/// @param {number}  range  How far ahead to check.
/// @param {prtEntity}  [scope]  The instance to check against. Defaults to the calling instance.
///
/// @return {array<prtCollidable>}  An array of collidables that the entity could collide with
function get_xcoll_candidates(_range, _scope = self) {
    var _list = global.__collisionList,
        _results = [];
    var _count = collision_rectangle_list(bbox_x_center(_scope), _scope.bbox_top, bbox_horizontal(_range, _scope) + _range, _scope.bbox_bottom,
        prtCollidable, false, false, _list, false);
    
    with (_scope) {
        for (var i = 0; i < _count; i++) {
            if (_list[| i].id == self.id)
                continue;
            if (is_object_type(prtEntity, _list[| i]) && entity_is_dead(_list[| i]))
                continue;
            
            var _valid = 0; // 0 = not valid; 1 = valid; 2 = valid slope
            
            switch (_list[| i].solidType) {
                case SolidType.SOLID: // Always a candidate
                case SolidType.SLOPE_SOLID:
                    _valid = 1;
                    break;
                case SolidType.LEFT_SOLID: // Only count if we're moving to the left, and aren't already inside it
                    _valid = (_range >= 0) && (bbox_right <= _list[| i].bbox_left);
                    break;
                case SolidType.RIGHT_SOLID: // Only count if we're moving to the right, and aren't already inside it
                    _valid = (_range < 0) && (bbox_left >= _list[| i].bbox_right);
                    break;
                case SolidType.SLOPE: // Always a candidate, but should be last in the array
                    _valid = 2;
                    break;
            }
            
            if (_valid == 1)
                array_insert(_results, 0, _list[| i]);
            else if (_valid == 2)
                array_push(_results, _list[| i]);
        }
    }
    
    ds_list_clear(_list);
    return _results;
}

/// @func get_ycoll_candidates(range, scope)
/// @desc Checks for possible collisions above/below the given instance
///
/// @param {int}  range  How far up/down to check.
/// @param {prtEntity}  [scope]  The instance to check against. Defaults to the calling instance.
///
/// @return {array<prtCollidable>}  An array of collidables that the entity could collide with
function get_ycoll_candidates(_range, _scope = self) {
    var _list = global.__collisionList,
        _results = [],
        _bboxEdge = bbox_vertical(_range, _scope),
        _bboxWidth = bbox_width(_scope),
        _bboxXCenter = bbox_x_center(_scope),
        _count = collision_rectangle_list(_scope.bbox_left, bbox_y_center(_scope), _scope.bbox_right, _bboxEdge + _range,
            prtCollidable, false, false, _list, false);
    
    with (_scope) {
        for (var i = 0; i < _count; i++) {
            if (_list[| i].id == self.id)
                continue;
            if (is_object_type(prtEntity, _list[| i]) && entity_is_dead(_list[| i]))
            	continue;
            
            var _valid = 0; // 0 = not valid; 1 = valid; 2 = valid slope
            
            switch (_list[| i].solidType) {
                case SolidType.SOLID: // Always a candidate
                    _valid = 1;
                    break;
                case SolidType.TOP_SOLID: // Only count if we're moving down, and aren't already inside it
                    _valid = _range >= 0 && (bbox_bottom <= _list[| i].bbox_top);
                    break;
                case SolidType.BOTTOM_SOLID: // Only count if we're moving up, and aren't already inside it
                    _valid = _range < 0 && (bbox_top >= _list[| i].bbox_bottom);
                    break;
                case SolidType.GRAV_DIR_SOLID: // Only count if we're moving in the direction of gravity, and aren't already inside it
                	_valid = _range * gravDir >= 0 && !place_meeting(x, y, _list[| i]);
                	break;
                case SolidType.SLOPE: // The entity's x-center must be within the slope
                    var _is_steep = slope_is_steep(_list[| i]),
                        _xscale = _list[| i].image_xscale,
                        _left_bounds = _list[| i].bbox_left - _bboxWidth * (_is_steep && _xscale < 0),
                        _right_bounds = _list[| i].bbox_right + _bboxWidth * (_is_steep && _xscale > 0);
                    _valid = 2 * (_bboxXCenter >= _left_bounds && _bboxXCenter < _right_bounds);
                    break;
                case SolidType.SLOPE_SOLID: // Depends on if the solid is exposed on either sides
                    var _left_bounds = _list[| i].bbox_left - _bboxWidth * _list[| i].exposedLeft,
                        _right_bounds = _list[| i].bbox_right + _bboxWidth * _list[| i].exposedRight;
                    _valid = _bboxXCenter >= _left_bounds && _bboxXCenter < _right_bounds;
                    break;
            }
            
            if (_valid == 1)
                array_insert(_results, 0, _list[| i]);
            else if (_valid == 2)
                array_push(_results, _list[| i]);
        }
    }
    
    ds_list_clear(_list);
    return _results;
}

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
        var _collidables = get_xcoll_candidates(_xspeed),
            _collidableCount = array_length(_collidables),
            _bboxXCenter = bbox_x_center(),
            _distanceToMove = _xspeed,
            _directionToMove = sign(_xspeed),
            _collXInstance = noone,
            _y = y;
        
        for (var i = 0; i < _collidableCount; i++) {
            var _distanceToCollidable = distance_to_collidable_x(_collidables[i], _xspeed);
            
            if (_distanceToCollidable * _directionToMove < 0 || abs(_distanceToCollidable) >= abs(_distanceToMove))
                continue;
            
            // Slopes are a special kind
            if (_collidables[i].solidType == SolidType.SLOPE && sign(_xspeed) == -sign(_collidables[i].image_xscale)) {
                if (!slope_is_steep(_collidables[i])) {
                    var _slopeY = slope_y_at(_collidables[i], _bboxXCenter + _xspeed),
                        _slopeResult = move_and_collide_y(_slopeY - bbox_vertical(-_collidables[i].image_yscale), _testOnly);
                    
                    if (_slopeResult == noone) {
						_collXInstance = (y != _y) ? noone : _collXInstance;
                        continue;
                    }
                }
            }
            
            _distanceToMove = _distanceToCollidable;
            _collXInstance = _collidables[i];
        }
        
        if (!_testOnly) {
			x += _distanceToMove;
			push_entities_x(_distanceToMove);
        }
        
        return _collXInstance;
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
        var _collidables = get_ycoll_candidates(_yspeed, _scope),
            _collidableCount = array_length(_collidables),
            _bboxYCenter = bbox_y_center(),
            _distanceToMove = _yspeed,
            _directionToMove = sign(_yspeed),
            _collYInstance = noone,
            _x = x;
        
        for (var i = 0; i < _collidableCount; i++) {
            var _distanceToCollidable = distance_to_collidable_y(_collidables[i], _yspeed);
            
            if (_distanceToCollidable * _directionToMove < 0 || abs(_distanceToCollidable) >= abs(_distanceToMove))
                continue;
            
            // Slopes are a special kind
            if (_collidables[i].solidType == SolidType.SLOPE && sign(_yspeed) == -sign(_collidables[i].image_yscale)) {
                if (slope_is_steep(_collidables[i])) {
                    var _slopeX = slope_x_at(_collidables[i], bbox_vertical(-_collidables[i].image_yscale, _scope) + _yspeed),
                        _slopeResult = move_and_collide_x(_slopeX - bbox_horizontal(-_collidables[i].image_xscale), _testOnly);
                    
                    if (_slopeResult == noone) {
						_collYInstance = (x != _x) ? noone : _collYInstance;
                        continue;
                    }
                }
            }
            
            _distanceToMove = _distanceToCollidable;
            _collYInstance = _collidables[i];
        }
        
        if (!_testOnly) {
			y += _distanceToMove;
			push_entities_y(_distanceToMove);
        }
        
        return _collYInstance;
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
        x += _xspeed;
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
        y += _yspeed;
        push_entities_y(_yspeed);
    }
}

/// @func push_entities_x(xspeed, scope)
/// @desc Given an entity that has moved horizontally, push other entities that are standing on it, or are in its path
///
/// @param {int}  xspeed  How much the entity moved
/// @param {prtEntity}  [scope]  The instance to move. Defaults to the calling instance.
function push_entities_x(_xspeed, _scope = self) {
	var _carryOnly = false;
	switch (_scope.solidType) {
        case SolidType.NOT_SOLID:
        case SolidType.SLOPE:
        case SolidType.SLOPE_SOLID:
            return;
        case SolidType.TOP_SOLID:
        case SolidType.BOTTOM_SOLID:
        case SolidType.GRAV_DIR_SOLID:
            _carryOnly = true;
            break;
	}
    
    with (prtEntity) {
        if (!collideWithSolids || self.id == _scope.id || entity_is_dead())
            continue;
        
        if (groundInstance == _scope.id || ladderInstance == _scope.id) {
            move_and_collide_x(_xspeed);
            continue;
        }
        
        if (_carryOnly)
			continue;
		if (_scope.solidType == SolidType.LEFT_SOLID && _xspeed >= 0)
			continue;
		if (_scope.solidType == SolidType.RIGHT_SOLID && _xspeed <= 0)
			continue;
        
        if (place_meeting(x, y, _scope.id) && !place_meeting(x + _xspeed, y, _scope.id)) {
            var _displacement = bbox_horizontal(_xspeed, _scope.id) - bbox_horizontal(-_xspeed);
            move_and_collide_x(_displacement);
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
    
    with (prtEntity) {
        if (!collideWithSolids || self.id == _scope.id || entity_is_dead())
            continue;
        
        if (groundInstance == _scope.id || ladderInstance == _scope.id) {
            move_and_collide_y(_yspeed);
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
            move_and_collide_y(_displacement);
        }
    }
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
		xspeed.value = hspeed;
		yspeed.value = vspeed;
		direction = 0;
		speed = 0;
	}
}

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
		if (!(_water.splashDirection & (1 << i)))
			continue;
		
		var _line/*:Line*/ = _water.lines[i],
			_intersect/*:Vector*/ = line_line_intersects(_x1, _y1, _x2, _y2, _line[Line.x1], _line[Line.y1], _line[Line.x2], _line[Line.y2]);
		if (is_undefined(_intersect))
			continue;
		
		var _splash = instance_create_depth(_intersect[Vector.x], _intersect[Vector.y], depth, objSplash, {
			image_angle: 90 * (i - 1),
			waterInstance: _water
		});
	}
}
