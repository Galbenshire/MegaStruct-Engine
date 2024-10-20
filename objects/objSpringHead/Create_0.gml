event_inherited();

boingTimer = 0;

// Callbacks
onGuard = method(id, cbkOnGuard_alwaysReflect);
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    boingTimer = 0;
    image_index = 0;
};
onAttackEnd = function(_damageSource) {
    boingTimer = 128;
    xspeed.value = 0;
};

// Palette
event_user(0);