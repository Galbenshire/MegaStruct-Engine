/// @description Entity Posttick
stateMachine.posttick();
stateMachine.update_timer();

if (entity_is_dead())
	exit;

player_handle_switch_weapons();
player_handle_shooting();

if (!player_is_action_locked(PlayerAction.SPRITE_CHANGE)) {
	skinCellX = 0;
	skinCellY = shootAnimation;
	animator.update();
}

player_handle_sections();