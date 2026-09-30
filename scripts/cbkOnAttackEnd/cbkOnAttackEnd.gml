// These are base callbacks for `onAttackEnd`
// During an entity-entity collision, `onAttackEnd` will be called on the attacking entity
// after the targeted entity has received damage.
//
// == Parameters
// damageSource (DamageSource) - this represents the current attack.
//


/// @func cbkOnAttackEnd_base(damage_source)
/// @desc Default onAttackEnd callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnAttackEnd_base(_damageSource) {
    // ...    
}