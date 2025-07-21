event_inherited();

phase = 0;
phaseTimer = 0;
moveDir = 1;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    image_index = 1;
    phase = 2 * startMoving;
    phaseTimer = 10 * startMoving;
    moveDir = (startDirection == "Right/Down") ? 1 : -1;
};

event_user(0); // Init Palette