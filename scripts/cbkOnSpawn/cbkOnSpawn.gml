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

/// @func cbkOnSpawn_base()
/// @desc Default onSpawn callback for all entities
function cbkOnSpawn_base() {
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

#endregion

#region Available Presets

/// @func cbkOnSpawn_phase_reset()
/// @desc A simple onSpawn callback intended to reset an entity.
///       For this callback to work, the entity must have both a `phase` & a `phaseTimer` variable
///       It is also recommended that image_index 0 be their "resting" frame
function cbkOnSpawn_phase_reset() {
    cbkOnSpawn_base();
    
    image_index = 0;
    phase = 0;
    phaseTimer = 0;
}

/// @func cbkOnSpawn_player()
/// @desc Default onSpawn callback for players
function cbkOnSpawn_player() {
    if (DEBUG_ENABLED)
        show_debug_message($"Player Spawn ({x}, {y})");
    
    healthpoints = healthpointsStart;
    self.refresh_palette();
    self.reset_all_properties();
}

#endregion