/// @func is_shader_supported(shader)
/// @desc Checks to see if the given shader works on the current system.
///
/// @param {string|shader}  shader  The shader to check for. Supports either the name of the shader or its asset ID.
///
/// @returns {bool}  Wether this shader is supported (true) or not (false)
function is_shader_supported(_shader) {
	if (!global.shadersSupported)
		return false;
	
	var _shaderName = is_string(_shader) ? _shader : shader_get_name(_shader);
	if (!struct_exists(global.shadersCompiled, _shaderName))
		return false;
	
	return global.shadersCompiled[$ _shaderName];
}

/// @func queue_pause()
/// @desc Queues up a game pause at the beginning of the next game frame
function queue_pause() {
	objSystem.pause.pauseQueue = QUEUED_PAUSE;
}

/// @func queue_unpause()
/// @desc Queues up a game unpause at the beginning of the next game frame
function queue_unpause() {
	objSystem.pause.pauseQueue = QUEUED_UNPAUSE;
}
