/// @description Spawning & Variable Resetting
// =====  Reset variables if dead =====
if (entity_is_dead()) {
	if (!respawn) {
		instance_destroy();
		exit;
	}
	
	y = ystart;
	x = xstart;
	xspeed.clear_all();
    yspeed.clear_all();
    healthpoints = healthpointsStart;
    iFrames = 0;
}

if (global.paused || global.gameTimeScale.integer <= 0)
	exit;

// =====  Respawning/Despawning =====
switch (lifeState) {
	case LifeState.ALIVE:
		if (!entity_within_despawn_range()) {
			lifeState = LifeState.DEAD_ONSCREEN;
			//onDespawn();
		}
		break;
	
	case LifeState.DEAD_ONSCREEN:
		if (!entity_within_respawn_range())
			lifeState = LifeState.DEAD_OFFSCREEN;
		break;
	
	case LifeState.DEAD_OFFSCREEN:
		if (entity_within_respawn_range()) {
			lifeState = LifeState.ALIVE;
			inWater = interactWithWater && place_meeting(x, y, objWater);
			//onSpawn();
		}
		break;
	
	default:
		assert(false, "Invalid value in lifeState for {0}", object_get_name(object_index));
		break;
}