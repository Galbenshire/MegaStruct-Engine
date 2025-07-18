/// @description Spawning & Variable Resetting
// =====  Reset variables if dead =====
if (entity_is_dead()) {
	if (!entity_can_respawn()) {
		instance_destroy();
		exit;
	}
	
	xspeed.clear_all();
    yspeed.clear_all();
    healthpoints = healthpointsStart;
    iFrames = 0;
    frozenTimer = 0;
}

// =====  Halt if the game is "paused" (unless in the middle of a section switch) =====
if (!game_can_step(false, false, global.switchingSections))
	exit;

// =====  Respawning/Despawning =====
switch (lifeState) {
	case LifeState.ALIVE:
		if (!entity_within_despawn_range()) {
			lifeState = LifeState.DEAD_ONSCREEN;
			onDespawn();
		}
		break;
	
	case LifeState.DEAD_ONSCREEN:
		if (!entity_within_respawn_range()) {
			if (x != xstart || y != ystart) {
				x = xstart;
				y = ystart;
			} else {
				lifeState = LifeState.DEAD_OFFSCREEN;
			}
		}
		break;
	
	case LifeState.DEAD_OFFSCREEN:
		// The room timer check is to ensure things aren't spawning right away on room start,
		// before we even deactivated instances outside of the starting section
		if (entity_can_respawn(false) && entity_within_respawn_range() && global.roomTimer != 0) {
			lifeState = LifeState.ALIVE;
			inWater = interactWithWater && place_meeting(x, y, objWater);
			onSpawn();
		}
		break;
	
	default:
		assert(false, $"Invalid lifeState value ({lifeState}) for {object_get_name(object_index)}");
		break;
}