event_inherited();

phase = 0;
phaseTimer = 0;
intendedXSpeed = 0;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    phase = 0;
    phaseTimer = 0;
    image_index = 0;
};
onGuard = function(_damageSource) {
    if (floor(image_index) != 3)
        _damageSource.guard = GuardType.REFLECT;
};