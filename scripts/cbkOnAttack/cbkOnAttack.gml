// These are base callbacks for `onAttack`
// During an entity-entity collision, `onAttack` will be called on the attacking entity
// just before damage is dealt to the target.
//
// This is the last chance for the attack to not deal damage.
// In this context, you would do so if the attack is not meant to deal damage.
// e.g. Spark Shot (MM3) does not deal damage to non-bosses, instead paralysing them.
//
// This can be achived by setting `damageEnabled` on the DamageSource passed through to `false`.
//
// == Parameters
// damageSource (DamageSource) - this represents the current attack.
//

/// @func cbkOnAttack_base(damage_source)
/// @desc Default onAttack callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnAttack_base(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Attack - {0} (on {1})", object_get_name(object_index), object_get_name(_damageSource.subject.object_index));
}