if (global.paused)
	exit;

if (!is_undefined(playerUser) && !player_is_action_locked(PlayerAction.INPUT)) {
    inputs.held = playerUser.inputs.held;
    inputs.pressed |= playerUser.inputs.pressed;
    inputs.released |= playerUser.inputs.released;
}

var _gameTicks = global.gameTimeScale.integer;

repeat(_gameTicks) {
	hitTimer++;
	if (iFrames > 0)
		iFrames = approach(iFrames, 0, 1);
	
    event_user(EVENT_ENTITY_TICK);
    if (entity_is_dead()) // If the player ends up dying during this tick, cut the Step Event short
		exit;

    // =====  Standard Entity Stuff =====
    if (!player_is_action_locked(PlayerAction.PHYSICS)) {
    	entity_handle_external_forces();
		entity_horizontal_movement();
		entity_vertical_movement();
		entity_check_ground();
		player_gravity();
		entity_water();
    }
    
    event_user(EVENT_ENTITY_POSTTICK);
    if (entity_is_dead())
		exit;
    
    inputs.pressed = 0;
    inputs.released = 0;
}

entity_update_subpixels();

if (_gameTicks >= 1)
    inputs.clear_all();