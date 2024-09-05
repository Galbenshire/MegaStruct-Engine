event_inherited();

isShooting = false;
shootTimer = 0;
shootAmount = 0;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    image_index = 0;
    isShooting = false;
    shootTimer = 0;
    shootAmount = 0;
};
onGuard = function(_damageSource) {
    if (image_index != 0)
        return;
    
    var _spr = sprite_index;
    sprite_index = mskSniperJoeShield;
    if (place_meeting(x, y, _damageSource.attacker))
        _damageSource.guard = GuardType.REFLECT;
    sprite_index = _spr;
};