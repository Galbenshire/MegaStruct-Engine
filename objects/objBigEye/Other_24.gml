/// @description Tick
if (!ground) {
    xspeed = intendedXSpeed;
    exit;
}

timer++;
switch (timer) {
    case 1:
        image_index = 4;
        xspeed = 0;
        calibrate_direction_object(reticle.target);
        
        var _prevHighJump = isHighJumping;
        isHighJumping = repeatCount < 2 ? (random(1) < 0.5) : !isHighJumping;
        repeatCount = (repeatCount + 1) * (isHighJumping == _prevHighJump);
        break;
    
    case 4: image_index = 0; break;
    case 6: image_index = isHighJumping; break;
    
    case 40:
        image_index = 2 + isHighJumping;
        xspeed = image_xscale;
        yspeed = -3 * (1 + isHighJumping);
        timer = 0;
        intendedXSpeed = xspeed;
        break;
}