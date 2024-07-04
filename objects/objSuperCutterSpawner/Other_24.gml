/// @description Perform Interval Action
if (!instance_exists(prtPlayer))
    exit;
if (abs(prtPlayer.x - x) > detectRange) {
    timer = 1; // Stall the timer until the player gets close enough
    exit;
}

with (spawn_entity(x, y, depth, objGenericEnemyBullet, cutterParams)) {
    yspeed.value = -4.8;
    xspeed.value = (reticle.x - x) / 48;
    calibrate_direction_object(reticle.target);
}
