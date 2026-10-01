/// @description General Behaviour
// =====  Destroy if dead & unable to respawn =====
if (entity_is_dead() && !entity_can_respawn()) {
	instance_destroy();
	exit;
}

// =====  Halt if the entity should not be able to "step" =====
var _stepPauseMask = pauseMask & PauseType.GAMEPLAY;
_stepPauseMask = bitmask_unset_bit(_stepPauseMask, PauseType.TIMESCALE);
if (!game_can_step(_stepPauseMask) || entity_is_dead())
	exit;

// ===== The Frame Begins =====
onFrame();

// ===== Run each tick for the current frame (will depend on game time scale) =====
var _gameTicks = bitmask_has_bit(pauseMask, PauseType.TIMESCALE) ? global.gameTimeScale.integer : 1;
__currentTick = 0; repeat(_gameTicks) {
	hitTimer++;
	if (frozenTimer > 0)
		frozenTimer--;
	if (iFrames > 0)
		iFrames--;
	
	if (!is_undefined(reticle)) {
		reticle.update();
		if (faceTarget && frozenTimer <= 0)
			calibrate_direction_object(reticle.target);
	}
	
	if (ground && !instance_exists(groundInstance))
		entity_check_ground(1, false);
	
	if (frozenTimer > 0) {
		__currentTick++;
		continue;
	}
	
    onTick(__currentTick);
	if (entity_is_dead()) // Cut the Step Event short if the entity ends up dying
		exit;
	
	onMovement();
	
	onPostTick(__currentTick);
	if (entity_is_dead()) // Check again
		exit;
	
	__currentTick++;
}

// ===== The Frame Has Ended =====
onFrameEnd();