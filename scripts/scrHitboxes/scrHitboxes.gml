/// @func hitbox_can_deal_damage(scope)
/// @desc Checks if a hitbox is currently able to deal damage to other entities
///
/// @param {prtHitbox}  [scope]  The hitbox instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the hitbox can deal damage (true) or not (false)
function hitbox_can_deal_damage(_scope = self) {
    return _scope.active && _scope.canDealDamage && _scope.owner.contactDamage != 0;
}

/// @func hitbox_can_take_damage(scope)
/// @desc Checks if a hitbox is currently able to receive damage from other entities
///
/// @param {prtHitbox}  [scope]  The hitbox instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the hitbox can take damage (true) or not (false)
function hitbox_can_take_damage(_scope = self) {
    return _scope.active && _scope.canTakeDamage && _scope.owner.iFrames == 0;
}

/// @func hitbox_can_attack_target(target, attacker)
/// @desc Checks if a hitbox would be able to attack (i.e. collide with & damage) another entity, or its hitbox
///
/// @param {prtEntity|prtHitbox}  target  The entity (or its hitbox) to check.
/// @param {prtHitbox}  [attacker]  The hitbox that's attacking the target. Defaults to the calling instance.
///
/// @returns {bool}  If the entity can damage this target (true) or not (false)
function hitbox_can_attack_target(_target, _attacker = self) {
	var _targetIsHitbox = is_object_type(prtHitbox, _target),
		_targetEntity = _targetIsHitbox ? _target.owner : _target,
		_canTakeDamage = _targetIsHitbox ? hitbox_can_take_damage(_target) : entity_can_take_damage(false, _target);
	
	var _selfDamage = (_targetEntity == _attacker);
	if (_targetIsHitbox)
        _selfDamage &= (_target.owner == _attacker.owner);
	
	return _canTakeDamage && _targetEntity.hitTimer >= _attacker.owner.attackDelay
	    && !_selfDamage && (_attacker.owner.factionMask & _targetEntity.factionLayer) > 0;
}

/// @func hitbox_create_simple(x_offset, y_offset, x_scale, y_scale, active, deals_damage, takes_damage, owner)
/// @desc Helper function for creating a simple rectangular hitbox
function hitbox_create_simple(_xOffset, _yOffset, _width, _height, _active = true, _dealsDamage = false, _takesDamage = true, _owner = self) {
    return instance_create_depth(_owner.x, _owner.y, _owner.depth - 1, objSimpleHitbox, {
        owner: _owner,
        active: _active,
        canDealDamage: _dealsDamage,
        canTakeDamage: _takesDamage,
        offsetX: _xOffset,
        offsetY: _yOffset,
        scaleX: _width,
        scaleY: _height
    });
}
