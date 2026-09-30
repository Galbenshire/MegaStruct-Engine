/// @description Entity Tick
image_index += animSpeed;

if (!isGearBouncing || yspeed <= 0)
    exit;
if (!place_meeting(x, y, myGear))
    exit;
if (entity_is_dead(myGear))
    exit;

if (gearBounces < maxGearBounces) {
    y = myGear.bbox_top;
    yspeed = -3;
} else {
    with (myGear) {
        myPiero = other;
        event_user(0);
    }
    isGearBouncing = false;
    gravEnabled = false;
    yspeed = 0;
}

gearBounces++;
