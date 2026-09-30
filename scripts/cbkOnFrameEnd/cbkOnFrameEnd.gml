// These are base callbacks for `onFrameEnd`
// `onFrameEnd` is called every game frame, after all game ticks (if any) have been processed.
//
// By default, most entities will use this to update their hitboxes after having moved.
// Players, will use this callback to clear inputs, if this frame had no game ticks.
//
// NOTE: Unlike a "game tick", a frame is an actual in-game frame.
//       This means a frame always occurs once.

#region Base Callback

/// @func cbkOnFrameEnd_base()
/// @desc Default onFrameEnd callback for all entities
function cbkOnFrameEnd_base() {
    entity_update_subpixels();
	entity_update_hitboxes();
}

#endregion

#region Available Presets

/// @func cbkOnFrameEnd_player()
/// @desc onFrameEnd callback for players
function cbkOnFrameEnd_player() {
	cbkOnFrameEnd_base();
	
	if (global.gameTimeScale.integer > 0)
		inputs.clear_all();
}

#endregion