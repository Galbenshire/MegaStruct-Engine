/// @description Insert description here
event_inherited();

if (isDying) {
    image_blend = merge_colour(c_white, c_black, 0.25 * (deathTimer div 18));
    if (deathTimer mod 18 == 0) {
        instance_create_depth(irandom_range(bbox_left, bbox_right), irandom_range(bbox_top, bbox_bottom), depth - 1, objExplosionBig);
        play_sfx(sfxExplosionMM3);
    }
    deathTimer++;
    if (image_blend == c_black)
        entity_kill_self();
} else {
    handleIndex = modf(handleIndex + 0.1, handleCount);
    handleInFront = (handleIndex < 2) || (handleIndex >= handleCount - 1);
    
    if (++spawnTimer > spawnRate) {
        spawn_entity(x + 6 * image_xscale, bbox_bottom - 8, depth - 1, objPenpen, {
            image_xscale: sign(image_xscale),
            targetingPreset: ReticlePresetType.NO_TARGET,
            respawnType: RespawnType.DISABLED
        });
        
        spawnTimer = 0;
        
        if (random(1) > 0.1 * spawnSlowCount) {
            spawnRate = spawnRateSlow;
            spawnSlowCount++;
        } else {
            spawnRate = spawnRateFast;
            spawnSlowCount = 0;
        }
    }
}
