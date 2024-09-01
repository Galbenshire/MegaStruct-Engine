/// @description Tick
jumpTimer++;

if (jumpTimer == 0) {
    calibrate_direction_object(reticle.target);
    image_index = 0;
} else if (jumpTimer == 40) {
    calibrate_direction_object(reticle.target);
    image_index = 1;
    xspeed.value = image_xscale;
    yspeed.value = -3.5;
    intendedXSpeed = xspeed.value;
} else if (jumpTimer > 40) {
    xspeed.value = intendedXSpeed;
    
    if (ground) {
        image_index = 2;
        xspeed.value = 0;
        jumpTimer = -5;
    }
}

if (eggCounter-- <= 0) {
    var _egg = spawn_entity(x, y, depth, objBomberPepeEgg);
    _egg.owner = self.id;
    _egg.xspeed.value = image_xscale;
    _egg.yspeed.value = -1;
    eggCounter = irandom_range(30, 140);
}
