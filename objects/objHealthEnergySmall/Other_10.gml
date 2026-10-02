/// @description On Pickup
event_inherited();

with (collectingPlayer) {
    if (healthpoints < healthpointsStart)
        self.restore_health(other.healthToRestore);
}