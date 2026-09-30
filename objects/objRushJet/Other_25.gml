/// @description Post Tick
if (sprite_index != sprRushTeleport)
	image_index = modf(image_index + animSpeed, 2);

if (xcoll != 0 || (!is_undefined(weapon) && weapon.ammo <= 0))
	stateMachine.change_state("TeleportOut");
