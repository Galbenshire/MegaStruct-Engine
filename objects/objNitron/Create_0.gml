event_inherited();

phase = 0;
phaseTimer = 0;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    phase = 0;
    phaseTimer = 0;
    xspeed.value = image_xscale;
    gravEnabled = false;
};