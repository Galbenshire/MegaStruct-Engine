event_inherited();

phase = 0;
phaseTimer = 0;

isFiringMissile = false;
missileTimer = 0;

swimIndex = 0;
hatchIndex = 0;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    isFiringMissile = false;
    missileTimer = 0;
    hatchIndex = 0;
    xspeed.value = moveSpeedPreFire * image_xscale;
};