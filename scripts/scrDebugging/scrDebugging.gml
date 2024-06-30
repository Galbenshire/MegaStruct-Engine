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
