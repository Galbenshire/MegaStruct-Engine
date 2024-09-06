event_inherited();

image_index = 2;

isBouncing = false;
deathTimer = 10;
palette = undefined; /// @is {ColourReplacer?}

// Callbacks
onGuard = method(id, cbkOnGuard_alwaysReflectOrIgnore);
onDraw = method(id, cbkOnDraw_colourReplacer);