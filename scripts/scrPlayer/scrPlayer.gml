/// @interface
/// @func player_init_physics(player)
/// @desc Creates variables related to physics for the given player entity
///
/// @param {prtPlayer}  player  The player entity to call this on
///
/// @returns {bool}  Whether this player is ready (true), or not (false)
function player_init_physics() {
	// Walking
	walkSpeed = 1.3;
	stepFrames = 6;
	brakeFrames = 0;
	brakeSpeed = 0.5;
	
	// Jumping
	jumpSpeed = 5;
	minJumpThreshold = 0;
	minJumpCutoff = 0;
	maxMidairJumps = 0;
	
	// Sliding
	slideSpeed = 2.5;
	slideFrames = 26;
	slideBoostEnabled = false;
	slideShootEnabled = false;
	
	// Climbing
	climbSpeed = 1.3;
	climbJumpEnabled = false;
	
	// Air
	airSpeed = 1.3;
	maxFallSpeed = DEFAULT_FALL_SPEED;
	
	// Misc.
	iceDecelIdle = DEFAULT_ICE_DECEL_IDLE;
	iceDecelWalk = DEFAULT_ICE_DECEL_WALK;
	waterGravMod = 0.38;
}

/// @func is_a_player(scope)
/// @desc Checks if the specified instance is a player object.
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  Whether the instance is a player (true), or not (false)
function is_a_player(_scope = self) {
    return is_object_type(prtPlayer, _scope);
}

/// @func player_death_explosion(x, y, depth_or_layer)
/// @desc Spawns the player explosion effect (also used for bosses)
function player_death_explosion(_x, _y, _depthOrLayer) {
	var _depth = (typeof(_depthOrLayer) == "number")
		? _depthOrLayer
		: layer_get_depth(_depthOrLayer);
	for (var i = 0; i < 16; i++) {
		with (instance_create_depth(_x, _y, _depth, objGenericEffect)) {
			sprite_index = sprExplosion;
			animSpeed = 1/3;
			set_velocity_vector(0.75 * (1 + floor(i / 8)), i * 45);
		}
	}
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
