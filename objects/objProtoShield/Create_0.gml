event_inherited();

owner = noone; /// @is {objProtoMan}
canReflectShots = false;

// Callbacks
onGuard = function(_damageSource) {
    if (!canReflectShots) {
        _damageSource.guard = GuardType.IGNORE;
        return;
    }
    
    with (_damageSource) {
        guard = (attacker.factionLayer & Faction.ENEMY_PROJECTILE > 0) 
            ? GuardType.REFLECT_OR_IGNORE
            : GuardType.IGNORE;
    }
};