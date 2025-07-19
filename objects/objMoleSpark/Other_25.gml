/// @description Tick
if (!instance_exists(myMole)) {
    instance_destroy();
    exit;
}

if (!place_meeting(x, y, myMole) || entity_is_dead(myMole)) {
    instance_destroy();
    exit;
}
