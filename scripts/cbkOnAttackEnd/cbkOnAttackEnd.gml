// These are base callbacks for `onAttackEnd`
// During an entity-entity collision, `onAttackEnd` will be called on the attacking entity
// having the targeted entity has received damage.
//
// == Parameters
// damageSource (DamageSource) - this represents the current attack.
//

/// @func cbkOnAttackEnd_prtEntity(damage_source)
/// @desc Default onAttackEnd callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnAttackEnd_prtEntity(_damageSource) {
    // ...    
}
