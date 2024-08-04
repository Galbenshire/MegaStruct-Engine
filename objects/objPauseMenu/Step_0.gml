if (is_screen_fading())
    exit;

var _prevPhase = phase;

switch (phase) {
    case 0: // Standard Menu Stuff
        menu.update();
        break;
}

phaseTimer = (phaseTimer + 1) * (phase == _prevPhase);