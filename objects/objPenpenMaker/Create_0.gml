/// @description Insert description here
event_inherited();

spawnTimer = 0;
spawnRate = spawnRateSlow;
spawnSlowCount = 0;

handleSprite = sprPenpenMakerHandle;
handleCount = sprite_get_number(handleSprite);
handleIndex = 0;
handleInFront = false;

isDying = false;
deathTimer = 0;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    hitbox_create_simple(-6, -41, 27, 16);
    
    spawnTimer = 0;
    spawnRate = spawnRateSlow;
    spawnSlowCount = 0;
    
    handleIndex = 0;
    handleInFront = false;
    
    canDealDamage = true;
    isDying = false;
    deathTimer = 0;
    
    image_blend = c_white;
};
onDeath = function(_damageSource) {
    if (isDying) {
        cbkOnDeath_prtEntity(_damageSource);
    } else {
        isDying = true;
        canDealDamage = false;
        entity_clear_hitboxes();
    }
};
onDraw = function(_whiteflash) {
    if (!handleInFront)
        draw_self();
    draw_sprite_ext(handleSprite, handleIndex, x, y - sprite_yoffset, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    if (handleInFront)
        draw_self();
};