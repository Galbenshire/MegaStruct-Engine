#region Bbox Size

/// @func sprite_get_bbox_height(ind)
/// @desc This function returns the height of a sprite's bounding box.
///
/// @param {sprite}  ind  The index of the sprite to check.
///
/// @returns {bool}  The height of the sprite's bounding box
function sprite_get_bbox_height(_sprite) {
	return sprite_get_bbox_bottom(_sprite) - sprite_get_bbox_top(_sprite);
}

/// @func sprite_get_bbox_width(ind)
/// @desc This function returns the width of a sprite's bounding box.
///
/// @param {sprite}  ind  The index of the sprite to check.
///
/// @returns {bool}  The width of the sprite's bounding box
function sprite_get_bbox_width(_sprite) {
	return sprite_get_bbox_right(_sprite) - sprite_get_bbox_left(_sprite);
}

#endregion

#region Centers

/// @func sprite_x_center(scope)
/// @desc Gets the x-position of the center of a given instance's sprite
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  x-center of the instance's sprite
function sprite_x_center(_scope = self) {
    return _scope.x - _scope.sprite_xoffset + (_scope.sprite_width * 0.5);
}

/// @func sprite_y_center(scope)
/// @desc Gets the y-position of the center of a given instance's sprite
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  y-center of the instance's sprite
function sprite_y_center(_scope = self) {
    return _scope.y - _scope.sprite_yoffset + (_scope.sprite_height * 0.5);
}

#endregion

#region Edges

/// @func sprite_bottom(scope)
/// @desc Gets the bottom edge of the given instance's sprite
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  bottom edge of the instance's sprite
function sprite_bottom(_scope = self) {
    return _scope.y - _scope.sprite_yoffset + _scope.sprite_height * (_scope.image_yscale >= 0);
}

/// @func sprite_left(scope)
/// @desc Gets the left edge of the given instance's sprite
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  left edge of the instance's sprite
function sprite_left(_scope = self) {
    return _scope.x - _scope.sprite_xoffset + _scope.sprite_width * (_scope.image_xscale < 0);
}

/// @func sprite_right(scope)
/// @desc Gets the right edge of the given instance's sprite
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  right edge of the instance's sprite
function sprite_right(_scope = self) {
    return _scope.x - _scope.sprite_xoffset + _scope.sprite_width * (_scope.image_xscale >= 0);
}

/// @func sprite_top(scope)
/// @desc Gets the top edge of the given instance's sprite
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  top edge of the instance's sprite
function sprite_top(_scope = self) {
    return _scope.y - _scope.sprite_yoffset + _scope.sprite_height * (_scope.image_yscale < 0);
}

#endregion
