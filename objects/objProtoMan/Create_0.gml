event_inherited();

shieldHitbox = noone;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtPlayer();
    shieldHitbox = instance_create_depth(x, y, depth - 1, objProtoShield, { owner: id });
};
onSetDamage = function(_damageSource) {
    // Proto Man takes 2 extra units of damage
    // (the official games tends to have it be double damage,
    // but I'm hoping this is more balanced)
    
    cbkOnSetDamage_prtPlayer(_damageSource);
    _damageSource.set_damage(_damageSource.damage + 2);
};
onGuard = function(_damageSource) {
	if (_damageSource.subjectHitbox != shieldHitbox)
		return;
	
	_damageSource.guard = (_damageSource.attacker.factionLayer & Faction.ENEMY_PROJECTILE > 0) 
        ? GuardType.REFLECT_OR_IGNORE
        : GuardType.IGNORE;
};