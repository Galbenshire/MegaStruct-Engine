if (is_screen_fading())
    exit;

var _sDir = inputs.is_pressed(InputActions.WEAPON_SWITCH_RIGHT) - inputs.is_pressed(InputActions.WEAPON_SWITCH_LEFT);
if (_sDir != 0) {
    submenuIndex = modf(submenuIndex + _sDir, submenuCount);
    currentSubmenu = submenus[submenuIndex];
    optionCount = array_length(currentSubmenu.options);
    optionIndex = 0;
    currentOption = currentSubmenu.options[optionIndex];
}

var _yDir = inputs.is_pressed(InputActions.DOWN) - inputs.is_pressed(InputActions.UP);
if (_yDir != 0) {
    optionIndex = modf(optionIndex + _yDir, optionCount);
    currentOption = currentSubmenu.options[optionIndex];
}

var _xDir = inputs.is_pressed(InputActions.RIGHT) - inputs.is_pressed(InputActions.LEFT);
if (_xDir != 0) {
    currentOption.onXDirInput(_xDir);
    currentOption.onUpdateLabel();
}

if (inputs.is_pressed(InputActions.SHOOT))
    go_to_room(rmTitleScreen);