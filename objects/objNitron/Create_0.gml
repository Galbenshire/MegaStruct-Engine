event_inherited();

phase = 0;
phaseTimer = 0;

// Placeholder
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    
    phase = 0;
    phaseTimer = 0;
    xspeed.value = image_xscale;
    gravEnabled = false;
};