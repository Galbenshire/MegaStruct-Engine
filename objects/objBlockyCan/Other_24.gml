/// @description Entity Tick
deathTimer -= isBouncing;

if (ground) {
    isBouncing = true;
    
    if (deathTimer > 0) {
        xspeed = 0;
        yspeed = -2;
        y -= 4;
    } else {
        instance_create_depth(bbox_x_center(), bbox_y_center(), depth, objExplosion);
        entity_kill_self();
    }
}