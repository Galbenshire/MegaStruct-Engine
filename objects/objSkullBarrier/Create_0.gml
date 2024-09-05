event_inherited();

// Callbacks
onGuard = function(_damageSource) {
    with (_damageSource) {
        guard = GuardType.IGNORE;
        
        // Is this a projectile?
        if (attacker.factionLayer & Faction.ENEMY_PROJECTILE > 0) {
            attacker.onDeath(self);
            entity_kill_self(subject);
            play_sfx(sfxEnemyHit);
        }
    }
};
onReflected = function(_damageSource) {
    play_sfx(sfxReflect);
    entity_kill_self();
};
onDeath = function(_damageSource) {
    cbkOnDeath_prtProjectile(_damageSource);
    with (owner)
        iFrames = 20;
};