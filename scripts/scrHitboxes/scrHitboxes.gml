/// @func hitbox_create_simple(x_offset, y_offset, x_scale, y_scale, active, deals_damage, takes_damage, owner)
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