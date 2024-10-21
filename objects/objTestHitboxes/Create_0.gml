event_inherited();

image_alpha = 0.5;

onSpawn = function() {
    cbkOnSpawn_prtEntity();
    
    instance_create_depth(x, y, depth - 1, prtHitbox, {
        sprite_index: mskProtoShield,
        owner: id,
        offsetX: 40,
        offsetY: 5,
        canDealDamage: true
    });
    
    var _hitbox = hitbox_create_simple(-8, 32, 16, 32, true, false, true);
    _hitbox.image_blend = c_red;
};
onDraw = function(__) {
    global.spriteAtlas_Player.sprite = sprPlayerSkinBlues;
    global.spriteAtlas_Player.draw_cell_ext(0, 0, 0, x, y, image_xscale, image_yscale, image_blend, image_alpha);    
};