event_inherited();

isJumping = false;
timer = 0;
intendedXSpeed = 0;
palette = undefined;

jumps = [
    [1.5, -6],
    [3, -4]
]; /// @is {array<Vector2>}

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    isJumping = false;
    timer = 0;
    mask_index = sprite_index;
};
onDraw = method(id, cbkOnDraw_colourReplacer);

event_user(0); // Init Palette