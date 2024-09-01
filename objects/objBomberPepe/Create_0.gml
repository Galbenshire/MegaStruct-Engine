event_inherited();

intendedXSpeed = 0;
jumpTimer = 0;
eggCounter = 0;

onSpawn = function() {
    cbkOnSpawn_prtEntity();
    jumpTimer = 0;
    eggCounter = irandom_range(30, 140);
};