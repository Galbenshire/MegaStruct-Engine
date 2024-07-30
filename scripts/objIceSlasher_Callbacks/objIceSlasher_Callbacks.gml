/// @func cbkOnAttackEnd_objIceSlasher(damage_source)
/// @desc onAttackEnd callback for objIceSlasher
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnAttackEnd_objIceSlasher(_damageSource) {
    with (_damageSource) {
        if (hasKilled || !subject.canBeFrozen)
            return;
        
        subject.frozenTimer = 360;
    }
}
