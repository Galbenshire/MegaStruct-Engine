// Defines checkpoints for your level, simply plop one into the room
// In-game, it will trigger once it comes on-screen
// Its position in the room determines the location of the checkpoint
// Flip it horizontally in the room editor to set the direction Mega Man faces on respawning

data = array_create(CheckpointData.sizeof);
data[CheckpointData.name] = !string_empty(name) ? name : string("Checkpoint_{0}_{1}_{2}", room_get_name(room), x, y);
data[CheckpointData.room] = room;
data[CheckpointData.x] = x;
data[CheckpointData.y] = y;
data[CheckpointData.dir] = sign_nonzero(image_xscale);