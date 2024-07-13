/// @description On Pickup
__collected = true;

with (__collectPlayer) {
    healthpoints = clamp(healthpoints + other.healthToRestore, 0, healthpointsStart);
    playerUser.hudElement.healthpoints = healthpoints;
}

play_sfx(sfxEnergyRestore);