if (global.switchingSections)
    exit;

repeat(global.gameTimeScale.integer) {
    stateMachine.tick();
    stateMachine.update_timer();
    animator.update();
}