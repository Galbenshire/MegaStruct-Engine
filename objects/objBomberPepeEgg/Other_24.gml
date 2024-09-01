/// @description Tick
if (xcoll != 0) {
    event_user(0);
    exit;
}

if (ground) {
    landCounter++;
    
    switch (landCounter) {
        case 1: yspeed.value = -4; break;
        case 2: yspeed.value = -2.6; break;
        default: event_user(0); break;
    }
}
