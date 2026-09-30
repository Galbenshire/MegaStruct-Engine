/// @description Tick
event_inherited();

var _prevPhase = phase;

switch (phase) {
    case 0: // Waiting
        if (reticle.targetExists && reticle.distance_to_target_x() < activateRange) {
            calibrate_direction_object(reticle.target);
            phase++;
            yspeed = 1;
            gravEnabled = true;
            hitmaskMaster = HitMask.FULL;
            visible = true;
        }
        break;
    
    case 1: // Dropping down
    case 5:
        if (y >= reticle.y - initialDropHeight * (phase == 1)) {
            gravEnabled = false;
            yspeed = 0;
            phase++;
        }
        break;
    
    case 2: // Bounceback from stopping
    case 6:
        yspeed = 0;
        
        if (phaseTimer < 4) {
            yspeed = 1.5;
        } else if (phaseTimer < 9) {
            yspeed = -1.5;
        } else if (phaseTimer >= 20) {
            calibrate_direction_object(reticle.target);
            phase++;
            xspeed = moveSpeed * image_xscale;
        }
        break;
    
    case 3: // Moving behind the target
        if ((x - reticle.x) * sign(image_xscale) > behindOffset) {
            calibrate_direction_object(reticle.target);
            phase++;
            xspeed = 0;
        }
        break;
    
    case 4: // Delay before dropping again
        if (phaseTimer >= 15) {
            phase++;
            yspeed = 1;
            gravEnabled = true;
        }
        break;
}

phaseTimer = (phaseTimer + 1) * (phase == _prevPhase);
image_index += animSpeed;
