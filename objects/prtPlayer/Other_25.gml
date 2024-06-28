/// @description Entity Posttick
stateMachine.posttick();
stateMachine.update_timer();

player_switch_weapons();
player_handle_shooting();

if (!lockpool.is_locked(PlayerAction.SPRITE_CHANGE)) {
	skinCellX = 0;
	skinCellY = 0;
	animator.update();
}

player_handle_sections();