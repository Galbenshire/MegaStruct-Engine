event_inherited();

image_index = 2;

isBouncing = false;
deathTimer = 10;
palette = undefined; /// @is {ColourReplacerPalette?}

// Callbacks
onGuard = method(id, cbkOnGuard_alwaysReflectOrIgnore);
onDraw = method(id, cbkOnDraw_colourReplacer);