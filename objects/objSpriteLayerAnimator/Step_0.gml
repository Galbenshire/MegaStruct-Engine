if (global.paused)
    exit;

repeat (global.gameTimeScale.integer) {
    animTimer++;
    
    if (animTimer >= frameDuration) {
        animTimer -= frameDuration;
        animIndex = modf(animIndex + 1, totalFrames);
        event_user(0);
    }
}