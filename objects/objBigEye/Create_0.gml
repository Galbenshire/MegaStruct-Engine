event_inherited();

isHighJumping = false;
timer = 0;
repeatCount = 0;
intendedXSpeed = 0;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    image_index = 2;
    timer = 0;
    repeatCount = 0;
    isHighJumping = false;
    intendedXSpeed = 0;
};
onDraw = method(id, cbkOnDraw_colourReplacer);

event_user(0); // Init Palette