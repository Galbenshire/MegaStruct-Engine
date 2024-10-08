/// @description On Pickup
__collected = true;

with (__collectPlayer) {
    if (healthpoints >= healthpointsStart)
        exit;
    
    self.restore_health(other.healthToRestore);
}