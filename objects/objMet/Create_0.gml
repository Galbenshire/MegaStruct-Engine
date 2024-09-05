event_inherited();

phase = 0;
phaseTimer = 0;

// Callbacks
onSpawn = method(id, cbkOnSpawn_phaseReset);
onGuard = method(id, cbkOnGuard_imageIndex);