/// @description General Behaviour
if (!entity_can_step()) {
	if (entity_is_dead() && !respawn)
		instance_destroy();
	exit;
}

hitTimer++;
if (iFrames > 0)
	iFrames--;

repeat(global.gameTimeScale.integer) {
    event_user(EVENT_ENTITY_TICK); // Run Physics Tick

    // =====  Standard Entity Stuff =====
    entity_horizontal_movement();
    entity_vertical_movement();
    entity_check_ground();
    entity_gravity();
    entity_water();
    
    event_user(EVENT_ENTITY_POSTTICK); // Run Physics Post Tick
}

// =====  Calculate subpixels =====
subPixelX = xspeed.fractional;
subPixelY = yspeed.fractional;
if (ground)
	subPixelY = is_object_type(prtEntity, groundInstance) ? groundInstance.subPixelY : 0;