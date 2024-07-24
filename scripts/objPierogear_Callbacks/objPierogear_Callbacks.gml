// Callback functions for objPierogear

/// @func cbkOnSpawn_objPierogear()
/// @desc objPierogear onSpawn callback
function cbkOnSpawn_objPierogear() {
    cbkOnSpawn_prtEntity();
    
    phase = 0;
    phaseTimer = 0;
    gravEnabled = false;
    collideWithSolids = false;
}

/// @func cbkOnDespawn_objPierogear()
/// @desc objPierogear onDespawn callback
function cbkOnDespawn_objPierogear() {
    cbkOnDespawn_prtEntity();
    
    with (myPiero)
        event_user(1);
    myPiero = noone;
}

/// @func cbkOnDeath_objPierogear(damage_source)
/// @desc objPierogear onDeath callback
function cbkOnDeath_objPierogear(_damageSource) {
    cbkOnDeath_prtEntity(_damageSource);
    
    with (myPiero)
        event_user(0);
    myPiero = noone;
}
