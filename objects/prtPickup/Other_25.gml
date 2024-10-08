/// @description Entity Posttick
if (disappearTimer > 0) {
    disappearTimer = approach(disappearTimer, 0, 1);
    
    if (disappearTimer < flashThreshold)
        flashIndex = (flashIndex + 1) mod 4;
    
    if (disappearTimer == 0) {
    	entity_kill_self();
		exit;
    }
}

if (gravEnabled && ycoll * gravDir > 0) {
    xspeed.value = 0;
    
    if (!isHeavy) {
        var _force = -ycoll * 0.5;
        if (_force < -0.5) {
            yspeed.value = _force;
            ground = false;
        }
    }
}

if (place_meeting(x, y, prtPlayer)) {
	__collectPlayer = instance_place(x, y, prtPlayer);
	
	if (!__collectPlayer.isIntro && (!ignoreCPUPlayers || __collectPlayer.is_user_controlled())) {
		event_user(0);
		
		if (__collected) {
			if (respawnType == RespawnType.ENABLED && canOnlyCollectOnce)
				array_push(objSystem.level.pickups, pickupID);
			instance_destroy();
		}
	}
}