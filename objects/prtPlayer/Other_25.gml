/// @description Entity Posttick
stateMachine.posttick();
stateMachine.update_timer();

player_handle_switch_weapons();
player_handle_shooting();

if (!lockpool.is_locked(PlayerAction.SPRITE_CHANGE)) {
	skinCellX = 0;
	skinCellY = shootAnimation;
	animator.update();
}

player_handle_sections();