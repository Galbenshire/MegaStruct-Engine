/// @description Tick
event_inherited();

var _prevPhase = phase;

switch (phase) {
    case 0: // Waiting
        if (reticle.targetExists && reticle.distance_to_target_x() < activateRange) {
            calibrate_direction_object(reticle.target);
            phase++;
            yspeed.value = 1;
            gravEnabled = true;
            canDealDamage = true;
            canTakeDamage = true;
            visible = true;
        }
        break;
    
    case 1: // Dropping down
    case 5:
        if (y >= reticle.y - initialDropHeight * (phase == 1)) {
            gravEnabled = false;
            yspeed.value = 0;
            phase++;
        }
        break;
    
    case 2: // Bounceback from stopping
    case 6:
        yspeed.value = 0;
        
        if (phaseTimer < 4) {
            yspeed.value = 1.5;
        } else if (phaseTimer < 9) {
            yspeed.value = -1.5;
        } else if (phaseTimer >= 20) {
            calibrate_direction_object(reticle.target);
            phase++;
            xspeed.value = moveSpeed * image_xscale;
        }
        break;
    
    case 3: // Moving behind the target
        if ((x - reticle.x) * sign(image_xscale) > behindOffset) {
            calibrate_direction_object(reticle.target);
            phase++;
            xspeed.value = 0;
        }
        break;
    
    case 4: // Delay before dropping again
        if (phaseTimer >= 15) {
            phase++;
            yspeed.value = 1;
            gravEnabled = true;
        }
        break;
}

phaseTimer = (phaseTimer + 1) * (phase == _prevPhase);
image_index += animSpeed;
