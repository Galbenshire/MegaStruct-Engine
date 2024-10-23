if (is_screen_fading())
    exit;

var _inputs = global.player.inputs;

var _y_dir = _inputs.is_pressed(InputActions.UP) - _inputs.is_pressed(InputActions.DOWN);
if (_y_dir != 0) {
    currentOption = modf(currentOption + _y_dir, optionCount);
    play_sfx(sfxMenuMove);
}

if (_inputs.is_any_pressed(InputActions.PAUSE, InputActions.JUMP)) {
	options[currentOption][1]();
	
	if (is_screen_fading())
		play_sfx(sfxMenuSelect);
}