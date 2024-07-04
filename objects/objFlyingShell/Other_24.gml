/// @description Physics Tick
var _prev_shooting = isShooting;
shootTimer++;

if (isShooting) {
    if (shootTimer == 15) {
        play_sfx(sfxEnemyShootClassic);
        var _spreadAngle = 360 / bulletCount;
        
        for (var i = 0; i < bulletCount; i++) {
            with (spawn_entity(x, y, depth, objGenericEnemyBullet)) {
                sprite_index = sprBeakBullet;
                contactDamage = 2;
                palette = other.bulletPalette;
                
                set_velocity_vector(other.bulletSpeed, i * _spreadAngle);
                xspeed.value *= sign(image_xscale);
            }
        }
    } else if (shootTimer >= 35) {
        isShooting = false;
    }
} else {
    xspeed.value = moveSpeed * image_xscale;
    if (shootTimer >= 60) {
        xspeed.value = 0;
        isShooting = true;
    }
}

if (isShooting != _prev_shooting)
    shootTimer = 0;

image_index = isShooting;
