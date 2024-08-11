#region Substeps (mainly called during a Step Event)

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
	groundInstance = _foundGround ? _groundInstance : noone;
	
	if (_foundGround)
		push_entities_y(_distanceToMove);
}

/// @self {prtEntity}
/// @func entity_entity_collision(damage, subject)
/// @desc Makes one entity attempt to apply damage to another entity
///
/// @param {number}  [damage]  How much damage the attack will deal. Defaults to the entity's contactDamage.
/// @param {prtEntity}  [suject]  The entity to deal damage to. Defaults to `other`.
function entity_entity_collision(_damage = contactDamage, _subject = other) {
	if (array_contains(hitIgnoreList, _subject))
		return;
	
	var _damageSource = new DamageSource(self, _subject, _damage);
	_subject.onSetDamage(_damageSource);
	
	_subject.onGuard(_damageSource);
	if (_damageSource.damage == 0)
		_damageSource.guard = (_damageSource.guard == GuardType.DAMAGE) ? GuardType.FORCE_REFLECT : max(GuardType.REFLECT, _damageSource.guard);
	
	var _wasGuarded = false;
	switch (_damageSource.guard) {
		case GuardType.DAMAGE: // There is no guard. Damage will occur.
			break;
		
		case GuardType.REFLECT: // Depends on the attacker's penetrate variable
			if (penetrate == PenetrateType.NONE)
				onReflected(_damageSource);
			else if (penetrate == PenetrateType.NO_DAMAGE_AND_COLLISION)
				array_push(hitIgnoreList, _subject);
			
			_wasGuarded = penetrate != PenetrateType.BYPASS_GUARD;
			break;
		
		case GuardType.IGNORE: // Pass through the subject with no effect
			_wasGuarded = true;
			break;
		
		case GuardType.REFLECT_OR_IGNORE: // Depends on the attacker's penetrate variable, but always causes no damage
			if (penetrate == PenetrateType.NONE)
				onReflected(_damageSource);
			_wasGuarded = true;
			break;
		
		case GuardType.FORCE_REFLECT: // Always causes the reflected callback
			onReflected(_damageSource);
			_wasGuarded = true;
			break;
	}
	
	if (_wasGuarded) {
		delete _damageSource;
		return;
	}
	
	onAttackBegin(_damageSource);
	if (_damageSource.has_flag(DamageFlags.NO_DAMAGE)) {
		delete _damageSource;
		return;
	}
	
	with (_damageSource.subject) {
		var _mockDamage = _damageSource.has_flag(DamageFlags.MOCK_DAMAGE);
		if (!_mockDamage)
			healthpoints -= _damageSource.damage;
		
		lastHitBy = other;
		onHurt(_damageSource);
		hitTimer = 0;
		
		if (healthpoints <= 0 && !_mockDamage) {
			_damageSource.hasKilled = true;
			onDeath(_damageSource);
		}
		
		other.onAttackEnd(_damageSource);
	}
	
	if (pierces == PierceType.NEVER || (pierces == PierceType.ON_KILLS_ONLY && !_damageSource.hasKilled))
		entity_kill_self();
	
	delete _damageSource;
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
	if (place_meeting(x, y, objConveyorBeltArea) && ground && !asset_has_tags(object_index, "ignore_conveyor", asset_object)) {
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
		subPixelX += groundInstance.subPixelX;
		subPixelY += groundInstance.subPixelY;
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

#endregion

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
    if (is_infinity(_scope.respawnRange))
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
	// Disable depthOffset
	// (it's only meant for entities added via the Room Editor anyways)
	_vars.depthOffset = 0;
	
	var _entity = instance_create(_x, _y, _depthOrLayer, _obj, _vars);
	_entity.lifeState = LifeState.ALIVE;
	_entity.onSpawn();
	return _entity;
}

#endregion

#region Other

/// @func entity_can_attack_entity(target, scope)
/// @desc Checks if the specified entity would be able to attack (i.e. collide with) the targeted entity
///
/// @param {prtEntity}  target  The instance to check.
/// @param {prtEntity}  [scope]  The instance that's performing this check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity can step (true) or not (false)
function entity_can_attack_entity(_target, _scope = self) {
	return _target != _scope && _target.canTakeDamage && _target.iFrames == 0 && _target.hitTimer >= _scope.attackDelay
		&& !entity_is_dead(_target) && (_scope.factionMask & _target.factionLayer > 0);
}

/// @func entity_can_step(ignore_frozen, scope)
/// @desc Checks if the specified entity is able to perform their Step Event
///
/// @param {bool}  [ignore_frozen]  Whether or not to ignore the entity's frozen state. Defaults to false.
/// @param {prtEntity}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity can step (true) or not (false)
function entity_can_step(_ignoreFrozen = false, _scope = self) {
	return !global.paused && (_ignoreFrozen || frozenTimer <= 0) && !entity_is_dead(_scope);
}

/// @func entity_can_target_entity(target, scope)
/// @desc Checks if the specified entity would be able to target another entity
///
/// @param {prtEntity}  target  The instance to target.
/// @param {prtEntity}  [scope]  The instance that's performing this check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity can step (true) or not (false)
function entity_can_target_entity(_target, _scope = self) {
	return _target != _scope && _target.canTakeDamage && _target.isTargetable
		&& !entity_is_dead(_target) && (entity_get_faction_targets(_scope) & _target.factionLayer > 0);
}

/// @func entity_get_faction_targets(target, scope)
/// @desc Gets the factions the specified entity is able to target.
///		  If the entity's `factionTargetWhitelist` variable is a non-zero value, that value will be used.
///		  Otherwise, the value of `factionMask` gets returned instead.
///
/// @param {prtEntity}  [scope]  The instance to get the value from. Defaults to the calling instance.
///
/// @returns {int}  The factions this entity can target, in a bitmask form
function entity_get_faction_targets(_scope = self) {
	return (_scope.factionTargetWhitelist > 0) ? _scope.factionTargetWhitelist : _scope.factionMask;
}

/// @func entity_get_faction_solids(target, scope)
/// @desc Gets the factions the specified entity acts solid towards.
///		  If the entity's `factionSolidWhitelist` variable is a non-zero value, that value will be used.
///		  Otherwise, the entity is treated as being solid to all entities.
///
/// @param {prtEntity}  [scope]  The instance to get the value from. Defaults to the calling instance.
///
/// @returns {int}  The factions this entity is solid towards, in a bitmask form
function entity_get_faction_solids(_scope = self) {
	return (_scope.factionSolidWhitelist > 0) ? _scope.factionSolidWhitelist : 0xFFFFFFFF;
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

/// @func entity_is_solid_to_entity(target, scope)
/// @desc Checks if the specified entity is solid to another entity
///
/// @param {prtEntity}  target  The instance to check against.
/// @param {prtEntity}  [scope]  The instance that's performing this check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity is solid to the target (true) or not (false)
function entity_is_solid_to_entity(_target, _scope = self) {
	return _target != _scope && !entity_is_dead(_scope) && (entity_get_faction_solids(_scope) & _target.factionLayer > 0);
}

/// @func entity_kill_self(scope)
/// @desc Tells the specified entity to kill itself, by calling its onDeath callback
function entity_kill_self(_scope = self) {
	var _selfDamage = new DamageSourceSelf(_scope);
	_selfDamage.hasKilled = true;
	_scope.onDeath(_selfDamage);
	delete _selfDamage;
}

#endregion
