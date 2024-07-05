/// @description Tick
if (!ground) {
    xspeed.value = intendedXSpeed;
    exit;
}

timer++;
switch (timer) {
    case 1:
        image_index = 4;
        xspeed.value = 0;
        calibrate_direction_object(reticle.target);
        
        var _prevHighJump = isHighJumping;
        isHighJumping = repeatCount < 2 ? (random(1) < 0.5) : !isHighJumping;
        repeatCount = (repeatCount + 1) * (isHighJumping == _prevHighJump);
        break;
    
    case 4: image_index = 0; break;
    case 6: image_index = isHighJumping; break;
    
    case 40:
        image_index = 2 + isHighJumping;
        xspeed.value = image_xscale;
        yspeed.value = -3 * (1 + isHighJumping);
        timer = 0;
        intendedXSpeed = xspeed.value;
        break;
}