event_inherited();

jumpSpeeds = [-3, -4.5]; // configure this as needed

intendedXSpeed = 0;
jumpTimer = 0;
landTimer = 0;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    jumpTimer = startJumpTimerAt;
    landTimer = 0;
    intendedXSpeed = 0;
};