/// @func hitbox_can_deal_damage(scope)
/// @desc Checks if a hitbox is currently able to deal damage to other entities
///
/// @param {prtHitbox}  [scope]  The hitbox instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the hitbox can deal damage (true) or not (false)
function hitbox_can_deal_damage(_scope = self) {
    return hitbox_has_hitmask_flag(HitMask.DEAL_DAMAGE, _scope) && !entity_is_dead(_scope.owner) && _scope.owner.contactDamage != 0;
}

/// @func hitbox_can_take_damage(ignore_i_frames, scope)
/// @desc Checks if a hitbox is currently able to receive damage from other entities
///
/// @param {bool}  [ignore_i_frames]  Whether we should ignore iframes. Defaults to false
/// @param {prtHitbox}  [scope]  The hitbox instance to check. Defaults to the calling instance.
///
/// @returns {bool}  If the hitbox can take damage (true) or not (false)
function hitbox_can_take_damage(_ignoreIFrames = false, _scope = self) {
    return hitbox_has_hitmask_flag(HitMask.TAKE_DAMAGE, _scope) && !entity_is_dead(_scope.owner) && (_ignoreIFrames || _scope.owner.iFrames == 0);
}

/// @func hitbox_create_simple(x_offset, y_offset, width, height, hitmask, owner)
/// @desc Helper function for creating a simple rectangular hitbox
///
/// @param {number}  x_offset  horizontal offset of the hitbox, relative to the owner's xscale
/// @param {number}  y_offset  vertical offset of the hitbox, relative to the owner's yscale
/// @param {number}  width  width of the hitbox, relative to the owner's yscale
/// @param {number}  height  height of the hitbox, relative to the owner's yscale
/// @param {int}  [hitmask]  defines if the hitbox can take/deal damage and/or block. Defaults to dealing damage.
/// @param {prtEntity}  [scope]  The entity this hitbox will be tied to. Defaults to the calling instance.
///
/// @returns {objSimpleHitbox}  The newly created hitbox
function hitbox_create_simple(_xOffset, _yOffset, _width, _height, _hitmask = HitMask.TAKE_DAMAGE, _owner = self) {
	var _hitbox = instance_create_depth(_owner.x, _owner.y, _owner.depth - 1, objSimpleHitbox, {
        owner: _owner,
        offsetX: _xOffset,
        offsetY: _yOffset,
        scaleX: _width,
        scaleY: _height
    });
    _hitbox.hitmask = _hitmask;
    return _hitbox;
}

/// @func hitbox_has_hitmask_flag(flag, scope)
/// @desc Checks if a hitbox has the specified flag set in its hitmask
///       Their owner's master hitmask will also be checked
///
/// @param {int}  flag  The hitmask flag to check for
/// @param {prtHitbox}  [scope]  The hitbox instance to check. Defaults to the calling instance.
///
/// @returns {bool}  Whether the specified flag is set (true) or not (false)
function hitbox_has_hitmask_flag(_flag, _scope = self) {
	return bitmask_has_bit(_scope.hitmask, _flag) && bitmask_has_bit(_scope.owner.hitmaskMaster, _flag);
}
