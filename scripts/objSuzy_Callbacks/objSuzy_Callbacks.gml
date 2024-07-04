// Callback functions for objSuzy

/// @func cbkOnSpawn_objSuzy()
/// @desc objSuzy onSpawn callback
function cbkOnSpawn_objSuzy() {
    cbkOnSpawn_prtEntity();
    
    image_index = 1;
    phase = 2 * startMoving;
    phaseTimer = 10 * startMoving;
    moveDir = (startDirection == "Right/Down") ? 1 : -1;
}
