/// @description Entity Tick
var _prevPhase = phase;

switch (phase) {
    case 0: // Wait for the target to get close
        image_index = 0;
        cooldownTimer--;
        
        if (cooldownTimer <= 0 && reticle.targetExists && reticle.distance_to_target() < sightRange)
            phase++;
        break;
    
    case 1: // Opening
    case 3: // Closing
        image_index = 1;
        
        if (phaseTimer >= 5)
            phase = (phase + 1) mod 4;
        break;
    
    case 2: // Shooting
        image_index = 2 + ((phaseTimer div 4) mod 3);
        
        if (phaseTimer == 0)
            mask_index = mskScrewBomberErect;
        
        if (phaseTimer >= 30) {
            if (bulletCount < 2) {
                for (var i = -2; i <= 2; i++) {
                    var _bulletX = x - 4 * i,
                        _bulletY = y - 11 * image_yscale,
                        _bulletYOffset = 1.5 * abs(i) * image_yscale;
                    
                    with (spawn_entity(_bulletX, _bulletY + _bulletYOffset, depth, objGenericEnemyBullet)) {
                        sprite_index = sprBeakBullet;
                        set_velocity_vector(3, 90 + 45 * i);
                        
                        xspeed.value *= other.image_xscale;
                        yspeed.value *= other.image_yscale;
                        contactDamage = 2;
                        
                        if (!is_undefined(other.palette))
                            palette = other.palette;
                    }
                }
                
                bulletCount++;
                phaseTimer -= 30;
                play_sfx(sfxEnemyShootClassic);
            } else {
                phase++;
                bulletCount = 0;
                cooldownTimer = cooldownDuration;
                mask_index = -1;
            }
        }
        break;
}

phaseTimer = (phaseTimer + 1) * (phase == _prevPhase);
