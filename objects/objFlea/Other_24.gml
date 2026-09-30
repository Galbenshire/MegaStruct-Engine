/// @description Entity Tick
if (isJumping) {
    if (ground) {
        isJumping = false;
        xspeed = 0;
        timer = 0;
        mask_index = sprite_index;
    } else {
        xspeed = intendedXSpeed;
    }
} else {
    if (++timer >= 30) {
        calibrate_direction_object(reticle.target);
        isJumping = true;
        ground = false;
        
        var _jump = choose_from_array(jumps);
        xspeed = _jump[Vector2.x] * image_xscale;
        yspeed = _jump[Vector2.y];
        
        image_xscale = 1;
        mask_index = mskFleaJump;
        intendedXSpeed = xspeed;
    }
}

image_index = !ground;
