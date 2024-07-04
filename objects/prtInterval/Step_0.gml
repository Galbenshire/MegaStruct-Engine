if (global.paused)
    exit;

repeat(global.gameTimeScale.integer) {
    if (--timer <= 0) {
        timer = waitTime;
        event_user(EVENT_INTERVAL_ACTION);
    }
}