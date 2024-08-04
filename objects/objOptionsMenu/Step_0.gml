if (global.gameTimeScale.integer > 0)
    bgY += bgSpeed;

if (is_screen_fading())
    exit;

var _prevPhase = phase;

switch (phase) {
    case 0: // Standard Menu Stuff
        menu.update();
        break;
    
    case 10: // Fade out current menu
        image_alpha = round_to(1 - (phaseTimer / crossFadeDuration), 0.1);
        if (phaseTimer >= crossFadeDuration) {
            menu.pass_submenu_focus(menu.nextSubmenu);
            phase++;
        }
        break;
    
    case 11: // Fade in new menu
        image_alpha = round_to((phaseTimer / crossFadeDuration), 0.1);
        if (phaseTimer >= crossFadeDuration)
            phase = 0;
        break;
    
    case 20: // Rebinding input
        if (!instance_exists(objControlsRebinder))
            phase++;
        break;
    
    case 21: // Small buffer so inputs don't mess up things
        if (phaseTimer >= 4)
            phase = 0;
        break;
}

phaseTimer = (phaseTimer + 1) * (phase == _prevPhase);