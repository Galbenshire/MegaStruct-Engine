#region Basics

/// @func ease_back(a, b, amt, ease_type, overshoot)
/// @desc Interpolates the given value, overshooting near the ends
///
/// @param {number}  a  The first value
/// @param {number}  b  The second value
/// @param {number}  amt  The amount to interpolate
/// @param {int}  [ease_type]  The type of easing to use. Defaults to IN. (see the `EaseType` enum)
/// @param {number}  [overshoot]  The strength of the overshoot. Optional
///
/// @return {number}  The interpolated value
function ease_back(_val1, _val2, _amt, _ease = EaseType.IN, _over = 1.70158) {
    switch (_ease)  {
        case EaseType.IN:
            var _unit = (_over + 1) * power(_amt, 3) - _over * power(_amt, 2);
            return (_val2 - _val1) * _unit + _val1;
        case EaseType.OUT:
            var _unit = 1 + (_over + 1) * power(_amt - 1, 3) + _over * power(_amt - 1, 2);
            return (_val2 - _val1) * _unit + _val1;
        case EaseType.IN_OUT:
            var _half = (_val1 + (_val2 - _val1) * 0.5),
                _over2 = _over * 1.525;
            return (_amt < 0.5)
                ? ease_back(_val1, _half, _amt * 2, EaseType.IN, _over2)
                : ease_back(_half, _val2, (_amt - 0.5) * 2, EaseType.OUT, _over2);
        case EaseType.OUT_IN:
            return (_amt < 0.5)
                ? (ease_back(_val1, _val2, _amt * 2, EaseType.OUT, _over) + _val1) * 0.5
                : (ease_back(_val1, _val2, (_amt * 2) - 1, EaseType.IN, _over) + _val2) * 0.5;
    }
    return _val1;
}

/// @func ease_circ(a, b, amt, ease_type)
/// @desc Interpolates the given value by use of square roots
///
/// @param {number}  a  The first value
/// @param {number}  b  The second value
/// @param {number}  amt  The amount to interpolate
/// @param {int}  [ease_type]  The type of easing to use. Defaults to IN. (see the `EaseType` enum)
///
/// @return {number}  The interpolated value
function ease_circ(_val1, _val2, _amt, _ease = EaseType.IN) {
    switch (_ease)  {
        case EaseType.IN: return (_val2 - _val1) * (1 - sqrt(1 - power(_amt, 2))) + _val1;
        case EaseType.OUT: return (_val2 - _val1) * sqrt(1 - power(_amt - 1, 2)) + _val1;
        case EaseType.IN_OUT:
            return (_amt < 0.5)
                ? (_val2 - _val1) * ((1 - sqrt(1 - 4 * power(_amt, 2))) / 2) + _val1
                : (_val2 - _val1) * ((1 + sqrt(1 - power(2 - 2 * _amt, 2))) / 2) + _val1;
        case EaseType.OUT_IN:
            return (_amt < 0.5)
                ? (ease_circ(_val1, _val2, _amt * 2, EaseType.OUT) + _val1) * 0.5
                : (ease_circ(_val1, _val2, (_amt * 2) - 1, EaseType.IN) + _val2) * 0.5;
    }
    return _val1;
}

/// @func ease_cubic(a, b, amt, ease_type)
/// @desc Interpolates the given value with a cubic (to the power of 3) function
///
/// @param {number}  a  The first value
/// @param {number}  b  The second value
/// @param {number}  amt  The amount to interpolate
/// @param {int}  [ease_type]  The type of easing to use. Defaults to IN. (see the `EaseType` enum)
///
/// @return {number}  The interpolated value
function ease_cubic(_val1, _val2, _amt, _ease = EaseType.IN) {
    return ease_power(_val1, _val2, _amt, _ease, 3);
}

/// @func ease_sine(a, b, amt, ease_type)
/// @desc Interpolates the given value using a sine function
///
/// @param {number}  a  The first value
/// @param {number}  b  The second value
/// @param {number}  amt  The amount to interpolate
/// @param {int}  [ease_type]  The type of easing to use. Defaults to IN. (see the `EaseType` enum)
///
/// @return {number}  The interpolated value
function ease_sine(_val1, _val2, _amt, _ease = EaseType.IN) {
    switch (_ease)  {
        case EaseType.IN: return (_val2 - _val1) * (1 - cos((_amt * pi) / 2)) + _val1;
        case EaseType.OUT: return (_val2 - _val1) * (sin((_amt * pi) / 2)) + _val1;
        case EaseType.IN_OUT: return (_val2 - _val1) * 0.5 * (1 - cos(_amt * pi)) + _val1;
        case EaseType.OUT_IN:
            return (_amt < 0.5)
                ? (ease_sine(_val1, _val2, _amt * 2, EaseType.OUT) + _val1) * 0.5
                : (ease_sine(_val1, _val2, (_amt * 2) - 1, EaseType.IN) + _val2) * 0.5;
    }
    return _val1;
}

