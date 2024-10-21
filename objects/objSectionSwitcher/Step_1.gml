repeat(global.gameTimeScale.integer) {
    stateMachine.tick();
    stateMachine.update_timer();
}