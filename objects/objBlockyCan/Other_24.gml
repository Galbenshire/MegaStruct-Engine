/// @description Entity Tick
deathTimer -= isBouncing;

if (ground) {
    isBouncing = true;
    
    if (deathTimer > 0) {
        xspeed.value = 0;
        yspeed.value = -2;
        y -= 4;
    } else {
        instance_create_depth(bbox_x_center(), bbox_y_center(), depth, objExplosion);
        entity_kill_self();
    }
}