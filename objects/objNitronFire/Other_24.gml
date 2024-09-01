/// @description Entity Tick
switch (phase) {
    case 0: // drop to the ground
        if (ground || check_for_solids(x, y)) {
            play_sfx(sfxNitronFire);
            visible = false;
            gravEnabled = false;
            collideWithSolids = false;
            canDealDamage = false;
            yspeed.value = 0;
            explosionRef = instance_create_depth(x, y - 4, depth, objExplosion);
            phase++;
        }
        break;
    
    case 1: // Wait for the explosion to go away
        if (!instance_exists(explosionRef)) {
            visible = true;
            canDealDamage = true;
            animTimer = 0;
            phase++;
        }
        break;
    
    case 2: // The fire grows
        growCounter.update();
        image_yscale += growCounter.integer;
        if (image_yscale >= maxHeight)
            phase++;
        break;
    
    case 3: // Stay at max length for a moment
        if (peakDuration-- <= 0) {
            growCounter.clear_fractional();
            phase++;
        }
        break;
    
    case 4: // The fire dies out
        growCounter.update();
        image_yscale = approach(image_yscale, 0, growCounter.integer);
        if (image_yscale == 0)
            entity_kill_self();
        break;
}

if (animTimer < 0) {
    image_index = 0;
} else {
    animTimer += 0.3;
    image_index = 1 + (animTimer mod 3);
}
