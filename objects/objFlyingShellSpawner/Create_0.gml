event_inherited();

lastSpawnedShell = noone;

// If spawnDir is 0, use the x-scale of the spawner
if (spawnDir == 0)
    spawnDir = sign_nonzero(image_xscale);