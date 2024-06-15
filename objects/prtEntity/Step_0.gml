/// @description General Behaviour
if (!entity_can_step()) {
	if (entity_is_dead() && !respawn)
		instance_destroy();
	exit;
}

var _gameTicks = global.gameTimeScale.integer;

hitTimer += _gameTicks;
if (iFrames > 0)
	iFrames = approach(iFrames, 0, _gameTicks);

repeat(_gameTicks) {
    event_user(EVENT_ENTITY_TICK); // Run Physics Tick

    // =====  Standard Entity Stuff =====
    entity_horizontal_movement();
    entity_vertical_movement();
    entity_check_ground();
    entity_gravity();
    entity_water();
    
    event_user(EVENT_ENTITY_POSTTICK); // Run Physics Post Tick
}

entity_update_subpixels();