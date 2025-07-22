/// @description Tick
if (!hasCoiled) {
	animTimer += tailWagSpeed;
	image_index = (animTimer & 1);
	
	var _spring = false;
	
    with (prtPlayer) {
		if (entity_is_dead() || !gravEnabled || !collideWithSolids)
			continue;
		if (yspeed.value * gravDir <= 0 || isClimbing)
			continue;
		
		if (place_meeting(x, y, other.id) && !place_meeting(x, y - yspeed.value, other.id)) {
			yspeed.value = -other.launchSpeed * gravDir;
			canMinJump = false;
			ladderInstance = noone;
			_spring = true;
			break;
		}
    }
    
    if (_spring) {
		image_index = 2;
		hasCoiled = true;
		lifeDuration = 60;
		
		if (!is_undefined(weapon)) {
			weapon.change_ammo(-ammoCost);
			if (instance_exists(owner))
				owner.hudElement.weaponAmmo = weapon.ammo;
		}
    }
}

if (lifeDuration-- <= 0)
    entity_kill_self();
