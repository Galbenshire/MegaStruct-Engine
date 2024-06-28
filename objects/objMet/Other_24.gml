/// @description Entity Tick
var _prevPhase = phase;

switch (phase) {
    case 0: // In the helmet
        image_index = 0;
        calibrate_direction_object(reticle.target);
        
        if (reticle.targetExists && reticle.distance_to_target() < sightRange)
            phase = 1;
        break;
    
    case 1:
        switch (phaseTimer) {
            case 1: image_index = 1; break;
            case 17:
                // for loop used to make more efficent code
                for (var i = -1; i <= 1; i++) {
                    with (spawn_entity(x + image_xscale * 8, sprite_y_center(), depth, objGenericEnemyBullet)) {
                        set_velocity_vector(2, i * 45);
                        image_xscale = other.image_xscale;
                        xspeed.value *= image_xscale;
                    }
                }
                play_sfx(sfxEnemyShootClassic);
                break;
            case 30: image_index = 0; break;
            case 80: phase = 0; break;
        }
        break;
}

phaseTimer = (phaseTimer + 1) * (phase == _prevPhase);
