// These are base callbacks for `onReflected`
// During an entity-entity collision, `onReflected` will be called on the attacking entity
// if the target was able to successfully cancel the attack (via their onGuard callback).
//
// The most prominent use of this callback is to have player projectiles fly away when deflected
//
// == Parameters
// damageSource (DamageSource) - this represents the current attack.
//

/// @func cbkOnReflected_prtEntity(damage_source)
/// @desc Default onReflected callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnReflected_prtEntity(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Reflected - {0} (by {1})", object_get_name(object_index), object_get_name(_damageSource.subject.object_index));
}
