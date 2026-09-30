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
                colours = other.bulletPalette;
                onDraw = method(id, cbkOnDraw_enemy_bullet_mm1);
                
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

hitmask = bitmask_toggle_bit(hitmask, HitMask.BLOCK, !isShooting);
image_index = isShooting;
