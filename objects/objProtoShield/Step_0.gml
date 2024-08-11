if (!instance_exists(owner)) {
    entity_kill_self();
    event_inherited();
} else {
   event_inherited();
   canReflectShots = !owner.ground && !owner.isHurt && !owner.isClimbing;
}