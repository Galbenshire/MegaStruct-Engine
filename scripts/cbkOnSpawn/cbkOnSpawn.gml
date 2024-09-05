// These are base callbacks for `onSpawn`
// `onSpawn` is called everytime an entity has spawned in
//
// An entity will spawn in three situations:
// - They have been scrolled onscreen (if currently dead, they must be scrolled offscreen fist)
// - They were created via the `spawn_entity` function
// - On room start, if they are in the starting section
//
// `onSpawn` is best used to reset an entity to their initial state

#region Base Callbacks

/// @func cbkOnSpawn_prtEntity()
/// @desc Default onSpawn callback for all entities
function cbkOnSpawn_prtEntity() {
    if (DEBUG_ENABLED)
        show_debug_message("Spawn - {0} ({1}, {2})", object_get_name(object_index), x, y);
    
    healthpoints = healthpointsStart;
    hitTimer = 9999;
    
    if (!is_undefined(reticle)) {
    	reticle.clear_target();
		reticle.update();
		if (faceTargetOnSpawn)
			calibrate_direction_object(reticle.target);
    }
}

/// @func cbkOnSpawn_prtPlayer()
/// @desc Default onSpawn callback for players
function cbkOnSpawn_prtPlayer() {
    if (DEBUG_ENABLED)
        show_debug_message($"Player Spawn ({x}, {y})");
    
    healthpoints = healthpointsStart;
}

#endregion

#region Available Presets

/// @func cbkOnSpawn_phaseReset()
/// @desc A simple onSpawn callback intended to reset an entity.
///       For this callback to work, the entity must have both a `phase` & a `phaseTimer` variable
///       It is also recommended that image_index 0 be their "resting" frame
function cbkOnSpawn_phaseReset() {
    cbkOnSpawn_prtEntity();
    
    image_index = 0;
    phase = 0;
    phaseTimer = 0;
}

#endregion