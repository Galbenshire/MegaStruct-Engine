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

/// @func spawn_child_effect(x_offset, y_offset, depth_offset, object, var_struct, parent)
/// @desc Spawns an effect as a child of another entity.
///
/// @param {number}  x_offset  Horizontal offset from the parent. Takes into account the parent's x-scale
/// @param {number}  y_offset  Vertical offset from the parent. Takes into account the parent's y-scale
/// @param {number}  depth_offset  Relative depth from the parent
/// @param {prtEffect}  obj  The object index the child will be an instance of
/// @param {struct}  [var_struct]  A struct with variables to assign to the new instance. Optional.
/// @param {prtEntity}  [parent]  The entity that will act as the parent. Defaults to the calling instance.
///
/// @returns {instance}  An instance of the entity specified
function spawn_child_effect(_xOffset, _yOffset, _depthOffset, _obj, _vars = {}, _parent = self) {
	var _entityX = entity_x(_parent) + _xOffset * _parent.image_xscale,
		_entityY = entity_y(_parent) + _yOffset * _parent.image_yscale,
		_entityDepth = _parent.depth + _depthOffset;
	
	var _entity = instance_create_depth(_entityX, _entityY, _entityDepth, _obj, _vars);
	_entity.owner = _parent.id;
	_entity.createdBy = _parent.id;
	
	return _entity;
}

/// @method spawn_damage_popup(x, y, text)
/// @desc Spawns a damage popup that displays the provided text
///
/// @param {number}  x  The x position to spawn the popup at
/// @param {number}  y  The y position to spawn the popup at
/// @param {string}  text  The text the popup should display
///
/// @returns {objDamagePopup}  The damage popup
function spawn_damage_popup(_x, _y, _text) {
	return instance_create_depth(_x, _y, layer_get_depth(LAYER_FADER) + 10, objDamagePopup, { display: _text });
}
