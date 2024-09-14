/// @description Tick
event_inherited();

if (isFiringMissile) {
    switch (missileTimer) {
        case 0: hatchIndex = 1; break;
        
        case 10:
            hatchIndex = 2;
            spawn_entity(x, y - 5 * image_yscale, depth + 1, objGyoraboiMissile);
            break;
        
        case 20:
            hatchIndex = 0;
            xspeed.value = moveSpeedPostFire * image_xscale;
            break;
    }
    missileTimer++;
} else if (reticle.targetExists && (x - reticle.x) * sign(image_xscale) >= -moveSpeedPreFire) {
    isFiringMissile = true;
    xspeed.value = 0;
    phase++;
}

swimIndex += animSpeed;
image_index = hatchIndex + 3 * (swimIndex & 1);
