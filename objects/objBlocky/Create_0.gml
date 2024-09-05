event_inherited();

phase = 0;
prevPhase = 0;
phaseTimer = 0;

animIndex = 0;
animCycle = 0;

reformCans = [];

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    sprite_index = sprBlocky;
    phase = 0;
    phaseTimer = 0;
};
onGuard = function(_damageSource) {
    if (phase != 0 || !in_range(bbox_y_center(_damageSource.attacker), y + 16, y + 32))
        _damageSource.guard = GuardType.REFLECT_OR_IGNORE;
};
onHurt = function(_damageSource) {
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
};
onDraw = method(id, cbkOnDraw_colourReplacer);

// Palette
palette = undefined; /// @is {ColourReplacer?}
event_user(0);