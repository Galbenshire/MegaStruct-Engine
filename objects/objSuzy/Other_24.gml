/// @description Entity Tick
var _prev_phase = phase;

switch (phase) {
    case 0: // Closing Eye
        image_index = 1;
        if (phaseTimer >= 10)
            phase++;
        break;
    
    case 1: // Idle
        image_index = 0;
        if (phaseTimer >= 100)
            phase++;
        break;
    
    case 2: // Opening Eye
        image_index = 1;
        if (phaseTimer >= 10) {
            xspeed.value = moveSpeed * moveDir * isHorizontal;
            yspeed.value = moveSpeed * moveDir * !isHorizontal;
            phase++;
        }
        break;
    
    case 3: // Moving
        image_index = 2;
        if (xcoll != 0 || ycoll != 0) {
            xspeed.clear_all();
            yspeed.clear_all();
            moveDir *= -1;
            phase = 0;
        }
        break;
}

phaseTimer = (phaseTimer + 1) * (phase == _prev_phase);
