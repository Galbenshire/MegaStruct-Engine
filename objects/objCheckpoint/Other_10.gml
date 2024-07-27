/// @description Activate Checkpoint
var _levelSystem = objSystem.level;

if (array_equals(_levelSystem.checkpoint, data))
    exit;

_levelSystem.checkpoint = variable_clone(data);
show_debug_message("--checkpoint--");
