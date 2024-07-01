if (is_screen_fading())
    exit;

var _yDir = inputs.is_pressed(InputActions.DOWN) - inputs.is_pressed(InputActions.UP);
if (_yDir != 0) {
    do {
        optionIndex = modf(optionIndex + _yDir, optionCount);
        currentOption = options[optionIndex];
    } until(struct_exists(currentOption, "onSelect") || struct_exists(currentOption, "onXDirInput"));
}

var _xDir = inputs.is_pressed(InputActions.RIGHT) - inputs.is_pressed(InputActions.LEFT);
if (_xDir != 0 && struct_exists(currentOption, "onXDirInput")) {
    currentOption.onXDirInput(_xDir);
} else if (inputs.is_any_pressed(InputActions.PAUSE, InputActions.JUMP) && struct_exists(currentOption, "onSelect")) {
    currentOption.onSelect();
}