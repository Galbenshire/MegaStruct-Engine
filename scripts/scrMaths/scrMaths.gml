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