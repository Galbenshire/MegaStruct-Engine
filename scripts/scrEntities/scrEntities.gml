#region Substeps

/// @self {prtEntity}
/// @func entity_check_ground()
/// @desc Any entity calling this function will check for a ground directly underneath them
function entity_check_ground() {
	// TO-DO
}

/// @self {prtEntity}
/// @func entity_gravity(force)
/// @desc Applies gravity to an entity
///
/// @param {number}  [force]  How strong the gravity should be. Defaults to the entity's gravity.
function entity_gravity(_force = grav) {
	// TO-DO
}

/// @self {prtEntity}
/// @func entity_horizontal_movement()
/// @desc Moves an entity horizontally
function entity_horizontal_movement() {
	xcoll = 0;
	xcollInstance = noone;
	xspeed.update();
	
	if (collideWithSolids) {
		// move and collide
	} else {
		// move
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
		// move and collide
	} else {
		// move
	}
}

/// @self {prtEntity}
/// @func entity_water()
/// @desc Entity interaction with water
function entity_water() {
	
}

#endregion

#region Respawn/Despawn

/// @func entity_within_despawn_range(scope)
/// @desc Checks if the specified entity's despawn range is within game view
///
/// @param {prtEntity}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity is within range (true) or not (false)
function entity_within_despawn_range(_scope = self) {
    if (_scope.despawnRange == infinity)
        return true;
    
    var _gameView = game_view(),
		_entityLeft = _scope.bbox_left - _scope.despawnRange,
        _entityTop = _scope.bbox_top - _scope.despawnRange,
        _entityRight = _scope.bbox_right + _scope.despawnRange,
        _entityBottom = _scope.bbox_bottom + _scope.despawnRange,
        _screenLeft = _gameView.left_edge(0, false),
        _screenTop = _gameView.top_edge(0, false),
        _screenRight = _gameView.right_edge(0, false),
        _screenBottom = _gameView.bottom_edge(0, false);
    
    return _entityLeft <= _screenRight
		&& _entityTop <= _screenBottom
		&& _entityRight >= _screenLeft
		&& _entityBottom >= _screenTop;
}

/// @func entity_within_respawn_range(scope)
/// @desc Checks if the specified entity's respawn range is within game view
///
/// @param {prtEntity}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity is within range (true) or not (false)
function entity_within_respawn_range(_scope = self) {
    if (_scope.respawnRange == infinity)
        return true;
    
    var _gameView = game_view(),
		_entityLeft = _scope.bbox_left - _scope.respawnRange,
        _entityTop = _scope.bbox_top - _scope.respawnRange,
        _entityRight = _scope.bbox_right + _scope.respawnRange,
        _entityBottom = _scope.bbox_bottom + _scope.respawnRange,
        _screenLeft = _gameView.left_edge(0, false),
        _screenTop = _gameView.top_edge(0, false),
        _screenRight = _gameView.right_edge(0, false),
        _screenBottom = _gameView.bottom_edge(0, false);
    
    return _entityLeft <= _screenRight
		&& _entityTop <= _screenBottom
		&& _entityRight >= _screenLeft
		&& _entityBottom >= _screenTop;
}

#endregion

/// @func entity_can_step(scope)
/// @desc Checks if the specified entity is able to perform their Step Event
///
/// @param {prtEntity}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity can step (true) or not (false)
function entity_can_step(_scope = self) {
	return !global.paused && !entity_is_dead(_scope);
}

/// @func entity_is_dead(scope)
/// @desc Checks if the specified entity is dead
///
/// @param {prtEntity}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity is alive (true) or not (false)
function entity_is_dead(_scope = self) {
	return _scope.lifeState != LifeState.ALIVE;
}


