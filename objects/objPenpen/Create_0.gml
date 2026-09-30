/// @description Insert description here
event_inherited();

// Callbacks
onSpawn = function() {
    cbkOnSpawn_base();
    xspeed = moveSpeed * image_xscale;
};