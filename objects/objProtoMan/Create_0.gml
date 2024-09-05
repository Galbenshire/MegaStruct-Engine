event_inherited();

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtPlayer();
    
    with (spawn_entity(x, y, depth - 1, objProtoShield))
        owner = other.id;
};
onSetDamage = function(_damageSource) {
    // Proto Man takes 2 extra units of damage
    // (the official games tends to have it be double damage,
    // but I'm hoping this is more balanced)
    
    cbkOnSetDamage_prtPlayer(_damageSource);
    _damageSource.set_damage(_damageSource.damage + 2);
};