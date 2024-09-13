/// @description Insert description here
event_inherited();

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    xspeed.value = moveSpeed * image_xscale;
};