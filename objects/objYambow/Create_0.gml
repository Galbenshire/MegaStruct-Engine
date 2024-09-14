event_inherited();

phase = 0;
phaseTimer = 0;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    canDealDamage = false;
    canTakeDamage = false;
    gravEnabled = false;
    phase = 0;
    phaseTimer = 0;
    visible = false;
};