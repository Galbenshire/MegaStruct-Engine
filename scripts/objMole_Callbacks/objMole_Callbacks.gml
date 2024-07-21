// Callback functions for objMole

/// @func cbkOnSpawn_objMole()
/// @desc objMole onSpawn callback
function cbkOnSpawn_objMole() {
    cbkOnSpawn_prtEntity();
    
    event_user(2); // Set bitfield on spawn
    __spawnedBurrowed = (burrowBitField == bitMask_FullyBuried);
    event_user(0); // Calculate move speed
}
