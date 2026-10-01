if (!game_can_step(pauseMask))
    exit;

var _gameTicks = bitmask_has_bit(pauseMask, PauseType.TIMESCALE) ? global.gameTimeScale.integer : 1;
repeat(_gameTicks) {
    if (--timer <= 0) {
        timer = waitTime;
        event_user(EVENT_INTERVAL_ACTION);
    }
}