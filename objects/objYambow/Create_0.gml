event_inherited();

phase = 0;
phaseTimer = 0;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_base();
    hitmaskMaster = 0;
    gravEnabled = false;
    phase = 0;
    phaseTimer = 0;
    visible = false;
};