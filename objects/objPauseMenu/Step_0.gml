if (is_screen_fading())
    exit;

var _prevPhase = phase;

switch (phase) {
    case 0: // Standard Menu Stuff
        menu.update();
        break;
    
    case 10: // Options Menu
        if (!instance_exists(objOptionsMenu))
            phase = 0;
        break;
}

phaseTimer = (phaseTimer + 1) * (phase == _prevPhase);