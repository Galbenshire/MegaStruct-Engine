/// @description Entity Posttick
stateMachine.posttick();
stateMachine.update_timer();

if (entity_is_dead())
	exit;

player_handle_switch_weapons();
player_handle_shooting();

if (!player_is_action_locked(PlayerAction.SPRITE_CHANGE))
	event_user(11);

player_handle_sections();