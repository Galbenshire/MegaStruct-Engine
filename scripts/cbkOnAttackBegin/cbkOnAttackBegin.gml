// These are base callbacks for `onAttackBegin`
// During an entity-entity collision, `onAttackBegin` will be called on the attacking entity
// just before damage is dealt to the target.
//
// This is the last chance for the attack to not deal damage.
// In this context, you would do so if the attack is not meant to deal damage.
// e.g. Spark Shot (MM3) does not deal damage to non-bosses, instead paralysing them.
//
// This can be achived by adding a `DamageType.NO_DAMAGE` flag onto the DamageSource passed through.
//
// == Parameters
// damageSource (DamageSource) - this represents the current attack.
//

/// @func cbkOnAttackBegin_prtEntity(damage_source)
/// @desc Default onAttackBegin callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnAttackBegin_prtEntity(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Attack - {0} (on {1})", object_get_name(object_index), object_get_name(_damageSource.subject.object_index));
}
