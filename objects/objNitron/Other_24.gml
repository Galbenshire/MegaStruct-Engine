/// @description Entity Tick
var _prevPhase = phase;

switch (phase) {
    case 0: // fly towards Mega Man
        if (reticle.distance_to_target_x() <= sightRange) {
            xspeed.value = 1.5 * image_xscale;
            yspeed.value = 2;
            gravEnabled = true;
            phase++;
        }
        break;
    
    case 1: // Dippin'
        if (phaseTimer == 0 || phaseTimer == 25 || phaseTimer == 50) {
            var _fire = spawn_entity(x, bbox_bottom + 3, depth, objNitronFire, {
                maxHeight: fireHeight,
                growRate: fireGrowRate,
                peakDuration: firePeakDuration
            });
        }
        
        if (phaseTimer == 75) {
            phase++;
            xspeed.value = 0;
            yspeed.value = -3;
            gravEnabled = false;
        }
        break;
}

phaseTimer = (phaseTimer + 1) * (phase == _prevPhase);
image_index += animSpeed;
