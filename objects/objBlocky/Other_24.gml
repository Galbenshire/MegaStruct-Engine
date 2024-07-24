/// @description Entity Tick
prevPhase = phase;

switch (phase) {
    case 0: // Normal
        animIndex += (1/7);
        if (animIndex >= image_number) {
            animIndex = 0;
            animCycle++;
        }
        
        image_index = animIndex;
        if (floor(image_index) == 3 && (animCycle mod 3) != 2)
            image_index = 1;
            
        if (xspeed.value == 0)
            xspeed.value = 0.35 * image_xscale;
        break;
    
    case 1: // Collapsed - Fall to the ground
        if (ground) {
            image_index = 1;
            phase++;
        }
        break;
    
    case 2: // Collapsed - Delay before reforming
        if (phaseTimer >= 150) {
            phase++;
            
            reformCans = array_create_ext(3, function(i) {
                var _can = spawn_entity(x, game_view().bottom_edge(16 * i), depth, objBlockyReformCan);
                _can.targetY = y;
                _can.palette = palette;
                return _can;
            });
        }
        break;
    
    case 3: // Collapsed - Reforming
        if (!array_any(reformCans, function(_can, i) /*=>*/ {return instance_exists(_can)})) {
            phase = 0;
            sprite_index = sprBlocky;
            y -= 48;
        }
        break;
}

phaseTimer *= (phase == prevPhase);