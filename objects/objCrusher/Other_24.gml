/// @description Entity Tick
var _prevPhase = phase;

switch (phase) {
    case 0: // Wait for the target
        if (reticle.distance_to_target_x() < sightRange) {
            phase = 1;
            gravEnabled = true;
        }
        break;
    
    case 1: // The Drop
        if (ycoll * gravDir > 0) {
            phase = 2;
            
            if (inside_view())
                play_sfx(sfxTimeStopper);
        }
        break;
    
    case 2: // Recover
        if (phaseTimer >= 64) {
            phase = 3;
            gravEnabled = false;
        }
        break;
    
    case 3: // Retracting
        yspeed.value = -retractSpeed * gravDir;
        if (y <= ystart) {
            y = ystart;
            phase = 0;
        }
        break;
}

phaseTimer = (phaseTimer + 1) * (phase == _prevPhase);