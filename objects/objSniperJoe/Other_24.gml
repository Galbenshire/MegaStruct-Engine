/// @description Entity Tick
var _prev_shooting = isShooting;
shootTimer++;

if (!isShooting) {
    image_index = 0;
    if (shootTimer >= 90)
        isShooting = true;
} else {
    image_index = 1;
    if (shootTimer >= 32) {
        if (shootAmount < 3) {
            shootTimer = 0;
            shootAmount++;
            play_sfx(sfxEnemyShootClassic);
            
            var i = spawn_entity(x + 6 * image_xscale, y + 8, depth, objGenericEnemyBullet);
            i.xspeed.value = image_xscale * 2;
        }
        
        if (shootAmount >= 3) {
            shootAmount = 0;
            isShooting = false;
        }
    }
}

if (isShooting != _prev_shooting)
    shootTimer = 0;
