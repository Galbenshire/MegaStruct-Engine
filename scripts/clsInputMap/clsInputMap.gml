/// @func InputMap()
/// @desc A struct that holds the various states of all possible player actions.
function InputMap() constructor {
    held = 0;
    pressed = 0;
    released = 0;
    
    /// @method clear_all()
	/// @desc Sets all input states to a blank state
	static clear_all = function() {
		held = 0;
        pressed = 0;
        released = 0;
	};
    
    /// @method get_axis(positive_action, negative_action)
	/// @desc Get axis input by specifying two input actions, one negative and one positive.
	///       This checks if either inputs are being held.
	///
	/// @param {int}  positive_action  The input action to act as the positive axis
	/// @param {int}  negative_action  The input action to act as the negative axis
	///
	/// @returns {number}  Direction of the axis
	static get_axis = function(_positive, _negative) {
		return is_held(_positive) - is_held(_negative);
	};
	
	/// @method is_any_held(...inputs)
	/// @desc Checks if any of the given inputs have been held
	///
	/// @param {rest<int>}  [...inputs]  The input actions to check
	///
	/// @returns {bool}  If any input has been held (true) or not (false)
	static is_any_held = function() {
		for (var i = 0; i < argument_count; i++) {
			if ((held & (1 << argument[i])) > 0)
				return true;
		}
		
		return false;
	};
	
	/// @method is_any_held_ext(input_array)
	/// @desc Checks if any of the given inputs have been held
	///
	/// @param {array<int>}  input_array  An array of input actions to check
	///
	/// @returns {bool}  If any input has been held (true) or not (false)
	static is_any_held_ext = function(_inputs) {
		var _count = array_length(_inputs);
		for (var i = 0; i < _count; i++) {
			if ((held & (1 << _inputs[i])) > 0)
				return true;
		}
		
		return false;
	};
	
	/// @method is_any_pressed(...inputs)
	/// @desc Checks if any of the given inputs have been pressed
	///
	/// @param {rest<int>}  [...inputs]  The input actions to check
	///
	/// @returns {bool}  If any input has been pressed (true) or not (false)
	static is_any_pressed = function() {
		for (var i = 0; i < argument_count; i++) {
			if ((pressed & (1 << argument[i])) > 0)
				return true;
		}
		
		return false;
	};
	
	/// @method is_any_pressed_ext(input_array)
	/// @desc Checks if any of the given inputs have been pressed
	///
	/// @param {array<int>}  input_array  An array of input actions to check
	///
	/// @returns {bool}  If any input has been pressed (true) or not (false)
	static is_any_pressed_ext = function(_inputs) {
		var _count = array_length(_inputs);
		for (var i = 0; i < _count; i++) {
			if ((pressed & (1 << _inputs[i])) > 0)
				return true;
		}
		
		return false;
	};
    
    /// @method is_held(input)
	/// @desc Checks if the given input is held
	///
	/// @param {int}  input  The input action to check
	///
	/// @returns {bool}  If it has been held (true) or not (false)
	static is_held = function(_input) {
	    return bool(held & (1 << _input));
	};
	
	/// @method is_pressed(input)
	/// @desc Checks if the given input is pressed
	///
	/// @param {int}  input  The input action to check
	///
	/// @returns {bool}  If it has been pressed (true) or not (false)
	static is_pressed = function(_input) {
		return bool(pressed & (1 << _input));
	};
	
	/// @method is_released(input)
	/// @desc Checks if the given input is released
	///
	/// @param {int}  input  The input action to check
	///
	/// @returns {bool}  If it has been released (true) or not (false)
	static is_released = function(_input) {
		return bool(released & (1 << _input));
	};
}