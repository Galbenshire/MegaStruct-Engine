/// @description Tick
if (xcoll != 0) {
    event_user(0);
    exit;
}

if (ground) {
    landCounter++;
    
    switch (landCounter) {
        case 1: yspeed = -4; break;
        case 2: yspeed = -2.6; break;
        default: event_user(0); break;
    }
}
