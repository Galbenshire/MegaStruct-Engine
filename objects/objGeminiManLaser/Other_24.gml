/// @description Tick
if (xcoll != 0) {
    xspeed = -xcoll;
    maxBounces--;
    
    if (image_index == 0) {
        image_index = 1;
        yspeed = -abs(xspeed);
    }
} else if (ycoll != 0) {
    yspeed = -ycoll;
    maxBounces--;
}

if (maxBounces <= 0)
    collideWithSolids = false;