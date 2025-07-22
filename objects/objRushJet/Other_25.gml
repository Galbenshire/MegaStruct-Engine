/// @description Post Tick
animTimer += animSpeed;
image_index = animTimer;

if (xcoll != 0 || (!is_undefined(weapon) && weapon.ammo <= 0))
	entity_kill_self();
