/// @description Entity Tick
var _prevPhase = phase;

switch (phase) {
    case 0: // Closed
        image_index = 0;
        if (phaseTimer >= 90)
            phase++;
        break;
    
    case 1: // Opening
        image_index = (phaseTimer div 7) + 1;
        bulletCount = 0;
        if (phaseTimer >= 17)
            phase++;
        break;
    
    case 2: // Open
        if (phaseTimer mod 30 == 0) {
            with (spawn_entity(x + image_xscale * 16, y + 8, depth, objGenericEnemyBullet)) {
                sprite_index = sprBeakBullet;
                image_xscale = other.image_xscale;
                set_velocity_vector(3, 45 - (other.bulletCount * 30));
                xspeed.value *= image_xscale;
				contactDamage = 2;
				colours = other.bulletPalette;
                onDraw = method(id, cbkOnDraw_enemyBulletMM1);
            }
            play_sfx(sfxEnemyShootClassic);
            bulletCount++;
        }
        
        if (bulletCount >= 4)
            phase++;
        break;
    
    case 3: // Closing
        image_index = 3 - 2 * (phaseTimer >= 8);
        if (phaseTimer >= 15)
            phase = 0;
        break;
}

phaseTimer = (phaseTimer + 1) * (phase == _prevPhase);
