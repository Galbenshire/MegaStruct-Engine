/// @description Entity Tick
image_index += 0.25;

var _prev_phase = phase;

switch (phase) {
    case 0: // Looking for a target
        xspeed = 1.5 * image_xscale;
        
        if (phaseTimer < 30 || !reticle.targetExists)
            break;
        
        if (reticle.distance_to_target_x() < 48 && y != reticle.y) {
            calibrate_direction_object(reticle.target);
            xspeed = (reticle.x - x) / 24;
            yspeed = (reticle.y - y) / 24;
            targetY = reticle.y;
            phase = 1;
        }
        break;
    
    case 1: // Swoop at target 
        yspeed += 0.025 * sign(yspeed);
        xspeed += 0.025 * sign(xspeed);
        
        if (sign(y - targetY) == sign(yspeed)) {
            phase = 2;
            yspeed *= -1;
        }
        break;
    
    case 2: // Move back to original height 
        yspeed -= 0.025 * sign(yspeed);
        xspeed -= 0.025 * sign(xspeed);
        
        if (sign(y - ystart) == sign(yspeed)) {
            phase = 0;
            xspeed = 0;
            yspeed = 0;
            
            move_y(ystart - y);
            calibrate_direction_object(reticle.target);
        }
        break;
}

phaseTimer = (phaseTimer + 1) * (phase == _prev_phase);
