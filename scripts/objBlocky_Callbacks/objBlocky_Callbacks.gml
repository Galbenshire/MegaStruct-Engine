// Callback functions for objBlocky

/// @func cbkOnSpawn_objBlocky()
/// @desc objBlocky onSpawn callback
function cbkOnSpawn_objBlocky() {
    cbkOnSpawn_prtEntity();
    
    sprite_index = sprBlocky;
    phase = 0;
    phaseTimer = 0;
}

/// @func cbkOnGuard_objBlocky(damage_source)
/// @desc objBlocky onGuard callback
function cbkOnGuard_objBlocky(_damageSource) {
    if (phase != 0 || !in_range(bbox_y_center(_damageSource.attacker), y + 16, y + 32))
        _damageSource.guard = GuardType.REFLECT_OR_IGNORE;
}

/// @func cbkOnHurt_objBlocky(damage_source)
/// @desc objBlocky onHurt callback
function cbkOnHurt_objBlocky(_damageSource) {
    cbkOnHurt_prtEntity(_damageSource);
    
    if (healthpoints <= 0)
        return;
    
    for (var i = 0; i < 3; i++) {
        var _canY = y + 16 * i;
        if (i > 0)
            _canY += 16;
        
        with (spawn_entity(x, _canY, depth, objBlockyCan)) {
            xspeed.value = (2 - (0.5 * i)) * other.image_xscale;
            yspeed.value = -4.5 + 0.75 * i;
            palette = other.palette;
        }
    }
    
    sprite_index = sprBlockyCan;
    image_index = 0;
    y += 16;
    phase = 1;
    phaseTimer = 0;
    xspeed.value = 0;
}
