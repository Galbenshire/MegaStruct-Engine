/// @func cbkOnGuard_objSkullBarrier(damage_source)
/// @desc onGuard callback for objSkullBarrier
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnGuard_objSkullBarrier(_damageSource) {
    with (_damageSource) {
        guard = GuardType.IGNORE;
        
        // Is this a projectile?
        if (attacker.factionLayer & Faction.ENEMY_PROJECTILE > 0) {
            attacker.onDeath(self);
            entity_kill_self(subject);
            play_sfx(sfxEnemyHit);
        }
    }
}

/// @func cbkOnReflected_objSkullBarrier(damage_source)
/// @desc onReflected callback for objSkullBarrier
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnReflected_objSkullBarrier(_damageSource) {
    play_sfx(sfxReflect);
    entity_kill_self();
}

/// @func cbkOnDeath_objSkullBarrier(damage_source)
/// @desc onDeath callback for objSkullBarrier
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnDeath_objSkullBarrier(_damageSource) {
    cbkOnDeath_prtProjectile(_damageSource);
    
    with (owner)
        iFrames = 20;
}