/// @func ease_quad(a, b, amt, ease_type)
/// @desc Interpolates the given value with a quadratic (to the power of 2) function
///
/// @param {number}  a  The first value
/// @param {number}  b  The second value
/// @param {number}  amt  The amount to interpolate
/// @param {int}  [ease_type]  The type of easing to use. Defaults to IN. (see the `EaseType` enum)
///
/// @return {number}  The interpolated value
function ease_quad(_val1, _val2, _amt, _ease = EaseType.IN) {
    return ease_power(_val1, _val2, _amt, _ease, 2);
}

/// @func ease_quart(a, b, amt, ease_type)
/// @desc Interpolates the given value with a quartic (to the power of 4) function
///
/// @param {number}  a  The first value
/// @param {number}  b  The second value
/// @param {number}  amt  The amount to interpolate
/// @param {int}  [ease_type]  The type of easing to use. Defaults to IN. (see the `EaseType` enum)
///
/// @return {number}  The interpolated value
function ease_quart(_val1, _val2, _amt, _ease = EaseType.IN) {
    return ease_power(_val1, _val2, _amt, _ease, 4);
}

/// @func ease_quint(a, b, amt, ease_type)
/// @desc Interpolates the given value with a quintic (to the power of 5) function
///
/// @param {number}  a  The first value
/// @param {number}  b  The second value
/// @param {number}  amt  The amount to interpolate
/// @param {int}  [ease_type]  The type of easing to use. Defaults to IN. (see the `EaseType` enum)
///
/// @return {number}  The interpolated value
function ease_quint(_val1, _val2, _amt, _ease = EaseType.IN) {
    return ease_power(_val1, _val2, _amt, _ease, 5);
}

#endregion

#region Advanced

/// @func default_lerp_power(lerp_type)
/// @desc Returns the default power value for the given lerp type
///
/// @param {int}  lerp_type  The type of lerp. see the `LerpType` enum
///
/// @return {number}  The power
function default_lerp_power(_lerpType) {
    if (_lerpType == LerpType.BACK) // Not really a "power" lerp, but still configurable
        return 1.70158;
    if (_lerpType < LerpType.POWER)
        return (_lerpType + 1);
    return 1;
}

/// @func ease_ext(a, b, amt, lerp_type, ease_type, extra_data)
/// @desc Interpolates the given value to the specified power value, using the given lerp & ease types
///
/// @param {number}  a  The first value
/// @param {number}  b  The second value
/// @param {number}  amt  The amount to interpolate
/// @param {int}  [lerp_type]  The type of lerping to use. Defaults to LINEAR. (see the `LerpType` enum)
/// @param {int}  [ease_type]  The type of easing to use. Defaults to IN. (see the `EaseType` enum)
/// @param {number}  [extra_data]  Determines the power for POWER, or the overshoot for BACK. Optional
function ease_ext(_val1, _val2, _amt, _lerp = LerpType.LINEAR, _ease = EaseType.IN, _extra = undefined) {
    _extra ??= default_lerp_power(_lerp);
    
    switch (_lerp) {
        case LerpType.LINEAR: return lerp(_val1, _val2, _amt);
        case LerpType.QUAD: return ease_quad(_val1, _val2, _amt, _ease);
        case LerpType.CUBIC: return ease_cubic(_val1, _val2, _amt, _ease);
        case LerpType.QUART: return ease_quart(_val1, _val2, _amt, _ease);
        case LerpType.QUINT: return ease_quint(_val1, _val2, _amt, _ease);
        case LerpType.POWER: return ease_power(_val1, _val2, _amt, _ease, _extra);
        case LerpType.CIRC: return ease_circ(_val1, _val2, _amt, _ease);
        case LerpType.SINE: return ease_sine(_val1, _val2, _amt, _ease);
        case LerpType.BACK: return ease_back(_val1, _val2, _amt, _ease, _extra);
    }
    
    return _val1;
}

/// @func ease_power(a, b, amt, ease_type, power)
/// @desc Interpolates the given value to the specified power value
///
/// @param {number}  a  The first value
/// @param {number}  b  The second value
/// @param {number}  amt  The amount to interpolate
/// @param {int}  [ease_type]  The type of easing to use. Defaults to IN. (see the `EaseType` enum)
/// @param {number}  [power]  The power value to raise this to. Defaults to 2 (Quad)
///
/// @return {number}  The interpolated value
function ease_power(_val1, _val2, _amt, _ease = EaseType.IN, _pow = 2) {
    switch (_ease)  {
        case EaseType.IN: return (_val2 - _val1) * power(_amt, _pow) + _val1;
        case EaseType.OUT: return (_val2 - _val1) * (1 - power(1 - _amt, _pow)) + _val1;
        case EaseType.IN_OUT:
            return (_amt < 0.5)
                ? (_val2 - _val1) * (power(2, _pow - 1) * power(_amt, _pow)) + _val1
                : (_val2 - _val1) * (1 - (power(-2 * _amt + 2, _pow) / 2)) + _val1;
        case EaseType.OUT_IN:
            return (_amt < 0.5)
                ? (_val2 - _val1) * ((1 - power(1 - 2 * _amt, _pow)) / 2) + _val1
                : (_val2 - _val1) * (0.5 + (power(2 * _amt - 1, _pow) / 2)) + _val1;
    }
    return _val1;
}

#endregion
