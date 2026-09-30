event_inherited();

isShooting = false;
shootTimer = 0;
shootAmount = 0;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_base();
    image_index = 0;
    isShooting = false;
    shootTimer = 0;
    shootAmount = 0;
};
onHandleBlock = function(_damageSource) {
    _damageSource.blockType = BlockType.NONE;
    
    if (image_index == 0) {
        var _spr = sprite_index;
        sprite_index = mskSniperJoeShield;
        if (place_meeting(x, y, _damageSource.attackerHitbox))
            _damageSource.blockType = BlockType.REFLECT;
        sprite_index = _spr;
    }
    
    cbkOnHandleBlock_base(_damageSource);
};