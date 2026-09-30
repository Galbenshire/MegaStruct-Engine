/// @description Entity Posttick
switch (phase) {
    case 0:
        if (xcoll != 0 && canTurnAround) {
            image_xscale *= -1;
            xspeed = 0.35 * image_xscale;
        }
        break;
}

phaseTimer = (phaseTimer + 1) * (phase == prevPhase);
