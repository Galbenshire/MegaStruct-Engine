if (global.player.inputs.is_pressed(InputActions.PAUSE)) {
    global.player.inputs.pressed &= ~(1 << InputActions.PAUSE);
    instance_destroy();
}