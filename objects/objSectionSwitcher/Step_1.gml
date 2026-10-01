if (!game_can_step(PauseType.PAUSEMENU | PauseType.TIMESCALE))
	exit;

repeat(global.gameTimeScale.integer) {
    stateMachine.tick();
    stateMachine.update_state();
    
    if (global.switchingSections) {
		with (playerInstance) {
			self.handle_input();
			self.handle_switching_weapons();
		}
	}
}