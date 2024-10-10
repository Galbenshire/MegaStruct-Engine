/// @description Post Tick
animator.update();

if (xcoll != 0 || (!is_undefined(weapon) && weapon.ammo <= 0))
	entity_kill_self();
