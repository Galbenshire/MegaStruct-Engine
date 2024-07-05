// Callback functions for objBigEye

/// @func cbkOnSpawn_objBigEye()
/// @desc objBigEye onSpawn callback
function cbkOnSpawn_objBigEye() {
    cbkOnSpawn_prtEntity();
    
    image_index = 2;
    timer = 0;
    repeatCount = 0;
    isHighJumping = false;
    intendedXSpeed = 0;
}
