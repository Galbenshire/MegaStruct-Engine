event_inherited();

image_alpha = 0.5;

onSpawn = function() {
    cbkOnSpawn_base();
    
    instance_create_depth(x, y, depth - 1, prtHitbox, {
        sprite_index: mskProtoShield,
        owner: id,
        offsetX: 40,
        offsetY: 5,
        canDealDamage: true
    });
    
    var _hitbox = hitbox_create_simple(-8, 32, 16, 32);
    _hitbox.image_blend = c_red;
};