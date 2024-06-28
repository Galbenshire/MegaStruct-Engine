if (global.paused)
	exit;

if (!is_undefined(player)) {
    inputs.held = player.inputs.held;
    inputs.pressed |= player.inputs.pressed;
    inputs.released |= player.inputs.released;
}

var _gameTicks = global.gameTimeScale.integer;

repeat(_gameTicks) {
	hitTimer++;
	if (iFrames > 0)
		iFrames = approach(iFrames, 0, 1);
	
    event_user(EVENT_ENTITY_TICK);

    // =====  Standard Entity Stuff =====
    if (!lockpool.is_locked(PlayerAction.PHYSICS)) {
		entity_horizontal_movement();
		entity_vertical_movement();
		entity_check_ground();
		player_gravity();
		entity_water();
    }
    
    event_user(EVENT_ENTITY_POSTTICK);
    
    inputs.pressed = 0;
    inputs.released = 0;
}

entity_update_subpixels();

if (_gameTicks >= 1)
    inputs.clear_all();