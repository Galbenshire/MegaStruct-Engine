/// @description Entity Tick
if (isGearBouncing && place_meeting(x, y, myGear) && yspeed.value > 0) {
    if (gearBounces < maxGearBounces) {
        y = myGear.bbox_top;
        yspeed.value = -3;
    } else {
        with (myGear) {
            myPiero = other;
            event_user(0);
        }
        isGearBouncing = false;
        gravEnabled = false;
        yspeed.clear_all();
    }
    
    gearBounces++;
}

image_index += animSpeed;
