event_inherited();

isShooting = false;
shootTimer = 0;

bulletPalette = [ $40A4FF, $F8F8F8 ];

// Callbacks
onSpawn = function() {
    cbkOnSpawn_base();
    image_index = 0;
    isShooting = false;
    shootTimer = 20;
};