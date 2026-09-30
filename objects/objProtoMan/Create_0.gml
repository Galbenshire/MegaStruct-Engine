event_inherited();

shieldHitbox = noone;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_player();
    shieldHitbox = instance_create_depth(x, y, depth, objProtoShield, { owner: id });
};
onSetDamage = function(_damageSource) {
    // Proto Man takes 2 extra units of damage
    // (the official games tends to have it be double damage,
    // but I'm hoping this is more balanced)
    
    cbkOnSetDamage_player(_damageSource);
    _damageSource.set_damage(_damageSource.damage + 2);
};
onHandleBlock = function(_damageSource) {
	_damageSource.blockType = BlockType.NONE;
	if (_damageSource.subjectHitbox != shieldHitbox)
		return;
	
	if (bitmask_has_bit(_damageSource.attacker.factionLayer, Faction.PROJECTILE))
		_damageSource.blockType = BlockType.PROTO_SHIELD;
};