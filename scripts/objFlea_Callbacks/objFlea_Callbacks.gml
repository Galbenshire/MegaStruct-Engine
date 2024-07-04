// Callback functions for objFlea

/// @func cbkOnSpawn_objFlea()
/// @desc objFlea onSpawn callback
function cbkOnSpawn_objFlea() {
    cbkOnSpawn_prtEntity();
    
    isJumping = false;
    timer = 0;
    mask_index = sprite_index;
}
