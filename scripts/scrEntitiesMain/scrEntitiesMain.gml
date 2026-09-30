#region Spawning

/// @func entity_within_despawn_range(scope)
/// @desc Checks if the specified entity's despawn range is within game view
///
/// @param {prtEntity}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity is within range (true) or not (false)
function entity_within_despawn_range(_scope = self) {
    if (is_infinity(_scope.despawnRange))
        return true;
    
    var _gameView = game_view();
    if (_scope.bbox_left > _gameView.right_edge(_scope.despawnRange, false))
		return false;
	if (_scope.bbox_right < _gameView.left_edge(-_scope.despawnRange, false))
		return false;
	if (_scope.bbox_top > _gameView.bottom_edge(_scope.despawnRange, false))
		return false;
	if (_scope.bbox_bottom < _gameView.top_edge(-_scope.despawnRange, false))
		return false;
	
	return true;
}

/// @func entity_within_respawn_range(scope)
/// @desc Checks if the specified entity's respawn range is within game view
///
/// @param {prtEntity}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity is within range (true) or not (false)
function entity_within_respawn_range(_scope = self) {
    if (is_infinity(_scope.respawnRange))
        return true;
    
	var _gameView = game_view();
    if (_scope.bbox_left > _gameView.right_edge(_scope.respawnRange, false))
		return false;
	if (_scope.bbox_right < _gameView.left_edge(-_scope.respawnRange, false))
		return false;
	if (_scope.bbox_top > _gameView.bottom_edge(_scope.respawnRange, false))
		return false;
	if (_scope.bbox_bottom < _gameView.top_edge(-_scope.respawnRange, false))
		return false;
	
	return true;
}

/// @func spawn_entity(x, y, depth_or_layer, object, var_struct)
/// @desc Spawns an entity.
///		  This works like instance_create_*, but will take the actions needed to spawn the entity correctly
///
/// @param {number}  x  The x position the instance of the given entity will be created at
/// @param {number}  y  The y position the instance of the given entity will be created at
/// @param {number|layer|string}  depth_or_layer  The depth/layer to assign the created instance to
/// @param {prtEntity}  obj  The object index of the entity to create an instance of
/// @param {struct}  [var_struct]  A struct with variables to assign to the new instance. Optional.
///
/// @returns {instance}  An instance of the entity specified
function spawn_entity(_x, _y, _depthOrLayer, _obj, _vars = {}) {
	var _entity = instance_create(_x, _y, _depthOrLayer, _obj, _vars);
	_entity.lifeState = LifeState.ALIVE;
	_entity.onSpawn();
	return _entity;
}

#endregion

#region Misc.

/// @func entity_clear_hitboxes(scope)
/// @desc Removes all hitboxes associated with the specified entity
///
/// @param {prtEntity}  [scope]  The instance to perform this on. Defaults to the calling instance.
function entity_clear_hitboxes(_scope = self) {
	for (var i = 0; i < _scope.hitboxCount; i++)
		instance_destroy(_scope.hitboxes[i]);
	array_clear(_scope.hitboxes);
	_scope.hitboxCount = 0;
}

/// @func entity_death_explosion(drop_item, scope)
/// @desc Entity death explosion. Might drop an item.
///
/// @param {bool}  drop_item  Whether to drop an item (true) or not (false)
/// @param {prtEntity}  [scope]  The instance to perform this on. Defaults to the calling instance.
///
/// @returns {objExplosion}
function entity_death_explosion(_dropItem, _scope = self) {
	var _expl = instance_create(bbox_x_center(_scope), bbox_y_center(_scope), _scope.depth, objExplosion);
    if (_dropItem)
		_expl.itemDrop = _scope.itemDrop;
	return _expl;
}

/// @func entity_draw(x, y, scope)
/// @desc Draws the given entity as the specified location
function entity_draw(_x, _y, _scope = self) {
	with (_scope) {
		if (!onPreDraw()) {
			gpu_pop_state(); // We called `gpu_push_state` in the preDraw
			return;
		}
		
		var _cachedX = x,
			_cachedY = y;
		x = _x;
		y = _y;
		
		onDraw();
		onPostDraw();
		
		x = _cachedX;
		y = _cachedY;
	}
}

/// @func entity_freeze(time, colour, scope)
/// @desc Freezes the entity
///
/// @param {number}  time  The duration of the freeze
/// @param {int}  colour  The colour to apply over the entity while it's frozen
/// @param {prtEntity}  [scope]  The entity to freeze. Defaults to the calling instance.
function entity_freeze(_time, _colour, _scope) {
	if (_time <= 0)
		return;
	
	with (_scope) {
		if (frozenTimer > _time && frozenColour == _colour)
			return;
		
		frozenTimer = _time;
        frozenColour = _colour;
        frozenPhysicsEnabled = false; // I'll implement this eventually
	}
}

/// @func entity_kill_self(scope)
/// @desc Tells the specified entity to kill itself, by calling its onDeath callback
function entity_kill_self(_scope = self) {
	var _selfDamage = new DamageSource(_scope, _scope, 0);
	_selfDamage.hasKilled = true;
	_scope.__isKilled = true;
	_scope.onDeath(_selfDamage);
	delete _selfDamage;
}

/// @func entity_set_gravity(enabled, strength, dir, scope)
/// @desc Helper function for quickly setting various gravity settings on a given entity
///
/// @param {bool}  enabled  Enables gravity
/// @param {number}  [strength]  Sets the strength of the gravity
/// @param {int}  [dir]  Sets the direction of the gravity
/// @param {prtEntity}  [scope]  The entity to set the gravity of. Defaults to the calling instance.
function entity_set_gravity(_enabled, _strength = grav, _dir = gravDir, _scope = self) {
	_scope.gravEnabled = bool(_enabled);
	_scope.grav = abs(_strength);
	_scope.gravDir = sign_nonzero(_dir);
}

#endregion
