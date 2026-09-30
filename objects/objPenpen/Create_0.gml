/// @description Insert description here
event_inherited();

// Callbacks
onSpawn = function() {
    cbkOnSpawn_base();
    xspeed.value = moveSpeed * image_xscale;
};