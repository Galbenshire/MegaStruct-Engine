#region Lerping

/// @func invlerp(a, b, amt)
/// @desc The inverse of lerp, this function gets the fraction that corresponds to the value compared to two other values
///		  Supports extrapolation.
///
/// @param {number}  a  The first value.
/// @param {number}  b  The second value.
/// @param {number}  amt  The amount to get the interpolation of.
///
/// @returns {number}  The fraction that will interpolate into the given amount.
function invlerp(_a, _b, _amt) {
	return (_amt - _a) / (_b - _a);
}

/// @func remap(oldA, oldB, newA, newB, value)
/// @desc This function will convert a given value from one range into another
///
/// @param {number}  oldA  The first value of the old range.
/// @param {number}  oldB  The second value of the old range.
/// @param {number}  newA  The first value of the new range.
/// @param {number}  newB  The second value of the new range.
/// @param {number}  value  The number to convert between the two ranges.
///
/// @returns {number}  A number that has the same interpolation in the new range as the given value does in the old range.
function remap(_aOld, _bOld, _aNew, _bNew, _value) {
	var _old_lerp = invlerp(_aOld, _bOld, _value);
	return lerp(_aNew, _bNew, _old_lerp);
}

#endregion

#region Rounding

/// @func ceil_to(x, step)
/// @desc Rounds the given number to the nearest multiple of the given step no lesser than the number
///
/// @param {number}  x  The number to floor
/// @param {number}  step  The multiple of which to snap `x` to
///
/// @returns {number}  The snapped number
function ceil_to(_x, _step) {
	return (_step == 0) ? _x : (ceil(_x / _step) * _step);
}

/// @func floor_to(x, step)
/// @desc Rounds the given number to the nearest multiple of the given step no greater than the number
///
/// @param {number}  x  The number to floor
/// @param {number}  step  The multiple of which to snap `x` to
///
/// @returns {number}  The snapped number
function floor_to(_x, _step) {
	return (_step == 0) ? _x : (floor(_x / _step) * _step);
}

/// @func round_alt(x)
/// @desc Rounds the given number to the closest integer value. Half-integers are rounded up.
///		  This is different from GMS's built-in round() function, which uses Bankers Rounding.
///
/// @param {number}  x  The number to round
///
/// @returns {number}  The rounded number
function round_alt(_x) {
	var _half = _x < 0 ? -0.5 : 0.5;
	return (_x + _half) >> 0;
}

/// @func round_away_from_zero(x, step)
/// @desc Rounds the given number away from zero
///
/// @param {number}  x  The number to round
///
/// @returns {number}  The rounded number
function round_away_from_zero(_x) {
	return (_x >= 0) ? ceil(_x) : floor(_x);
}

/// @func round_to(x, step)
/// @desc Rounds the given number to the nearest multiple of the given step
///
/// @param {number}  x  The number to round
/// @param {number}  step  The multiple of which to snap `x` to
///
/// @returns {number}  The snapped number
function round_to(_x, _step) {
	return (_step == 0) ? _x : (round(_x / _step) * _step);
}

/// @func round_towards_zero(x, step)
/// @desc Rounds the given number towards zero
///
/// @param {number}  x  The number to round
///
/// @returns {number}  The rounded number
function round_towards_zero(_x) {
	return (_x >= 0) ? floor(_x) : ceil(_x);
}

/// @func sign_nonzero(x, prefer_positive)
/// @desc A version of `sign` that will not return 0
///
/// @param {number}  x  The number to get the sign of
/// @param {bool}  [prefer_positive]  Determines if, should `x` be 0, we favour `1` (true) or `-1` (false). Defaults to true.
///
/// @returns {number}  The sign of the number
function sign_nonzero(_x, _preferPositive = true) {
	return (_x == 0) ? ((2 * _preferPositive) - 1) : sign(_x);
}

#endregion

#region Other

/// @func approach(start, end, amount)
/// @desc Increases a starting value by the given amount, without overshooting the end value
///
/// @param {number}  start  The number we're starting at
/// @param {number}  end  The number we wish to approach
/// @param {number}  amount  How much to approach by
///
/// @returns {number}  The value of `start` after approaching
function approach(_start, _end, _amount) {
	return (_start < _end)
		? min(_start + _amount, _end) 
		: max(_start - _amount, _end);
}

