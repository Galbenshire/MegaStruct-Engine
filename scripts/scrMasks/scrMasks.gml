// "Mask" in this context referring to an instance's mask_index.
// That is, the sprite used for their bounding box.

#region Centers

/// @func mask_x_center(scope)
/// @desc Gets the x-position of the center of a given instance's mask
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  x-center of the instance's mask
function mask_x_center(_scope = self) {
    var _mask = mask_sprite(_scope),
        _xoffset = sprite_get_xoffset(_mask) * _scope.image_xscale,
        _width = sprite_get_width(_mask) * _scope.image_xscale;
    return _scope.x - _xoffset + (_width * 0.5);
}

/// @func mask_y_center(scope)
/// @desc Gets the y-position of the center of a given instance's mask
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  y-center of the instance's mask
function mask_y_center(_scope = self) {
    var _mask = mask_sprite(_scope),
        _yoffset = sprite_get_yoffset(_mask) * _scope.image_yscale,
        _height = sprite_get_height(_mask) * _scope.image_yscale;
    return _scope.y - _yoffset + (_height * 0.5);
}

#endregion

#region Edges

/// @func mask_bottom(scope)
/// @desc Gets the bottom edge of a given instance's mask
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  bottom edge of the instance's mask
function mask_bottom(_scope = self) {
    var _mask = mask_sprite(_scope),
        _yoffset = sprite_get_yoffset(_mask) * _scope.image_yscale,
        _height = sprite_get_height(_mask) * _scope.image_yscale;
    return _scope.y - _yoffset + _height * (_scope.image_yscale >= 0);
}

/// @func mask_left(scope)
/// @desc Gets the left edge of the given instance's mask
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  left edge of the instance's mask
function mask_left(_scope = self) {
    var _mask = mask_sprite(_scope),
        _xoffset = sprite_get_xoffset(_mask) * _scope.image_xscale,
        _width = sprite_get_width(_mask) * _scope.image_xscale;
    return _scope.x - _xoffset + _width * (_scope.image_xscale < 0);
}

/// @func mask_right(scope)
/// @desc Gets the right edge of the given instance's mask
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  right edge of the instance's mask
function mask_right(_scope = self) {
    var _mask = mask_sprite(_scope),
        _xoffset = sprite_get_xoffset(_mask) * _scope.image_xscale,
        _width = sprite_get_width(_mask) * _scope.image_xscale;
    return _scope.x - _xoffset + _width * (_scope.image_xscale >= 0);
}

/// @func mask_top(scope)
/// @desc Gets the top edge a given instance's mask
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  top edge of the instance's mask
function mask_top(_scope = self) {
    var _mask = mask_sprite(_scope),
        _yoffset = sprite_get_yoffset(_mask) * _scope.image_yscale,
        _height = sprite_get_height(_mask) * _scope.image_yscale;
    return _scope.y - _yoffset + _height * (_scope.image_yscale < 0);
}

#endregion

#region Other

/// @func mask_sprite(scope)
/// @desc Gets the sprite used for the given instance's mask
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {sprite}  sprite of the instance's mask
function mask_sprite(_scope = self) {
    return _scope.mask_index != -1 ? _scope.mask_index : _scope.sprite_index;
}

#endregion
