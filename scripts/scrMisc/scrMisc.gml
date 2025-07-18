/// @func event_user_scope(numb)
/// @desc Version of event_user that can be called on a specific instance
///
/// @param {int}  numb  The number of User Event to call, between 0 and 15.
/// @param {instance}  [scope]  The instance to call this function on. Defaults to the calling instance.
function event_user_scope(_numb, _scope = self) {
	with (_scope)
		event_user(_numb);
}

/// @func is_html5()
/// @desc Checks if this game is running on HTML5
///
/// @returns {bool}  Whether the game is running on HTML5 (true) or not (false)
function is_html5() {
	return (os_browser != browser_not_a_browser) && (os_type != os_gxgames);
}

/// @func is_shader_supported(shader)
/// @desc Checks to see if the given shader works on the current system.
///
/// @param {string|shader}  shader  The shader to check for. Supports either the name of the shader or its asset ID.
///
/// @returns {bool}  Whether this shader is supported (true) or not (false)
function is_shader_supported(_shader) {
	if (!global.shadersSupported)
		return false;
	
	var _shaderName = is_string(_shader) ? _shader : shader_get_name(_shader);
	if (!struct_exists(global.shadersCompiled, _shaderName))
		return false;
	
	return global.shadersCompiled[$ _shaderName];
}

/// @func string_empty(str)
/// @desc This function returns if the given string is empty
///
/// @param {string}  str  The string to check
///
/// @returns {bool}  Whether the string is empty (true) or not (false)
function string_empty(_str) {
	return string_length(_str) <= 0;
}
