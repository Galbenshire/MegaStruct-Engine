/// @func cbkOnSpawn_objProtoMan(damage_source)
/// @desc Default onSpawn callback for when playing as Proto Man
function cbkOnSpawn_objProtoMan() {
    cbkOnSpawn_prtPlayer();
    
    with (spawn_entity(x, y, depth - 1, objProtoShield))
        owner = other.id;
}

/// @func cbkOnSetDamage_objProtoMan(damage_source)
/// @desc Default onSetDamage callback for when playing as Proto Man
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnSetDamage_objProtoMan(_damageSource) {
    cbkOnSetDamage_prtPlayer(_damageSource);
    
    // Proto Man takes 2 extra units of damage
    // (the official games tends to have it be double damage,
    // but I'm hoping this is more balanced)
    _damageSource.set_damage(_damageSource.damage + 2);
}
