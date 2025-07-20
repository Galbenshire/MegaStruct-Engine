/// @func InputMap()
/// @desc A struct that holds the various states of all possible player actions.
function InputMap() constructor {
    #region Variables
	
    held = 0;
    pressed = 0;
    released = 0;
	
	#endregion
	
	#region Functions - Boolean (Basic)
	
	/// @method is_held(input)
	/// @desc Checks if the given input is held
	///
	/// @param {int}  input  The input action to check
	///
	/// @returns {bool}  If it has been held (true) or not (false)
	static is_held = function(_input) {
		return bitmask_has_bit(held, 1 << _input);
	};
	
	/// @method is_pressed(input)
	/// @desc Checks if the given input is pressed
	///
	/// @param {int}  input  The input action to check
	///
	/// @returns {bool}  If it has been pressed (true) or not (false)
	static is_pressed = function(_input) {
		return bitmask_has_bit(pressed, 1 << _input);
	};
	
	/// @method is_released(input)
	/// @desc Checks if the given input is released
	///
	/// @param {int}  input  The input action to check
	///
	/// @returns {bool}  If it has been released (true) or not (false)
	static is_released = function(_input) {
		return bitmask_has_bit(released, 1 << _input);
	};
	
	#endregion
	
	#region Functions - Boolean (Advanced)
	
	/// @method is_any_held(...inputs)
	/// @desc Checks if any of the given inputs have been held
	///
	/// @param {rest<int>}  [...inputs]  The input actions to check
	///
	/// @returns {bool}  If any input has been held (true) or not (false)
	static is_any_held = function() {
		for (var i = 0; i < argument_count; i++) {
			if (bitmask_has_bit(held, 1 << argument[i]))
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
		for (var i = 0, n = array_length(_inputs); i < n; i++) {
			if (bitmask_has_bit(held, 1 << _inputs[i]))
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
			if (bitmask_has_bit(pressed, 1 << argument[i]))
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
		for (var i = 0, n = array_length(_inputs); i < n; i++) {
			if (bitmask_has_bit(pressed, 1 << _inputs[i]))
				return true;
		}
		
		return false;
	};
	
	#endregion
    
    #region Functions - Clearing
	
	/// @method clear_all()
	/// @desc Sets all input states to a blank state
	static clear_all = function() {
		held = 0;
        pressed = 0;
        released = 0;
	};
	
	/// @method clear_momentary()
	/// @desc Sets both pressing & releasing to a blank state
	static clear_momentary = function() {
        pressed = 0;
        released = 0;
	};
	
	#endregion
	
	#region Functions - Other
	
	/// @method apply(action, held, pressed, released)
	/// @desc Applies input to multiple states at once
	///
	/// @param {int}  action  The input action to apply input to
	/// @param {bool}  [held]  Whether "held" input should be applied. Defaults to false.
	/// @param {bool}  [pressed]  Whether "pressed" input should be applied. Defaults to false.
	/// @param {bool}  [released]  Whether "released" input should be applied. Defaults to false.
	static apply = function(_action, _held = false, _pressed = false, _released = false) {
		var _bit = 1 << _action;
		held = bitmask_set_bit(held, _bit * _held);
        pressed = bitmask_set_bit(pressed, _bit * _pressed);
        released = bitmask_set_bit(released, _bit * _released);
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
	
	#endregion
}