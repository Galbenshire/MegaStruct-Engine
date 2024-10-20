// Defines checkpoints for your level
// This is a more precise version of objCheckpoint:
// - It's triggered from the player touching it, rather than when it comes onscreen
// - The position of the checkpoint is set manually by the user

var _x = (targetX != -1) ? targetX : bbox_x_center(),
    _y = (targetY != -1) ? targetY : bbox_bottom - 16;

name = !string_empty(name) ? name : $"Checkpoint_{_x}_{_y}";
data = [room, _x, _y, sign_nonzero(targetDir), name]; /// @is {CheckpointData}