/// @func is_a_player(scope)
/// @desc Checks if the specified instance is a player object.
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  Whether the instance is a player (true), or not (false)
function is_a_player(_scope = self) {
    return is_object_type(prtPlayer, _scope);
}

/// @func player_sprite_atlas(sprite)
/// @desc Gets the sprite atlas intended for drawing player spritesheets,
///		  with the option to change its currently active sprite.
///
/// @param {sprite}  [sprite]  The sprite the atlas should draw with. Defaults to the sprite currently in the atlas.
///
/// @returns {SpriteAtlas}  The player spritesheet atlas
function player_sprite_atlas(_sprite) {
	var _atlas = global.spriteAtlas_Player;
	
	if (!is_undefined(_sprite))
		_atlas.sprite = _sprite;
	
	return _atlas;
}

/// @func spawn_player_entity(x, y, depth_or_layer, character_id)
/// @desc Creates an instance of a player character
///
/// @param {number}  x  The x position the player will be created at
/// @param {number}  y  The y position the player will be created at
/// @param {number|layer|string}  depth_or_layer
/// @param {number}  character_id
///
/// @returns {prtPlayer}
function spawn_player_entity(_x, _y, _depthOrLayer, _characterID) {
	return spawn_entity(_x, _y, _depthOrLayer, character_object_from_id(_characterID));
}
