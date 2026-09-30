/// @description General Behaviour
// =====  Destroy if dead & unable to respawn =====
if (entity_is_dead() && !entity_can_respawn()) {
	instance_destroy();
	exit;
}

// =====  Halt if the entity should not be able to "step" =====
if (!entity_can_step(true, true))
	exit;

// ===== The Frame Begins =====
onFrame();

// =====  The standard "Step" (do it for each active "frame" in the game time scale) =====
__currentTick = 0; repeat(global.gameTimeScale.integer) {
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