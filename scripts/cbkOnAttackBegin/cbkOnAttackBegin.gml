// These are base callbacks for `onAttackBegin`
// During an entity-entity collision, `onAttackBegin` will be called near the
// very start of the collision, before damage & guard values are calculated
//
// Under most circumstances, you won't need to use this callback.
// However, it might be useful if you need to "mess" with i-frames.
//
// e.g. This is the optimal point to define an attack to ignore i-frames.
// This can be achived by adding a `DamageFlags.IGNORE_IFRAMES` flag onto the DamageSource passed through.
//
// == Parameters
// damageSource (DamageSource) - this represents the current attack.
//

#region Base Callbacks

/// @func cbkOnAttackBegin_base(damage_source)
/// @desc Default onAttackBegin callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnAttackBegin_base(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Attack - {0} (on {1})", object_get_name(object_index), object_get_name(_damageSource.subject.object_index));
}

#endregion