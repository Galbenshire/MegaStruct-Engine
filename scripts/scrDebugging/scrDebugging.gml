/// @func assert(condition, message, ...values)
/// @desc Crashes the game if the given condition evaluates to false.
///		  Can optionally provide an error message too.
///
/// @param {bool}  condition  Will crash the game if this is false
/// @param {string}  [message]  Message to display, should the assertion fail
/// @param {any}  [...values]  The values to be inserted at the placeholder positions in the message
function assert(_condition/*:bool*/, _msg/*:string*/ = "") {
	var _values = array_create(max(argument_count - 2, 0));
	for (var i = 2; i < argument_count; i++)
		_values[i - 2] = argument[i];
	
	assert_ext(_condition, _msg, _values);
}

/// @func assert_ext(condition, message, values)
/// @desc Crashes the game if the given condition evaluates to false.
///		  Can optionally provide an error message too.
///
/// @param {bool}  condition  Will crash the game if this is false
/// @param {string}  [message]  Message to display, should the assertion fail
/// @param {array<any>}  [values]  The values to be inserted at the placeholder positions in the message
function assert_ext(_condition/*:bool*/, _msg/*:string*/ = "", _values/*:array<any>*/ = []) {
	if (_condition)
		return;
	
	_msg = (_msg != "") ? _msg : "FATAL ASSERTION FAILURE";
	_msg = string_ext(_msg, _values);
	
	show_error(_msg, true);
}

/// @func print(message, warning_level, colour, no_console)
/// @desc This function not only displays the given message in the Output Window,
///		  but will also display the message on-screen for the user to see
function print(_msg, _warningLevel = 0, _colour = c_white, _noConsole = false) {
	if (!_noConsole)
		show_debug_message(_msg);
	
	with (objSystem.debug) {
		var _line/*:ConsoleLine*/ = array_create(ConsoleLine.sizeof);
		_line[@ConsoleLine.text] = _msg;
		_line[@ConsoleLine.colour] = _colour;
		_line[@ConsoleLine.lifetime] = 180;
		_line[@ConsoleLine.alpha] = 1;
		
		array_push(consoleLog, _line);
		consoleLogCount++;
		
		if (consoleLogCount >= CONSOLE_MAX_LINES) {
			array_shift(consoleLog);
			consoleLogCount--;
		}
	}
}
