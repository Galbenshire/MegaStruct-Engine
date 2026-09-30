// These are base callbacks for `onBlocking`
// If an attack has been successfully blocked (see cbkOnHandleBlock),
// this callback will be ran on the attacked entity to determine how they should act.
//
// For most entities, this callback won't be needed, as they usually don't "react"
// to having blocked anything.
// However, as an example, this callback could be used to recreate Quick Man's reaction
// to reflecting a shot.
//
// == Parameters
// damageSource (DamageSource) - this represents the current attack.
//


/// @func cbkOnBlocking_base(damage_source)
/// @desc Default onBlocking callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnBlocking_base(_damageSource) {
    //...
}