// Defines checkpoints for your level
// This is a more precise version of objCheckpoint:
// - It's triggered from the player touching it, rather than when it comes onscreen
// - The position of the checkpoint is set manually by the user
event_inherited();

var _x = (targetX != -1) ? targetX : bbox_x_center(),
    _y = (targetY != -1) ? targetY : bbox_bottom - 16;

data[CheckpointData.name] = !string_empty(name) ? name : string("Checkpoint_{0}_{1}_{2}", room_get_name(room), _x, _y);
data[CheckpointData.x] = _x;
data[CheckpointData.y] = _y;
data[CheckpointData.dir] = sign_nonzero(targetDir);