event_inherited();

phase = 0;
phaseTimer = 0;
cooldownTimer = 0;
bulletCount = 0;
palette = undefined;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    mask_index = -1;
    phase = 0;
    phaseTimer = 0;
    bulletCount = 0;
    cooldownTimer = 0;
};
onDraw = method(id, cbkOnDraw_colourReplacer);

event_user(0); // Init Palette