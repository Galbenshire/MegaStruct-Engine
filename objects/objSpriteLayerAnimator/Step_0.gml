if (!game_can_step(pauseMask))
    exit;

var _gameTicks = bitmask_has_bit(pauseMask, PauseType.TIMESCALE) ? global.gameTimeScale.integer : 1;
repeat(_gameTicks) {
    animTimer++;
    
    if (animTimer >= frameDuration) {
        animTimer -= frameDuration;
        animIndex = modf(animIndex + 1, totalFrames);
        event_user(0);
    }
}