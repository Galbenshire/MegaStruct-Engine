event_inherited();

phase = 0;
prevPhase = 0;
phaseTimer = 0;

animIndex = 0;
animCycle = 0;

reformCans = [];

weakspot = noone;

palette = undefined;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_base();
    sprite_index = sprBlocky;
    phase = 0;
    phaseTimer = 0;
    weakspot = hitbox_create_simple(-6, 18, 12, 12, HitMask.TAKE_DAMAGE);
    //weakspot.visible = true;
};
onHurt = function(_damageSource) {
    cbkOnHurt_base(_damageSource);
    if (healthpoints <= 0)
        return;
    
    for (var i = 0; i < 3; i++) {
        var _canY = y + 16 * i;
        if (i > 0)
            _canY += 16;
        
        with (spawn_entity(x, _canY, depth, objBlockyCan)) {
            xspeed.value = (2 - (0.5 * i)) * other.image_xscale;
            yspeed.value = -4.5 + 0.75 * i;
            
            if (!is_undefined(other.palette)) {
				palette = other.palette;
				onDraw = method(id, cbkOnDraw_colour_replacer);
            }
        }
    }
    
    sprite_index = sprBlockyCan;
    image_index = 0;
    y += 16;
    phase = 1;
    phaseTimer = 0;
    xspeed.value = 0;
    ground = false;
    weakspot.hitmask = bitmask_unset_bit(weakspot.hitmask, HitMask.TAKE_DAMAGE);
};

event_user(0); // Palette Init