if (!game_can_step())
    exit;

repeat(global.gameTimeScale.integer) {
    if (--timer <= 0) {
        timer = waitTime;
        event_user(EVENT_INTERVAL_ACTION);
    }
}