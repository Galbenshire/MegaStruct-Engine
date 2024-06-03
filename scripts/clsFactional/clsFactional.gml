/// @func Fractional(initial_value)
/// @desc Represents a floating-point number that can be used in places
///       where only integers (whole numbers) are accepted.
///
/// @param {number}  [initial_value]  Starting value. Defaults to 0.
function Fractional(_init_val = 0) constructor {
    value = _init_val; /// @is {number}
    
    fractional = 0;
    integer = 0;
    
    /// @method clear_fractional()
	/// @desc Clears the fractional & integer components of the number, without affecting the number's actual value
    static clear_fractional = function() {
        fractional = 0;
        integer = 0;
    };
    
    /// @method clear_all()
    /// @desc Clears every part of the number
    static clear_all = function() {
        value = 0;
        fractional = 0;
        integer = 0;
    };
    
    /// @method update()
	/// @desc Updates the fractional & integer components
    static update = function() {
        fractional += value;
        integer = floor(fractional);
        fractional -= integer;
    };
}
