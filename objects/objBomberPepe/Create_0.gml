event_inherited();

intendedXSpeed = 0;
jumpTimer = 0;
eggCounter = 0;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_base();
    jumpTimer = 0;
    eggCounter = irandom_range(30, 140);
};