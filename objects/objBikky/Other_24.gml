/// @description Tick
event_inherited();

var _prevPhase = phase;

switch (phase) {
    case 0: // Idle
        image_index = (image_index + 0.1) mod 2;
        
        if (phaseTimer >= jumpInterval) {
            image_index = 2;
            phase++;
        }
        break;
    
    case 1: // Prepare Jump
        image_index += 0.1;
        if (image_index >= 3) {
            calibrate_direction_object(reticle.target);
            xspeed.value = moveSpeed * image_xscale;
            yspeed.value = -jumpSpeed;
            intendedXSpeed = xspeed.value;
            phase++;
            image_index = 3;
        }
        break;
    
    case 2: // Leap & Land
        if (ground) {
            if (xspeed.value != 0) {
                xspeed.value = 0;
                play_sfx(sfxBikkyLand);
            }
            
            image_index -= 0.1 * 2;
            if (image_index <= 1) {
                phase = 0;
                image_index = 0;
            }
        }
        break;
}

phaseTimer = (phaseTimer + 1) * (phase == _prevPhase);
