// This object denotes the beginning point of your level

name = (string_length(name) > 0) ? name : "DefaultSpawn";

checkpointData = [room, x, y, sign_nonzero(image_xscale), name]; /// @is {CheckpointData}
