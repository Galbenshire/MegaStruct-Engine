// Callback functions for objSpringHead

/// @func cbkOnSpawn_objSpringHead()
/// @desc objSpringHead onSpawn callback
function cbkOnSpawn_objSpringHead() {
    cbkOnSpawn_prtEntity();
    
    boingTimer = 0;
    image_index = 0;
}

/// @func cbkOnAttackEnd_objSpringHead(damage_source)
/// @desc objSpringHead onAttackEnd callback
function cbkOnAttackEnd_objSpringHead(_damageSource) {
    boingTimer = 128;
    xspeed.value = 0;
}
