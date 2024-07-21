event_inherited();

if (global.paused || global.gameTimeScale.integer <= 0)
	exit;

if (!instance_exists(myMole)) {
    instance_destroy();
    exit;
}

if (!place_meeting(x, y, myMole) || entity_is_dead(myMole)) {
    instance_destroy();
    exit;
}
