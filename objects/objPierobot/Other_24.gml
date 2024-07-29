/// @description Entity Tick
image_index += animSpeed;

if (!isGearBouncing || yspeed.value <= 0)
    exit;
if (!place_meeting(x, y, myGear))
    exit;
if (entity_is_dead(myGear))
    exit;

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
