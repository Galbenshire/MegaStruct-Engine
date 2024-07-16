/// @description On Pickup
__collected = true;

with (__collectPlayer) {
    if (healthpoints >= healthpointsStart)
        exit;
    
    player_restore_health(other.healthToRestore);
}