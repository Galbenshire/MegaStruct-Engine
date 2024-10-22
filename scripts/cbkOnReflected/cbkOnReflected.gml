// These are base callbacks for `onReflected`
// During an entity-entity collision, `onReflected` will be called on the attacking entity
// if the target was able to successfully cancel the attack (via their onGuard callback).
//
// The most prominent use of this callback is to have player projectiles fly away when deflected
//
// == Parameters
// damageSource (DamageSource) - this represents the current attack.
//

#region Base Callbacks

/// @func cbkOnReflected_prtEntity(damage_source)
/// @desc Default onReflected callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnReflected_prtEntity(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Reflected - {0} (by {1})", object_get_name(object_index), object_get_name(_damageSource.subject.object_index));
}

/// @func cbkOnReflected_prtProjectile(damage_source)
/// @desc Default onReflected callback for projectiles
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnReflected_prtProjectile(_damage_source) {
    if (DEBUG_ENABLED)
        show_debug_message("Reflected - {0} (by {1})", object_get_name(object_index), object_get_name(_damage_source.subject.object_index));
    
    canTakeDamage = false;
    canDealDamage = false;
    collideWithSolids = false;
    gravEnabled = false;
    set_velocity_vector(6, 45 + 90 * (xspeed.value > 0));
    play_sfx(sfxReflect);
}

#endregion