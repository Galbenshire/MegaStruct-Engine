/// @description Tick
if (xcoll != 0) {
    xspeed.value = -xcoll;
    maxBounces--;
    
    if (image_index == 0) {
        image_index = 1;
        yspeed.value = -abs(xspeed.value);
    }
} else if (ycoll != 0) {
    yspeed.value = -ycoll;
    maxBounces--;
}

if (maxBounces <= 0)
    collideWithSolids = false;