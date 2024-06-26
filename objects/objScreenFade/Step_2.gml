var _prevPhase = phase;

switch (phase) {
    case 0: // Fade out
        fadeAlpha = remap(0, fadeOutDuration, 0, 1, phaseTimer);
        if (fadeAlpha >= 1) {
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
            
            if (fadeInDuration <= 0) {
                if (!is_undefined(onFadeInEnd))
                    onFadeInEnd(self);
                
                instance_destroy();
            }
        }
        break;
    
    case 2: // Fade in
        fadeAlpha = remap(0, fadeInDuration, 1, 0, phaseTimer);
        if (fadeAlpha <= 0) {
            if (!is_undefined(onFadeInEnd))
                onFadeInEnd(self);
            
            instance_destroy();
        }
        break;
}

image_alpha = round_to(fadeAlpha, fadeStep);
phaseTimer = (phaseTimer + 1) * (phase == _prevPhase);