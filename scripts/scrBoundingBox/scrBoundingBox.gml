#region Centers

/// @func bbox_x_center(scope)
/// @desc Gets the x-position of the center of a given instance's bounding box
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  x-center of the instance's bounding box
function bbox_x_center(_scope = self) {
    return _scope.bbox_left + bbox_width(_scope) * 0.5;
}

/// @func bbox_y_center(scope)
/// @desc Gets the y-position of the center of a given instance's bounding box
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  y-center of the instance's bounding box
function bbox_y_center(_scope = self) {
    return _scope.bbox_top + bbox_height(_scope) * 0.5;
}

#endregion

#region Edges

/// @func bbox_horizontal(direction, scope)
/// @desc Gets the x-position of the left/right edge of a give instance's bounding box
///       Whether it's the left side that's picked or the right depends on the 'direction' variable given
///
/// @param {number}  [direction]  If greater than 0, the right edge will be picked. Otherwise, the left edge is picked.
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  left/right edge of the instance's bounding box
function bbox_horizontal(_dir = 1, _scope = self) {
    return _dir >= 0 ? _scope.bbox_right : _scope.bbox_left;
}

/// @func bbox_vertical(direction, scope)
/// @desc Gets the x-position of the top/bottom edge of a give instance's bounding box
///       Whether it's the top side that's picked or the bottom depends on the 'direction' variable given
///
/// @param {number}  [direction]  If greater than 0, the bottom edge will be picked. Otherwise, the top edge is picked.
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  top/bottom edge of the instance's bounding box
function bbox_vertical(_dir = 1, _scope = self) {
    return _dir >= 0 ? _scope.bbox_bottom : _scope.bbox_top;
}

#endregion

#region Size

/// @func bbox_height(scope)
/// @desc Gets the height of a given instance's bounding box
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  height of the instance's bounding box
function bbox_height(_scope = self) {
    return _scope.bbox_bottom - _scope.bbox_top;
}

/// @func bbox_width(scope)
/// @desc Gets the width of a given instance's bounding box
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {number}  width of the instance's bounding box
function bbox_width(_scope = self) {
    return _scope.bbox_right - _scope.bbox_left;
}

#endregion
