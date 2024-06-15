// These are base callbacks for `onDespawn`
// `onDespawn` is called everytime an entity has despawned
//
// An entity will despawn in two situations:
// - They have been scrolled offscreen while still alive
// - They have been deactivated during a section switch (in most circumstances)
//
// compared to `onSpawn`, `onDespawn` isn't as commonly used.
// It still has its own use cases; the main one would be to cleanup any dynamic memory uses. (e.g. Data Structures)
// This would be important for when an entity is deactivated during section switches,
// as instance deactivation is not covered by the Cleanup Event

/// @func cbkOnDespawn_prtEntity()
/// @desc Default onDespawn callback for all entities
function cbkOnDespawn_prtEntity() {
    if (DEBUG_ENABLED)
        show_debug_message("Despawn - {0} ({1}, {2})", object_get_name(object_index), x, y);
}

/// @func cbkOnDespawn_prtPlayer()
/// @desc Default onDespawn callback for all entities
function cbkOnDespawn_prtPlayer() {
    if (DEBUG_ENABLED)
        show_debug_message("Player Despawn ({0}, {1})", x, y);
}
