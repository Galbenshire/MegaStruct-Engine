event_inherited();

phase = 0;
phaseTimer = 0;
bulletCount = 0;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    image_index = 0;
    phase = 0;
    phaseTimer = startTimerAt;
};
onGuard = method(id, cbkOnGuard_imageIndex);

event_user(0); // Init Palette