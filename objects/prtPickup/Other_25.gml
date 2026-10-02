/// @description Entity Posttick
if (disappearTimer > 0) {
    disappearTimer = approach(disappearTimer, 0, 1);
    
    if (disappearTimer < flashThreshold)
		visible = bool((disappearTimer >> 1) & 1);
    
    if (disappearTimer == 0) {
		entity_kill_self();
		exit;
    }
}

if (gravEnabled && ycoll * gravDir > 0) {
    xspeed = 0;
    
    if (!isHeavy) {
        var _force = -ycoll * 0.5;
        if (_force < -0.5) {
            yspeed = _force;
            ground = false;
        }
    }
}

if (place_meeting(x, y, prtPlayer)) {
	collectingPlayer = instance_place(x, y, prtPlayer);
	
	if (player_is_active(collectingPlayer) && (!ignoreCPUPlayers || player_is_user_controlled(collectingPlayer))) {
		event_user(0);
		
		if (isCollected) {
			if (respawnType == RespawnType.ENABLED && canOnlyCollectOnce)
				array_push(objSystem.level.pickups, pickupID);
			instance_destroy();
		}
	}
}