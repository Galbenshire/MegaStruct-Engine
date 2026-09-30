event_inherited();

if (ground) {
    landTimer++;
    jumpTimer++;
    
    image_index = in_range(landTimer, 6, 12);
    intendedXSpeed = 0;
    xspeed = 0;
    
    if (jumpTimer > jumpDelay) {
        calibrate_direction_object(reticle.target);
        intendedXSpeed = moveSpeed * image_xscale;
        yspeed = choose_from_array(jumpSpeeds);
    }
} else {
    image_index = 2;
    xspeed = intendedXSpeed;
    jumpTimer = 0;
    landTimer = 0;
}
