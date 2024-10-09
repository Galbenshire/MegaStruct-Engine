/// @description Tick
if (!hasCoiled) {
    with (prtPlayer) {
		if (entity_is_dead() || !gravEnabled || !collideWithSolids)
			continue;
		if (yspeed.value * gravDir <= 0 || isClimbing)
			continue;
		
		if (place_meeting(x, y, other.id) && !place_meeting(x, y - yspeed.value, other.id)) {
			yspeed.value = -other.launchSpeed * gravDir;
			canMinJump = false;
			ladderInstance = noone;
			
			other.hasCoiled = true;
			other.lifeDuration = 60;
			other.animator.play("coiled");
			
			if (!is_undefined(other.weapon)) {
				other.weapon.change_ammo(-other.ammoCost);
				if (other.owner.is_user_controlled())
					other.owner.playerUser.hudElement.ammo = other.weapon.ammo;
			}
		}
    }
}

animator.update();

if (lifeDuration-- <= 0)
    entity_kill_self();
