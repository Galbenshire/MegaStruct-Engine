/// @description Post Tick
event_inherited();

with (shieldHitbox) {
	active = owner.is_ready() && !owner.ground && !owner.isClimbing
		&& !owner.isHurt && !owner.isShooting;
}
