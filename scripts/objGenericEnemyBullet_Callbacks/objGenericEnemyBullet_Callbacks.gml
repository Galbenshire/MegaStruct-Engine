// Callback functions for objGenericEnemyBullet

/// @func cbkOnDeath_objGenericEnemyBullet(damage_source)
/// @desc objGenericEnemyBullet onDeath callback
function cbkOnDeath_objGenericEnemyBullet(_damageSource) {
    cbkOnDeath_prtProjectile(_damageSource);
    
    if (explodeOnDeath)
        instance_create_depth(x, y, depth, objExplosion);
}
