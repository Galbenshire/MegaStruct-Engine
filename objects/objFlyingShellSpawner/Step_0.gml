if (global.paused || global.gameTimeScale.integer <= 0)
    exit;

if (instance_exists(lastSpawnedShell))
    timer = waitTime;

event_inherited();