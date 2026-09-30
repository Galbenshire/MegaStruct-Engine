event_inherited();

phase = 0;
phaseTimer = 0;
bulletCount = 0;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_base();
    image_index = 0;
    phase = 0;
    phaseTimer = startTimerAt;
};

event_user(0); // Init Palette