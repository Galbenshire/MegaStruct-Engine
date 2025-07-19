/// @description Tick
y--;
    
if (--animCounter <= 0) {
    animCounter = 9;
    animIndex = (animIndex + 1) mod 9;
    
    if (animIndex == 4)
        x--;
    else if (animIndex == 8)
        x += 2;
}

if (!place_meeting(x, y, objWater)) {
    instance_destroy();
    exit;
}
