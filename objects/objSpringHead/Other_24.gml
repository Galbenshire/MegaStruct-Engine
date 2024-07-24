/// @description Entity Tick
if (boingTimer > 0) {
    image_index += 0.25;
    boingTimer--;
    
    if (boingTimer <= 0)
        image_index = 0;
    
    exit;
}

var _bumpedIntoWall = test_move_x(16 * image_xscale);
if (_bumpedIntoWall) {
    image_xscale *= -1;
} else {
    var _x = x;
    x += 16 * image_xscale;
    if (!test_move_y(gravDir))
        image_xscale *= -1;
    x = _x;
}

xspeed.value = slowSpeed * image_xscale;
if (reticle.targetExists) {
    if (reticle.target.ground && reticle.target.bbox_bottom == bbox_bottom)
        xspeed.value = fastSpeed * image_xscale;
}
