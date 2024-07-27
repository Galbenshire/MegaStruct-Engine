// Defines checkpoints for your level, simply plop one into the room
// In-game, it will trigger once it comes on-screen
// Its position in the room determines the location of the checkpoint
// Flip it horizontally in the room editor to set the direction Mega Man faces on respawning

name = (string_length(name) > 0) ? name : string("Checkpoint_{0}_{1}", x, y);

data = [room, x, y, sign_nonzero(image_xscale), name]; /// @is {CheckpointData}