/// @description Post Tick
event_inherited();

with (shieldHitbox) {
	active = !owner.isIntro && !owner.ground && !owner.isClimbing
		&& !owner.isHurt && !owner.isShooting;
}
