// These are base callbacks for `onSetDamage`
// During an entity-entity collision, `onSetDamage` will be called on the targeted entity
// to calculate the amount of damage it should receive from the attack.
//
// This allows you to have weapons deal more damage (or less) to specific types of enemies
//
// == Parameters
// damageSource (DamageSource) - this represents the current attack. Use `set_damage` to change the strength of the attack
//

/// @func cbkOnSetDamage_prtEntity(damage_source)
/// @desc Default onSetDamage callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnSetDamage_prtEntity(_damageSource) {
    // todo - damage calculation
}
