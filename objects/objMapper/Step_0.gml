if (keyboard_check_pressed(vk_f7) && timer > 0) {
    instance_destroy();
    exit;
}

var _xDir = keyboard_check(vk_numpad6) - keyboard_check(vk_numpad4);
if (_xDir != 0) {
    x = clamp(x + _xDir, xMin, xMax);
    mapSurfaceRefresh = true;
}

var _yDir = keyboard_check(vk_numpad2) - keyboard_check(vk_numpad8);
if (_yDir != 0) {
    y = clamp(y + _yDir, yMin, yMax);
    mapSurfaceRefresh = true;
}

var _cDir = keyboard_check_pressed(vk_numpad9) - keyboard_check_pressed(vk_numpad7);
if (_cDir != 0) {
    currentCheckpoint = modf(currentCheckpoint + _cDir, checkpointDataCount);
    mapSurfaceRefresh = true;
}

if (keyboard_check_pressed(vk_numpad0) && checkpointDataCount > 0) {
    objSystem.level.checkpoint = variable_clone(checkpointData[currentCheckpoint]);
    go_to_room(objSystem.level.checkpoint[CheckpointData.room]);
}

timer++;