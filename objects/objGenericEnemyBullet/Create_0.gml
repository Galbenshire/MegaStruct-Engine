event_inherited();

lifeTimer = 0; /// @is {int}

// Callbacks
onDeath = function(_damageSource) {
    cbkOnDeath_projectile(_damageSource);
    if (explodeOnDeath)
        instance_create_depth(x, y, depth, objExplosion);
};