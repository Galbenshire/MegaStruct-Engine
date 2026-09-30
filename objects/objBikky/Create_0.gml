event_inherited();

phase = 0;
phaseTimer = 0;
intendedXSpeed = 0;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_base();
    phase = 0;
    phaseTimer = 0;
    hitmask = HitMask.FULL;
    image_index = 0;
};