/// @description Entity Tick
if (isJumping) {
    if (ground) {
        isJumping = false;
        xspeed.value = 0;
        timer = 0;
        mask_index = sprite_index;
    } else {
        xspeed.value = intendedXSpeed;
    }
} else {
    if (++timer >= 30) {
        calibrate_direction_object(reticle.target);
        isJumping = true;
        ground = false;
        
        var _jump = choose_from_array(jumps);
        xspeed.value = _jump[Vector2.x] * image_xscale;
        yspeed.value = _jump[Vector2.y];
        
        image_xscale = 1;
        mask_index = mskFleaJump;
        intendedXSpeed = xspeed.value;
    }
}

image_index = !ground;
