/// @description Entity Tick
image_index += 0.25;

var _prev_phase = phase;

switch (phase) {
    case 0: // Looking for a target
        xspeed.value = 1.5 * image_xscale;
        
        if (phaseTimer < 30 || !reticle.targetExists)
            break;
        
        if (reticle.distance_to_target_x() < 48 && y != reticle.y) {
            calibrate_direction_object(reticle.target);
            xspeed.value = (reticle.x - x) / 24;
            yspeed.value = (reticle.y - y) / 24;
            targetY = reticle.y;
            phase = 1;
        }
        break;
    
    case 1: // Swoop at target 
        yspeed.value += 0.025 * sign(yspeed.value);
        xspeed.value += 0.025 * sign(xspeed.value);
        
        if (sign(y - targetY) == sign(yspeed.value)) {
            phase = 2;
            yspeed.value *= -1;
        }
        break;
    
    case 2: // Move back to original height 
        yspeed.value -= 0.025 * sign(yspeed.value);
        xspeed.value -= 0.025 * sign(xspeed.value);
        
        if (sign(y - ystart) == sign(yspeed.value)) {
            phase = 0;
            xspeed.clear_all();
            yspeed.clear_all();
            
            move_y(ystart - y);
            calibrate_direction_object(reticle.target);
        }
        break;
}

phaseTimer = (phaseTimer + 1) * (phase == _prev_phase);
