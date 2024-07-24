/// @description Entity Tick
var _prevPhase = phase;

switch (phase) {
    case 0: // Spawn a Pierobot
        if (phaseTimer == pieroSpawnDelay) {
            var _piero = spawn_entity(x, game_view().top_edge(), depth, objPierobot);
            _piero.myGear = self;
        }
        break;
    
    case 1: // Moving
        if (xcoll != 0) {
            xspeed.value = -xcoll;
            moveDir = sign(xspeed.value);
        } else if (!ground) {
            xspeed.value = 0;
            phase = 2;
        }
        break;
    
    case 2: // Falling
        if (ground) {
            xspeed.value = moveDir;
            phase = 1;
        }
        break;
}

phaseTimer = (phaseTimer + 1) * (phase == _prevPhase);

image_index += animSpeed;