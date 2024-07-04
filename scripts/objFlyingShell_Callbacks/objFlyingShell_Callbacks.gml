// Callback functions for objFlyingShell

/// @func cbkOnSpawn_objFlyingShell()
/// @desc objFlyingShell onSpawn callback
function cbkOnSpawn_objFlyingShell() {
    cbkOnSpawn_prtEntity();
    
    image_index = 0;
    isShooting = false;
    shootTimer = 20;
}
