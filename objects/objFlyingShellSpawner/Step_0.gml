if (!game_can_step(pauseMask))
    exit;

if (instance_exists(lastSpawnedShell))
    timer = waitTime;

event_inherited();