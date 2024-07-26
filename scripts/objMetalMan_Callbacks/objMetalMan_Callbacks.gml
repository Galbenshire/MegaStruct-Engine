/// @func cbkOnSpawn_objMetalMan()
/// @desc objMetalMan onSpawn callback
function cbkOnSpawn_objMetalMan() {
    cbkOnSpawn_prtEntity();
    
    distanceToMiddle = abs(x - game_view().center_x());
    playerShotListener = signal_bus().connect_to_signal("playerShot", self, function(_data) {
        if (_data.player == reticle.target)
            jumpFlag = true;
    });
}

/// @func cbkOnDespawn_objMetalMan()
/// @desc objMetalMan onDespawn callback
function cbkOnDespawn_objMetalMan() {
    cbkOnDespawn_prtEntity();
    event_perform(ev_cleanup, 0);
}

/// @func cbkOnDeath_objMetalMan(damage_source)
/// @desc objMetalMan onDeath callback
///
/// @param {DamageSource}  damage_source
function cbkOnDeath_objMetalMan(_damageSource) {
    cbkOnDeath_prtBoss(_damageSource);
    
    with (objGenericEnemyBullet) {
        if (owner == other.id)
            instance_destroy();
    }
}
