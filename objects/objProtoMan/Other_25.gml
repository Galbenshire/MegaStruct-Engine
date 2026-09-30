/// @description Post Tick
event_inherited();

var _shieldActive = !isIntro && !ground && !isClimbing && !isHurt && !isShooting;
with (shieldHitbox)
	hitmask = bitmask_toggle_bit(hitmask, HitMask.BLOCK, _shieldActive);

