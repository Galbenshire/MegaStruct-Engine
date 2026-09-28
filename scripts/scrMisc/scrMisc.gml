/// @func cache_game_assets(parent_name)
/// @desc Generates a cache of all constructor functions (classes) that share a given parent
///		  For this to work, the classes must have an `id` variable, unique to each child
///
/// @param {string}  parent_name  The name of the parent constructor function
///
/// @returns {array}  An array of the constructor functions that share the same parent. The parent itself is not included.
function cache_game_assets(_parent) {
	var _childrenScripts = tag_get_asset_ids($"@@parent={_parent}", asset_script),
		_count = array_length(_childrenScripts),
		_children = array_create(_count);
	
	// Put the children in the correct order (according to their ID)
	var i = 0; repeat(_count) {
		var _item = new _childrenScripts[i]();
		_children[_item.id] = _childrenScripts[i];
		delete _item;
		i++;
	}
	
	return _children;
}

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
