event_inherited();

isShooting = false;
shootTimer = 0;

bulletPalette = new ColourReplacerPalette([ $5800E4 ], [ $40A4FF ]);

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    image_index = 0;
    isShooting = false;
    shootTimer = 20;
};
onGuard = method(id, cbkOnGuard_imageIndex);