/// @func is_a_player(scope)
/// @desc Checks if the specified instance is a player object.
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  Whether the instance is a player (true), or not (false)
function is_a_player(_scope = self) {
    return is_object_type(prtPlayer, _scope);
}

/// @func player_input_palette()
/// @desc Creates a copy of input colours used for the player object
///
/// @returns {PlayerPalette}
function player_input_palette() {
	var _palette/*:PlayerPalette*/ = array_create(PlayerPalette.sizeof);
	_palette[@PlayerPalette.primary] = $EC7000;
	_palette[@PlayerPalette.secondary] = $F8B838;
	_palette[@PlayerPalette.outline] = $9858F8;
	_palette[@PlayerPalette.skin] = $A8D8FC;
	_palette[@PlayerPalette.face] = $000000;
	_palette[@PlayerPalette.eyes] = $FFFFFF;
	
	return _palette;
}

/// @self {prtPlayer}
/// @func player_try_climbing()
function player_try_climbing() {
    ladderInstance = noone;
    
    if (yDir == 0)
        return false;
    
    if (yDir != gravDir)
        ladderInstance = collision_line(bbox_x_center(), bbox_top + 2, bbox_x_center(), bbox_bottom - 1, objLadder, false, false);
    else if (ground)
        ladderInstance = instance_position(sprite_x_center(), bbox_vertical(gravDir) + gravDir, objLadder);
    
    return ladderInstance != noone;
}

/// @self {prtPlayer}
/// @func player_try_sliding()
function player_try_sliding() {
	if (!ground)
        return false;
    
    var _input = inputs.is_pressed(InputActions.SLIDE) || (yDir == gravDir && inputs.is_pressed(InputActions.JUMP) && options_data().downJumpSlide);
    if (!_input)
		return false;
	
	// Check if there's space ahead
	mask_index = maskSlide;
	var _hasSpace = !test_move_x(image_xscale);
	mask_index = maskNormal;
    
    return _hasSpace;
}

/// @func spawn_player_character(x, y, depth_or_layer, character_type)
/// @desc Creates an instance of a player character
///
/// @param {number}  x  The x position the player will be created at
/// @param {number}  y  The y position the player will be created at
/// @param {number|layer|string}  depth_or_layer
/// @param {number}  character_type
///
/// @returns {prtPlayer}
function spawn_player_character(_x, _y, _depthOrLayer, _characterType) {
	var _character = global.characterList[_characterType].object;
	var _body = spawn_entity(_x, _y, _depthOrLayer, _character);
	return _body;
}
