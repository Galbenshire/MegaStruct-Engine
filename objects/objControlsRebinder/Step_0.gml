if (--errorTimer == 0)
    errorMessage = "";

var _key = undefined,
    _skip = keyboard_check_pressed(vk_delete);

if (isBindingKeyboard) {
    if (keyboard_check_pressed(vk_anykey) && !_skip) {
        _key = keyboard_key;
        if (array_contains(illegalKeys, _key))
            errorMessage = "INVALID KEY";
        else if (array_contains(keysUsed, _key))
            errorMessage = "KEY ALREADY USED";
        
        if (errorMessage != "") {
            errorTimer = 90;
            play_sfx(sfxError);
            exit;
        }
    }
} else {
    var _buttonCount = gamepad_button_count(controllerID);
    for (var i = 0; i < _buttonCount; i++) {
        if (gamepad_button_check_pressed(controllerID, i)) {
            _key = i;
            break;
        }
    }
    
    if (array_contains(keysUsed, _key))
        errorMessage = "BUTTON ALREADY USED";
    
    if (errorMessage != "") {
        errorTimer = 90;
        play_sfx(sfxError);
        exit;
    }
}

if (_skip) {
    play_sfx(sfxMenuMove);
    inputIndex++;
} else if (!is_undefined(_key)) {
    if (isBindingKeyboard)
        options_data().keys[inputIndex] = _key;
    else
        options_data().buttons[inputIndex] = _key;
    
    play_sfx(sfxMenuSelect);
    array_push(keysUsed, _key);
    inputIndex++;
}

if (inputIndex >= InputActions.COUNT)
    instance_destroy();