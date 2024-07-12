// Defines checkpoints for your level
// This is a more precise version of objCheckpoint:
// - It's triggered from the player touching it, rather than when it comes onscreen
// - The position of the checkpoint is set manually by the user

__x = (targetX != -1) ? targetX : bbox_x_center();
__y = (targetY != -1) ? targetY : bbox_bottom - 16;
__dir = sign_nonzero(targetDir);