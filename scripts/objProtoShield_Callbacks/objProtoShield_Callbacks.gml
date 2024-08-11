/// @func cbkOnGuard_objProtoShield(damage_source)
/// @desc onGuard callback for Proto Man's shield
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnGuard_objProtoShield(_damageSource) {
    if (!canReflectShots) {
        _damageSource.guard = GuardType.IGNORE;
        return;
    }
    
    with (_damageSource) {
        guard = (attacker.factionLayer & Faction.ENEMY_PROJECTILE > 0) 
            ? GuardType.REFLECT_OR_IGNORE
            : GuardType.IGNORE;
    }
}
