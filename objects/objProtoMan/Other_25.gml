/// @description Post Tick
event_inherited();

with (shieldHitbox)
	active = !owner.ground && !owner.isHurt && !owner.isClimbing;
