level.stepEnd();
camera.stepEnd();
shaker.stepEnd();
flasher.stepEnd();
debug.stepEnd();

global.gameTimeScale.value += 0.01 * (mouse_wheel_up() - mouse_wheel_down());