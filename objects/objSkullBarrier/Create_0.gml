event_inherited();

dealDamageDelay = 2;

// Callbacks
onHandleBlock = function(_damageSource) {
	if (!bitmask_has_bit(_damageSource.attacker.factionLayer, Faction.PROJECTILE)) {
		_damageSource.blockType = BlockType.NONE;
		return;
	}
	
    cbkOnHandleBlock_base(_damageSource);
    
    if (_damageSource.penetrates) {
        play_sfx(sfxEnemyHit);
        play_sfx(sfxMerserker, 0.5, 1.1);
    }
    entity_kill_self();
};
onBlocked = function(_damageSource) {
    play_sfx(sfxReflect);
    entity_kill_self();
};
onDeath = function(_damageSource) {
    cbkOnDeath_projectile(_damageSource);
    
    with (owner) {
        if (!isHurt && other.safeguardFrames > 0)
            iFrames = other.safeguardFrames;
    }
};