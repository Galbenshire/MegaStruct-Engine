/// @func projectile_reflection_default(reflect_dir)
/// @desc Standard behaviour for a projectile being reflected.
///       Main example being player projectiles.
///
/// @param {int}  reflect_dir  Horizontal direction to reflect the shot by
///                            < 0 = reflect to the left
///                            > 0 = reflect to the right
function projectile_reflection_default(_reflectDir) {
	hitmaskMaster = 0;
	collideWithSolids = false;
    gravEnabled = false;
    despawnRange = 4;
    set_velocity_vector(6, 45 + 90 * (_reflectDir < 0));
    play_sfx(sfxReflect);
}

/// @func projectile_reflection_destroy()
/// @desc Standard behaviour for a projectile being destroyed by a reflection.
///       Shield weapons tend to be responsible for this interaction.
function projectile_reflection_destroy() {
	play_sfx(sfxEnemyHit);
    instance_create_depth(x, y, depth, objExplosion);
	entity_kill_self();
}

/// @func projectile_reflection_proto_shield(reflector)
/// @desc Standard behaviour for a projectile being reflected by the Proto Shield.
///       The bullet becomes a player shot now.
///
/// @param {prtEntity}  reflector  The entity reflecting this projectile
function projectile_reflection_proto_shield(_reflector) {
	play_sfx(sfxReflect);
    image_xscale *= -1;
    direction += 180;
    xspeed.value *= -1;
    yspeed.value *= -1;
    collideWithSolids = false;
    despawnRange = 4;
    pierces = PierceType.NEVER;
    
    owner = _reflector.id;
	factionLayer = (_reflector.factionLayer & Faction.MAIN_ALL) | (factionLayer & Faction.SUB_ALL);
	factionMask = _reflector.factionMask;
}
