if (!game_can_step(pauseMask))
    exit;

var _gameTicks = bitmask_has_bit(pauseMask, PauseType.TIMESCALE) ? global.gameTimeScale.integer : 1;
repeat(_gameTicks) {
    var _prevPhase = phase;
    switch (phase) {
        case -1: // Init
            phase++;
            fadeAlpha = (fadeOutDuration <= 0);
            if (!is_undefined(onFadeOutStart))
                onFadeOutStart(self);
            break;
        
        case 0: // Fade out
            fadeAlpha = (fadeOutDuration > 0) ? remap(0, fadeOutDuration, 0, 1, phaseTimer) : 1;
            if (phaseTimer >= fadeOutDuration) {
                fadeAlpha = 1;
                phase++;
                
                if (!is_undefined(onFadeOutEnd))
                    onFadeOutEnd(self);
            }
            break;
        
        case 1: // Hold
            if (phaseTimer >= fadeHoldDuration) {
                phase++;
                
                if (!is_undefined(onFadeInStart))
                    onFadeInStart(self);
            }
            break;
        
        case 2: // Fade in
            fadeAlpha = (fadeInDuration > 0) ? remap(0, fadeInDuration, 1, 0, phaseTimer) : 0;
            if (phaseTimer >= fadeInDuration) {
                fadeAlpha = 0;
                
                if (!is_undefined(onFadeInEnd))
                    onFadeInEnd(self);
                
                instance_destroy();
                exit;
            }
            break;
    }
    phaseTimer = (phaseTimer + 1) * (phase == _prevPhase);
}