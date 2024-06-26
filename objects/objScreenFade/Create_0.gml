image_alpha = (fadeOutDuration <= 0);
image_blend = fadeColour;

phase = (image_alpha >= 1);
phaseTimer = 0;
fadeAlpha = image_alpha;

if (!is_undefined(onFadeOutStart))
    onFadeOutStart(self);
if (image_alpha >= 1 && !is_undefined(onFadeOutEnd))
    onFadeOutEnd(self);