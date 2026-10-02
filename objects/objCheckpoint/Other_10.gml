/// @description Activate Checkpoint
if (debugOnly)
    exit;

with (objSystem.level) {
    if (!array_equals(checkpoint, other.data)) {
        checkpoint = variable_clone(other.data);
        show_debug_message("--checkpoint--");
    }
}
