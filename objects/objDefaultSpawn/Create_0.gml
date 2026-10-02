// This object denotes the beginning point of your level

checkpointData = array_create(CheckpointData.sizeof);
checkpointData[CheckpointData.name] = !string_empty(name) ? name : string("DefaultSpawn_{0}_{1}_{2}", room_get_name(room), x, y);
checkpointData[CheckpointData.room] = room;
checkpointData[CheckpointData.x] = x;
checkpointData[CheckpointData.y] = y;
checkpointData[CheckpointData.dir] = sign_nonzero(image_xscale);
checkpointData[CheckpointData.animation] = respawnAnim;
