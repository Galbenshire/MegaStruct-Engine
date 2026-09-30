/// @description Tick
if (!isActive) {
    if (instance_exists(owner) && owner.ground && owner.groundInstance == self.id) {
        isActive = true;
        idleDuration = 99;
    }
    if (idleDuration-- <= 0)
        entity_kill_self();
    
    exit;
}

xspeed = jetXSpeed * image_xscale;
yspeed = 0;

if (instance_exists(owner)) {
    if (owner.ground && owner.groundInstance == self.id) {
		jetLock.activate();
		
		yspeed = jetYSpeed * owner.yDir;
		if (sign(yspeed) == -image_yscale) {
			var _headCheckRange = floor(jetYSpeed + bbox_height(owner)) + 1;
			if (test_move_y(-_headCheckRange))
				yspeed = 0;
		}
		
		if (owner.xDir == -image_xscale) {
			xspeed *= pullbackFactor;
			yspeed *= pullbackFactor;
		}
    } else {
    	jetLock.deactivate();
    }
}

if (!is_undefined(weapon)) {
	weapon.change_ammo(-ammoDrain);
	if (instance_exists(owner))
		owner.hudElement.weaponAmmo = weapon.ammo;
}