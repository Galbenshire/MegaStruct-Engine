/// @func slope_is_steep(slope, scope)
/// @desc Given a slope, this function checks if it is too steep to be climbed.
///		  Entities will treat a steep slope like a wall if they try to move into it.
///		  If already standing on it, they will slide down it.
///
/// @param {objSlope}  slope  The slope to check the steepness of.
/// @param {prtEntity}  [scope]  The instance to check against. Defaults to the calling instance.
///
/// @return {bool}  Whether this slope is steep (true) or not (false)
function slope_is_steep(_slope, _scope = self) {
    return abs(_slope.steepness) > _scope.maxSlopeSteepness;
}

/// @func slope_x_at(slope, y, rounded)
/// @desc Given a slope and a y-position, this function will find the corresponding x-position on the slope.
///
/// @param {objSlope}  slope  The slope to check against.
/// @param {number}  y  vertical position
/// @param {number}  [rounded]  Determines if fractionals should be allowed (false) or be rounded (true). Defaults to true.
///
/// @return {number}  horizontal position. value will be clamped if it undershoots or overshoots the slope
function slope_x_at(_slope, _y, _rounded = true) {
    var _mask = mask_sprite(_slope),
		_width = sprite_get_width(_mask) * _slope.image_xscale,
		_height = sprite_get_height(_mask) * _slope.image_yscale;
	
	var _result = clamp(_slope.x + _width * invlerp(_slope.y + _height, _slope.y, _y), _slope.bbox_left, _slope.bbox_right);
	if (_rounded)
        _result = _slope.image_xscale >= 0 ? ceil(_result) : floor(_result);
	
	return _result;
}

/// @func slope_y_at(slope, x, rounded)
/// @desc Given a slope and a x-position, this function will find the corresponding y-position on the slope.
///
/// @param {objSlope}  slope  The slope to check against.
/// @param {number}  x  horizontal position
/// @param {number}  [rounded]  Determines if fractionals should be allowed (false) or be rounded (true). Defaults to true.
///
/// @return {number}  vertical position. value will be clamped if it undershoots or overshoots the slope
function slope_y_at(_slope, _x, _rounded = true) {
    var _mask = mask_sprite(_slope),
		_width = sprite_get_width(_mask) * _slope.image_xscale,
		_height = sprite_get_height(_mask) * _slope.image_yscale;
	
	var _result = clamp(_slope.y + _height * invlerp(_slope.x + _width, _slope.x, _x), _slope.bbox_top, _slope.bbox_bottom);
	if (_rounded)
        _result = _slope.image_yscale >= 0 ? ceil(_result) : floor(_result);
	
	return _result;
}
