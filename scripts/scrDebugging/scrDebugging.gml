/// @func assert(condition, message)
/// @desc Crashes the game if the given condition evaluates to false.
///		  Can optionally provide an error message too.
///
/// @param {bool}  condition  Will crash the game if this is false
/// @param {string}  [message]  Message to display, should the assertion fail
function assert(_condition/*:bool*/, _msg/*:string*/ = "FATAL ASSERTION FAILURE") {
	if (_condition)
		return;
	show_error(_msg, true);
}

/// @func draw_debug_boxed_text(string)
/// @desc Draws a translucent box in the left corner of the screen, with text inside
///		  Intended for debug purposes
///
/// @param {string}  string
function draw_debug_boxed_text(_str) {
	var _boxWidth = (string_width(_str) * 0.5) + 8,
		_boxHeight = (string_height(_str) * 0.5) + 8;
	var _gameView = game_view(),
		_left = _gameView.left_edge(0),
		_top = _gameView.top_edge(0);
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_sprite_ext(sprDot, 0, _left, _top, _boxWidth, _boxHeight, 0, c_black, 0.75);
	draw_text_transformed(_left + 4, _top + 4, _str, 0.5, 0.5, 0);
	draw_reset_text_align();
}

/// @func print(message, warning_level, colour, no_console)
/// @desc This function not only displays the given message in the Output Window,
///		  but will also display the message on-screen for the user to see
///
/// @param {string}  message
/// @param {int}  [warning_level]
/// @param {int}  [colour]
/// @param {bool}  [no_console]
function print(_msg, _warningLevel = WarningLevel.VERBOSE, _colour = c_white, _noConsole = false) {
	if (!_noConsole)
		show_debug_message(_msg);
	
	with (objSystem.debug) {
		if (_warningLevel > consoleWarningLevel)
			return;
		
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

/// @func print_err(message)
/// @desc Prints the given error message
function print_err(_msg) {
	print(_msg, WarningLevel.ERROR, $0010A8);
}
