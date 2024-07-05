// Callback functions for objScrewBomber

/// @func cbkOnSpawn_objScrewBomber()
/// @desc objScrewBomber onSpawn callback
function cbkOnSpawn_objScrewBomber() {
    cbkOnSpawn_prtEntity();
    
    mask_index = -1;
    phase = 0;
    phaseTimer = 0;
    bulletCount = 0;
    cooldownTimer = 0;
}
