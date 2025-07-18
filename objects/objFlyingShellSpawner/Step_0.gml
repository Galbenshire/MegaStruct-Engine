if (!game_can_step())
    exit;

if (instance_exists(lastSpawnedShell))
    timer = waitTime;

event_inherited();