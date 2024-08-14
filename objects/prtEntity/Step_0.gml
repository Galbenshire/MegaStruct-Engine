/// @description General Behaviour
if (!entity_can_step(true)) {
	if (entity_is_dead() && !respawn)
		instance_destroy();
	exit;
}

repeat(global.gameTimeScale.integer) {
	hitTimer++;
	frozenTimer--;
	if (iFrames > 0)
		iFrames = approach(iFrames, 0, 1);
	
	if (!is_undefined(reticle)) {
		reticle.update();
		if (faceTarget && frozenTimer <= 0)
			calibrate_direction_object(reticle.target);
	}
	
	if (frozenTimer > 0)
		continue;
	
    event_user(EVENT_ENTITY_TICK);
    if (entity_is_dead()) // If the entity ends up dying during this tick, cut the Step Event short
		exit;

    // =====  Standard Entity Stuff =====
    entity_handle_external_forces();
    entity_horizontal_movement();
    entity_vertical_movement();
    entity_check_ground();
    entity_gravity();
    entity_water();
    
    event_user(EVENT_ENTITY_POSTTICK);
    if (entity_is_dead())
		exit;
}

entity_update_subpixels();
entity_update_hitboxes();