// These are base callbacks for `onMovement`
// `onMovement` is called every game tick, inbetween `onTick` & `onPostTick`
// This is where an entity actually moves
//
// By default, the following will occur in `onMovement`
// - apply gravity
// - apply external forces (e.g. conveyors)
// - move the entity horizontally
// - move the entity verically
// - check for ground underneath
// - handle water
//
// For the most part, overriding this callback is unnecessary
// (& not recommended unless you know what you're doing).
// However, in specific contexts, overriding this might be beneficial.
// One example would be for a ground trailing entity that turns around when facing ledges.

#region Base Callback

/// @func cbkOnMovement_base()
/// @desc Default onMovement callback for all entities
function cbkOnMovement_base() {
    entity_handle_external_forces();
	entity_movement_horizontal();
	entity_movement_vertical();
	entity_apply_gravity();
	entity_check_ground();
	entity_handle_water();
}

#endregion

#region Available Presets

/// @func cbkOnMovement_player()
/// @desc onMovement callback for players
function cbkOnMovement_player() {
	if (self.is_action_locked(PlayerAction.PHYSICS))
		return;
	
	entity_handle_external_forces();
	entity_movement_horizontal();
	entity_movement_vertical(2);
	if (!self.is_action_locked(PlayerAction.GRAVITY))
		entity_apply_gravity();
	entity_check_ground();
	entity_handle_water();
}

/// @func cbkOnMovement_static()
/// @desc onMovement callback for entities with no intention on moving
function cbkOnMovement_static() {
	// Don't move, 4head
}

#endregion