/// @func calculate_arc_speed(start_x, start_y, end_x, end_y, yspeed, grav, limit)
/// @desc Given a jump speed, this function calculates the speed needed to get from one position to another
///
/// @param {number}  start_x  x-coordinate of the starting position
/// @param {number}  start_y  y-coordinate of the starting position
/// @param {number}  end_x  x-coordinate of the target position
/// @param {number}  end_y  y-coordinate of the target position
/// @param {number}  yspeed  vertical speed during the arc
/// @param {number}  grav  The gravity in effect during the arc
/// @param {number}  [limit]  Maximum possible speed. Defaults to 8.
///
/// @returns {number}  The speed required to achieve the jump height
function calculate_arc_speed(_startX, _startY, _endX, _endY, _yspeed, _grav, _limit = 8) {
	if (_yspeed == 0 || _grav == 0)
		return 0;
	
	var _airTime = max(0, -_yspeed / _grav),
		_maxYDelta = _yspeed * _airTime + 0.5 * _grav * power(_airTime, 2),
		_yDelta = _endY - _startY;
	
	if (sign(_maxYDelta) != sign(_maxYDelta - _yDelta))
		_yDelta = _maxYDelta - sign(_maxYDelta);
	
	var _radical = power(_yspeed, 2) - 4 * (_grav / 2) * (-_yDelta);
    if (_radical <= 0) {
        // if nonsense somehow, than quit
        show_debug_message("nonsense radical in {0}", _GMFUNCTION_);
        return 0;
    }
    
    // figure out time it'll take for the projetile's y to reach the same as the target
    _airTime = (-_yspeed + sqrt(_radical)) / _grav;
    
    // if the answer given is nonsense, then try subtracting the quadratic instead of adding
    if (_airTime <= 0) {
        _airTime = (-_yspeed - sqrt(_radical)) / _grav;
        
        // if still nonsense somehow, then quit
        if (_airTime <= 0) {
            show_debug_message("nonsense airtime in {0}", _GMFUNCTION_);
            return 0;
        }
    }
    
    var _xDelta = _endX - _startX,
		_newXSpeed = _xDelta / _airTime;
    
    if (_limit > 0) {
		_limit = abs(_limit);
		_newXSpeed = clamp(_newXSpeed, -_limit, _limit);
    }
	
	return _newXSpeed;
}

/// @func calculate_jump_speed(height, grav, limit)
/// @desc Calculates the speed needed to achieve a jump of a given height, taking graity into account
///
/// @param {number}  height  The height of the jump
/// @param {number}  grav  The gravity in effect during the jump
/// @param {number}  [limit]  Maximum possible speed. Defaults to 10.
///
/// @returns {number}  The speed required to achieve the jump height
function calculate_jump_speed(_height, _grav, _limit = 10) {
	_height = abs(_height);
	_grav = abs(_grav);
	_limit = abs(_limit);
	
	if (_grav > 0) {
		show_debug_message("no gravity supplied to calculate_jump_speed");
		return 0;
	}
	
	var _yspeed = -sqrt(abs(2 * _grav * _height));
	_yspeed = min(_yspeed, _limit);
	return _yspeed;
}

/// @func distance_to_point_target(x, y, target)
/// @desc Version of distance_to_point that can be called on a specific instance
///
/// @param {number}  x  The x position to check.
/// @param {number}  y  The y position to check.
/// @param {instance}  [target]  The instance to call this function on. Defaults to the calling instance.
///
/// @returns {number}  The distance from the edge of the bounding box of the target to the specified position
function distance_to_point_target(_x, _y, _target = self) {
	with (_target)
		return distance_to_point(_x, _y);
}

/// @func in_range(x, min, max, inclusive_min, inclusive_max)
/// @desc Checks if a number is within a specified range
///
/// @param {number}  x  The number to check
/// @param {number}  min  The minimum value `x` can be
/// @param {number}  max  The maximum value `x` can be
/// @param {bool}  [inclusive_min]  If true, `x` can be equal to `min`, otherwise it must be greater. Defaults to true.
/// @param {bool}  [inclusive_max]  If true, `x` can be equal to `max`, otherwise it must be less than. Defaults to false.
///
/// @returns {number}  The fraction that will interpolate into the given amount.
function in_range(_x, _min, _max, _inclusiveMin = true, _inclusiveMax = false) {
	if (_max < _min)
		return in_range(_x, _max, _min, _inclusiveMin, _inclusiveMax);
    var _isAboveMin = _inclusiveMin ? _x >= _min : _x > _min,
		_isBelowMax = _inclusiveMax ? _x <= _max : _x < _max;
    return _isAboveMin && _isBelowMax;
}

/// @func modf(x, divisor)
/// @desc Computes floating-point modulo
///
/// @param {number}  x  The number to get the modulo.
/// @param {number}  [divisor]  The number to apply the modulo against. Defaults to 1.
///
/// @returns {number}  The result of the modulo operation. Guaranteed to be non-negative.
function modf(_x, _divisor = 1) {
	if (_divisor == 0)
		return 0;
	_divisor = abs(_divisor);
	return _x - floor(_x / _divisor) * _divisor;
}

/// @func wrap_angle(x)
/// @desc Takes an angle & keeps it within a [0, 360) range. If it undershoots or overshoots, the angle will wraparound.
///
/// @param {number}  angle  The angle to wrap
///
/// @returns {number}  The angle wrapped to within the range
function wrap_angle(_angle) {
	while (_angle >= 360)
        _angle -= 360;
	while (_angle < 0)
        _angle += 360;
	return _angle;
}

#endregion