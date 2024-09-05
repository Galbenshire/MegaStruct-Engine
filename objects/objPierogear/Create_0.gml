event_inherited();

phase = 0;
phaseTimer = 0;
moveDir = -1;
myPiero = noone;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    phase = 0;
    phaseTimer = 0;
    gravEnabled = false;
    collideWithSolids = false;
};
onDespawn = function() {
    cbkOnDespawn_prtEntity();
    
    with (myPiero)
        event_user(1);
    myPiero = noone;
};
onDeath = function(_damageSource) {
    cbkOnDeath_prtEntity(_damageSource);
    
    with (myPiero)
        event_user(0);
    myPiero = noone;
};