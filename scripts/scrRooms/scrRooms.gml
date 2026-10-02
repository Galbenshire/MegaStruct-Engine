#region Checkpoints

/// @func checkpoint_find(name)
/// @desc Finds a checkpoint in the current room, given a name
///
/// @param {string}  name  The name of the checkpoint
///
/// @returns {CheckpointData?}  The checkpoint data, or `undefined` if nothing was found
function checkpoint_find(_name) {
	var _checkpoints = objSystem.debug.checkpointList;
	var i = 0; repeat(array_length(_checkpoints)) {
		if (_checkpoints[i][CheckpointData.name] == _name)
			return _checkpoints[i];
		i++;
	}
	return undefined;
}

/// @func checkpoint_get_name()
/// @desc Gets the current checkpoint's name/ID
///
/// @returns {room}  The name of the current checkpoint
function checkpoint_get_name() {
	return objSystem.level.checkpoint[CheckpointData.name];
}

/// @func checkpoint_get_room()
/// @desc Gets the current checkpoint's assigned room
///
/// @returns {room}  The room of the current checkpoint
function checkpoint_get_room() {
	return objSystem.level.checkpoint[CheckpointData.room];
}

#endregion

#region Other

/// @func go_to_level(level)
/// @desc Takes the game to a room tagged as a level, performing any extra steps necessary
///
/// @param {room}  level  The level to go to (make sure it has the "room_level" tag)
function go_to_level(_level) {
	assert(is_room_level(_level), "calling go_to_level to a room not tagged as a level");
	
	objSystem.level.__startLevel = true;
	go_to_room(_level);
}

/// @func go_to_room(room, instant)
/// @desc Helper function to switch rooms
///
/// @param {room}  room  The new room to go to
/// @param {bool}  [instant]  If true, the screenfade is skipped. Defaults to false.
function go_to_room(_room, _instant = false) {
	if (_instant) {
		global.previousRoom = room;
		room_goto(_room);
		return;
	}
	
	screen_fade({
		persistent: true,
		nextRoom: _room,
		onFadeInStart: function(_fader) {
			global.previousRoom = room;
			room_goto(_fader.nextRoom);
		}
	});
}

/// @func is_room_level(room)
/// @desc Checks if the given room is tagged as a level
///
/// @param {room}  room  The room to check
///
/// @return {bool}  Whether this room is a level (true) or not (false)
function is_room_level(_room) {
	return asset_has_tags(_room, "room_level", asset_room);
}

/// @func restart_room(instant)
/// @desc Resets the current room
///
/// @param {bool}  [instant]  If true, the screenfade is skipped. Defaults to false.
function restart_room(_instant = false) {
	go_to_room(room, _instant);
}

#endregion
