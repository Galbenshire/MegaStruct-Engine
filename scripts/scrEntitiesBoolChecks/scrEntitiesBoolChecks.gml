#region Entity/Entity Collisions

/// @func entity_can_deal_damage(scope)
/// @desc Checks if an entity is currently able to deal damage to other entities
///
/// @param {prtEntity}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity can deal damage (true) or not (false)
function entity_can_deal_damage(_scope = self) {
	return entity_has_hitmask_flag(HitMask.DEAL_DAMAGE, _scope) && _scope.contactDamage != 0 && !entity_is_dead(_scope);
}

/// @func entity_can_take_damage(ignore_i_frames, scope)
/// @desc Checks if an entity is currently able to receive damage from other entities
///
/// @param {bool}  [ignore_i_frames]  Whether we should ignore iframes. Defaults to false
/// @param {prtEntity}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity can take damage (true) or not (false)
function entity_can_take_damage(_ignoreIFrames = false, _scope = self) {
	return entity_has_hitmask_flag(HitMask.TAKE_DAMAGE, _scope) && (_ignoreIFrames || _scope.iFrames == 0) && !entity_is_dead(_scope);
}

/// @func entity_has_hitmask_flag(flag, scope)
/// @desc Checks if an entity has the specified flag set in its hitmask
///       Their master hitmask will also be checked
///
/// @param {int}  flag  The hitmask flag to check for
/// @param {prtEntity}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  Whether the specified flag is set (true) or not (false)
function entity_has_hitmask_flag(_flag, _scope = self) {
    return bitmask_has_bit(_scope.hitmask, _flag) && bitmask_has_bit(_scope.hitmaskMaster, _flag);
}

#endregion

#region Targetting
	
/// @func entity_can_target_entity(target, hunter)
/// @desc Checks if an entity would be able to target another entity
///
/// @param {prtEntity}  target  The instance to target.
/// @param {prtEntity}  [hunter]  The entity attempting to target. Defaults to the calling instance.
///
/// @returns {bool}  If the entity can step (true) or not (false)
function entity_can_target_entity(_target, _hunter = self) {
	return _target != _hunter && entity_is_targetable(false, _target) && bitmask_has_bit(_hunter.factionTargetMask, _target.factionLayer);
}
	
/// @func entity_is_targetable(ignore_dead, scope)
/// @desc Checks if the specified entity can be targetted by other entities
///
/// @param {bool}  [ignore_dead]  Whether we should ignore if the entity is dead or not. Defaults to false
/// @param {prtEntity}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity is alive (true) or not (false)
function entity_is_targetable(_ignoreDead = false, _scope = self) {
	return entity_has_hitmask_flag(HitMask.TAKE_DAMAGE, _scope) && _scope.isTargetable && (_ignoreDead || !entity_is_dead(_scope));
}
	
#endregion

#region Other

/// @func entity_appears_frozen(scope)
/// @desc Checks if an entity should appear in a frozen state (e.g. appear blue from being iced)
///
/// @param {prtEntity}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity should appear frozen (true) or not (false)
function entity_appears_frozen(_scope = self) {
	if (_scope.frozenTimer <= 0)
		return false;
	if (_scope.frozenTimer > FROZEN_FLICKER_POINT)
		return true;
	return (!(_scope.frozenTimer & 3));
}

/// @func entity_can_draw(scope)
/// @desc Checks if an entity is able to be drawn
///
/// @param {prtEntity}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity can be drawn (true) or not (false)
function entity_can_draw(_scope = self) {
	return !entity_is_dead(_scope) && !global.pauseMenuActive;
}

/// @func entity_can_respawn(scope)
/// @desc Checks if an entity is capable of respawning.
///
/// @param {prtEntity}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity can respawn (true) or not (false)
function entity_can_respawn(_scope = self) {
	switch (_scope.respawnType) {
		case RespawnType.ENABLED: return true;
		case RespawnType.DISABLE_ON_DEATH: return true;
		case RespawnType.DESTROY_ON_DEATH: return !_scope.__isKilled;
		case RespawnType.DISABLED: return false;
	}
	return false;
}

/// @func entity_can_spawn(scope)
/// @desc Checks if an entity can currently spawn.
///		  This is different from `entity_can_respawn`.
///		  This checks if an offscreen entity is currently able to spawn.
///
/// @param {prtEntity}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity can spawn (true) or not (false)
function entity_can_spawn(_scope = self) {
	switch (_scope.respawnType) {
		case RespawnType.ENABLED: return true;
		case RespawnType.DISABLE_ON_DEATH: return !_scope.__isKilled;
		case RespawnType.DESTROY_ON_DEATH: return !_scope.__isKilled;
		case RespawnType.DISABLED: return false;
	}
	return false;
}

/// @func entity_can_step(ignore_frozen, scope)
/// @desc Checks if an entity is able to perform their Step Event
///
/// @param {bool}  [ignore_frozen]  Whether or not to ignore the entity's frozen state. Defaults to false.
/// @param {prtEntity}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity can step (true) or not (false)
function entity_can_step(_ignoreFrozen = false, _scope = self) {
	return game_can_step(_scope.pauseMask & PauseType.GAMEPLAY) && (_ignoreFrozen || frozenTimer <= 0) && !entity_is_dead(_scope);
}

/// @func entity_is_dead(scope)
/// @desc Checks if an entity is dead
///
/// @param {prtEntity}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the entity is alive (true) or not (false)
function entity_is_dead(_scope = self) {
	return _scope.lifeState != LifeState.ALIVE;
}

/// @func entity_is_solid_to_entity(collidee, collider)
/// @desc Checks if an entity can be seen as solid to another entity
///
/// @param {prtEntity}  collidee  The entity to check the solidity of.
/// @param {prtEntity}  [collider]  The instance to check against. Defaults to the calling instance.
///
/// @returns {bool}  If the entity is solid to the collider (true) or not (false)
function entity_is_solid_to_entity(_collidee, _collider = self) {
	if (_collidee == _collider || entity_is_dead(_collidee))
		return false;
	
	return (_collidee.factionSolidMask != 0xFFFFFFFF)
		? bitmask_has_bit(_collidee.factionSolidMask, _collider.factionLayer)
		: true;
}

#endregion