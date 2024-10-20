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

xspeed.value = jetXSpeed * image_xscale;
yspeed.value = 0;

if (instance_exists(owner)) {
    if (owner.ground && owner.groundInstance == self.id) {
		jetLock.activate();
		
		yspeed.value = jetYSpeed * owner.yDir;
		if (sign(yspeed.value) == -image_yscale) {
			var _headCheckRange = floor(jetYSpeed + bbox_height(owner)) + 1;
			if (test_move_y(-_headCheckRange))
				yspeed.value = 0;
		}
		
		if (owner.xDir == -image_xscale) {
			xspeed.value *= pullbackFactor;
			yspeed.value *= pullbackFactor;
		}
    } else {
    	jetLock.deactivate();
    }
}

if (!is_undefined(weapon)) {
	weapon.change_ammo(-ammoDrain);
	if (instance_exists(owner))
		owner.update_hud_ammo(weapon.ammo, , weapon);
}