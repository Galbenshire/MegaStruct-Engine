/// @func InputReader()
/// @desc A struct designed to read input from the player.
///		  Each input action will be check by its corresponding key; the results are then stored.
///		  It also holds reference to the player's gamepad, for gamepad input.
///
///       On each game frame, this struct should be updated to get new input from the player.
///       By default, this is performed by objSystem.
function InputReader() constructor {
	static AXIS_DEADZONE = 0.4;
	
    controller = NO_CONTROLLER; /// @is {number} Controller index to use for this Input Reader (-1 means no controller)
    results = 0; // A bitmask number; each bit represents an input action
    
    /// @method has_controller()
	/// @desc Checks if the reader has an assigned controller
	///
	/// @returns {bool}  Whether the reader has a controller (true) or not (false)
    static has_controller = function() {
		return controller != NO_CONTROLLER;	
    };
    
    /// @method update()
	/// @desc Updates the reader's results by reading each input action
    static update = function() {
        results = 0;
        for (var i = 0; i < InputActions.COUNT; i++)
            results |= (read_input(i) << i);
    };
    
    /// @method read_input(index)
	/// @desc Checks for input from the player for the given input action
	///
	/// @param {int}  index  The input action to check for (see the InputActions enum)
	///
	/// @returns {bool}  Whether the input action has input (true) or not (false)
    static read_input = function(_index) {
        var _options_data = options_data(),
            _key = _options_data.keys[_index],
            _button = _options_data.buttons[_index],
            _input = keyboard_check(_key) && !is_keyboard_used_debug_overlay();
        
		if (controller != NO_CONTROLLER) {
            _input |= gamepad_button_check(controller, _button);
            
            switch (_index) {
                case InputActions.LEFT: _input |= (gamepad_axis_value(controller, gp_axislh) < -AXIS_DEADZONE); break;
                case InputActions.RIGHT: _input |= (gamepad_axis_value(controller, gp_axislh) > AXIS_DEADZONE); break;
                case InputActions.UP: _input |= (gamepad_axis_value(controller, gp_axislv) < -AXIS_DEADZONE); break;
                case InputActions.DOWN: _input |= (gamepad_axis_value(controller, gp_axislv) > AXIS_DEADZONE); break;
            }
		}
		
		return _input;
    };
}