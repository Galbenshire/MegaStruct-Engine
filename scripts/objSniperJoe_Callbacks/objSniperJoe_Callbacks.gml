// Callback functions for objSniperJoe

/// @func cbkOnSpawn_objSniperJoe()
/// @desc objSnipeJoe onSpawn callback
function cbkOnSpawn_objSniperJoe() {
    cbkOnSpawn_prtEntity();
    
    image_index = 0;
    isShooting = false;
    shootTimer = 0;
    shootAmount = 0;
}

/// @func cbkOnGuard_objSniperJoe(damage_source)
/// @desc objSniperJoe onGuard callback
function cbkOnGuard_objSniperJoe(_damageSource) {
    if (image_index != 0)
        return;
    
    var _spr = sprite_index;
    sprite_index = mskSniperJoeShield;
    if (place_meeting(x, y, _damageSource.attacker))
        _damageSource.guard = GuardType.REFLECT;
    sprite_index = _spr;
}
