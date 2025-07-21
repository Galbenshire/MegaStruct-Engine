event_inherited();

phase = 0;
phaseTimer = 0;
targetY = y;

// Callbacks
onSpawn = method(id, cbkOnSpawn_phaseReset);

event_user(0); // Init Palette